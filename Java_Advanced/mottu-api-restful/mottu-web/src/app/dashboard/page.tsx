// src/app/dashboard/page.tsx
"use client";
import { useState, useEffect } from 'react';
import NavBar from '@/components/nav-bar';
import { VeiculoService, PatioService, BoxService, ZonaService } from '@/utils/api';
import { VeiculoResponseDto } from '@/types/veiculo';
import { PatioResponseDto } from '@/types/patio';
import { BoxResponseDto } from '@/types/box';
import { Loader2, ParkingSquare, Car, MapPinned } from 'lucide-react';

export default function DashboardPage() {
    const [isLoading, setIsLoading] = useState(true);
    const [stats, setStats] = useState({ totalPatios: 0, totalBoxes: 0, boxesOcupados: 0 });
    const [veiculosEstacionados, setVeiculosEstacionados] = useState<any[]>([]);

    useEffect(() => {
        const fetchData = async () => {
            try {
                // Simulação de busca de dados agregados. O ideal seria ter endpoints específicos no backend.
                const patiosData = await PatioService.listarPaginadoFiltrado({}, 0, 100);
                const boxesData = await BoxService.listarPaginadoFiltrado({}, 0, 500);

                const veiculosComLocalizacao = [];
                const veiculosData = await VeiculoService.listarPaginadoFiltrado({}, 0, 500);

                for (const veiculo of veiculosData.content) {
                    const localizacao = await VeiculoService.getLocalizacao(veiculo.idVeiculo);
                    if (localizacao.boxAssociado) {
                        veiculosComLocalizacao.push({ ...veiculo, localizacao });
                    }
                }

                setStats({
                    totalPatios: patiosData.totalElements,
                    totalBoxes: boxesData.totalElements,
                    boxesOcupados: boxesData.content.filter(b => b.status === 'O').length
                });
                setVeiculosEstacionados(veiculosComLocalizacao);
            } catch (error) {
                console.error("Erro ao carregar dados do dashboard:", error);
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
                <main className="flex justify-center items-center min-h-screen bg-black"><Loader2 className="h-12 w-12 animate-spin text-[var(--color-mottu-light)]" /></main>
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
                                    <th className="p-3">Placa</th>
                                    <th className="p-3">Modelo</th>
                                    <th className="p-3">Localização (Box)</th>
                                    <th className="p-3">Pátio</th>
                                </tr>
                                </thead>
                                <tbody>
                                {veiculosEstacionados.length > 0 ? (
                                    veiculosEstacionados.map(v => (
                                        <tr key={v.idVeiculo} className="border-b border-slate-700 hover:bg-black/20">
                                            <td className="p-3 font-mono">{v.placa}</td>
                                            <td className="p-3">{v.modelo}</td>
                                            <td className="p-3">{v.localizacao.boxAssociado?.nome}</td>
                                            <td className="p-3">{v.localizacao.patioAssociado?.nomePatio || '-'}</td>
                                        </tr>
                                    ))
                                ) : (
                                    <tr>
                                        <td colSpan={4} className="text-center p-6 text-slate-300">Nenhuma moto estacionada no momento.</td>
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