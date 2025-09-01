"use client";

import { useState, useEffect } from 'react';
import NavBar from '@/components/nav-bar';
import { VeiculoService, PatioService, BoxService } from '@/utils/api';
import { VeiculoLocalizacaoResponseDto } from '@/types/veiculo';
import { Loader2, ParkingSquare, Car, MapPinned, AlertTriangle } from 'lucide-react';
import Link from 'next/link';

export default function DashboardPage() {
    const [isLoading, setIsLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [stats, setStats] = useState({ totalPatios: 0, totalBoxes: 0, boxesOcupados: 0 });
    const [veiculosEstacionados, setVeiculosEstacionados] = useState<VeiculoLocalizacaoResponseDto[]>([]);

    useEffect(() => {
        const fetchData = async () => {
            setIsLoading(true);
            setError(null);
            try {
                // Busca os totais e a lista de boxes em paralelo
                const [patiosData, boxesData] = await Promise.all([
                    PatioService.listarPaginadoFiltrado({}, 0, 1), // Apenas para obter o total de pátios
                    BoxService.listarPaginadoFiltrado({}, 0, 500)  // Busca todos os boxes para análise
                ]);

                // Filtra os boxes que estão ocupados
                const boxesOcupados = boxesData.content.filter(b => b.status === 'O');

                // Para cada box ocupado, procura o veículo associado
                const veiculosPromises = boxesOcupados.map(async (box) => {
                    try {
                        // A API buscará um veículo que esteja associado a este nome de box
                        const veiculoPage = await VeiculoService.buscarPorFiltro({ boxNome: box.nome }, 0, 1);
                        if (veiculoPage.content.length > 0) {
                            // Se encontrou um veículo, busca a sua localização completa
                            return VeiculoService.getLocalizacao(veiculoPage.content[0].idVeiculo);
                        }
                        return null;
                    } catch (e) {
                        console.error(`Erro ao buscar veículo para o box ${box.nome}:`, e);
                        return null; // Retorna nulo se houver erro para um veículo específico
                    }
                });

                // Aguarda todas as buscas de localização e filtra os resultados nulos
                const veiculosComLocalizacao = (await Promise.all(veiculosPromises)).filter(v => v !== null) as VeiculoLocalizacaoResponseDto[];

                // Atualiza o estado com os dados corretos
                setStats({
                    totalPatios: patiosData.totalElements,
                    totalBoxes: boxesData.totalElements,
                    boxesOcupados: boxesOcupados.length
                });

                setVeiculosEstacionados(veiculosComLocalizacao);

            } catch (error: any) {
                console.error("Erro ao carregar dados do dashboard:", error);
                setError("Não foi possível carregar os dados do dashboard. Verifique a conexão com a API.");
            } finally {
                setIsLoading(false);
            }
        };

        fetchData();
    }, []);

    if (isLoading) {
        return (
            <>
                <NavBar active="dashboard" />
                <main className="flex justify-center items-center min-h-screen bg-black">
                    <div className="flex flex-col items-center gap-2 text-white">
                        <Loader2 className="h-12 w-12 animate-spin text-[var(--color-mottu-light)]" />
                        <span>A carregar dados do dashboard...</span>
                    </div>
                </main>
            </>
        )
    }

    if (error) {
        return (
            <>
                <NavBar active="dashboard" />
                <main className="flex justify-center items-center min-h-screen bg-black p-4">
                    <div className="text-center bg-red-900/50 p-8 rounded-lg">
                        <AlertTriangle className="mx-auto h-12 w-12 text-red-400" />
                        <p className="mt-4 text-red-400">{error}</p>
                    </div>
                </main>
            </>
        )
    }

    return (
        <>
            <NavBar active="dashboard" />
            <main className="min-h-screen bg-black text-white p-4 md:p-8">
                <div className="container mx-auto">
                    <h1 className="text-3xl font-bold text-white mb-8">Dashboard Gerencial</h1>

                    <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                        <div className="bg-[var(--color-mottu-default)] p-6 rounded-lg shadow-lg">
                            <h2 className="text-lg font-semibold text-slate-200 flex items-center gap-2"><MapPinned/> Pátios Totais</h2>
                            <p className="text-4xl font-bold text-white">{stats.totalPatios}</p>
                        </div>
                        <div className="bg-[var(--color-mottu-default)] p-6 rounded-lg shadow-lg">
                            <h2 className="text-lg font-semibold text-slate-200 flex items-center gap-2"><ParkingSquare/> Vagas Totais (Boxes)</h2>
                            <p className="text-4xl font-bold text-white">{stats.totalBoxes}</p>
                        </div>
                        <div className="bg-[var(--color-mottu-default)] p-6 rounded-lg shadow-lg">
                            <h2 className="text-lg font-semibold text-slate-200 flex items-center gap-2"><Car/> Vagas Ocupadas</h2>
                            <p className="text-4xl font-bold text-white">{stats.boxesOcupados}</p>
                        </div>
                    </div>

                    <div className="bg-[var(--color-mottu-default)] p-6 rounded-lg shadow-lg">
                        <h2 className="text-2xl font-bold text-white mb-4">Motos Estacionadas</h2>
                        <div className="overflow-x-auto">
                            <table className="w-full text-left text-sm">
                                <thead className="bg-black/20 text-slate-200">
                                <tr>
                                    <th className="p-3">Matrícula</th>
                                    <th className="p-3">Modelo</th>
                                    <th className="p-3">Localização (Box)</th>
                                    <th className="p-3">Pátio</th>
                                    <th className="p-3">Ações</th>
                                </tr>
                                </thead>
                                <tbody>
                                {veiculosEstacionados.length > 0 ? (
                                    veiculosEstacionados.map(v => (
                                        <tr key={v.idVeiculo} className="border-b border-slate-700 hover:bg-black/20">
                                            <td className="p-3 font-mono">{v.placa}</td>
                                            <td className="p-3">{v.modelo}</td>
                                            <td className="p-3">{v.boxAssociado?.nome}</td>
                                            <td className="p-3">{v.patioAssociado?.nomePatio || '-'}</td>
                                            <td className="p-3">
                                                <Link href={`/veiculo/detalhes/${v.idVeiculo}`} className="text-sky-300 hover:underline">
                                                    Ver Detalhes
                                                </Link>
                                            </td>
                                        </tr>
                                    ))
                                ) : (
                                    <tr>
                                        <td colSpan={5} className="text-center p-6 text-slate-300">Nenhuma moto estacionada no momento.</td>
                                    </tr>
                                )}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </>
    );
}

