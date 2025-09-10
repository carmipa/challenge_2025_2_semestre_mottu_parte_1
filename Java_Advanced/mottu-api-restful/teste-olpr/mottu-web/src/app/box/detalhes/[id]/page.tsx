// src/app/box/detalhes/[id]/page.tsx
"use client";

import { useState, useEffect } from 'react';
import { useParams } from 'next/navigation';
import Link from 'next/link';
import NavBar from '@/components/nav-bar';
import { BoxService } from '@/utils/api';
import { BoxResponseDto } from '@/types/box';
import { Loader2, AlertCircle, Box as BoxIcon, Calendar, Info, Edit, ArrowLeft, Text } from 'lucide-react';

export default function DetalhesBoxPage() {
    const params = useParams();
    const id = typeof params.id === 'string' ? parseInt(params.id, 10) : null;

    const [box, setBox] = useState<BoxResponseDto | null>(null);
    const [isLoading, setIsLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);

    const formatDate = (dateString: string | null | undefined): string => {
        if (!dateString) return 'N/A';
        try {
            return new Date(dateString + 'T00:00:00Z').toLocaleDateString('pt-BR', { timeZone: 'UTC' });
        } catch {
            return 'Data inválida';
        }
    };

    useEffect(() => {
        if (!id) {
            setError("ID do box inválido.");
            setIsLoading(false);
            return;
        }
        const fetchBox = async () => {
            setIsLoading(true);
            try {
                const data = await BoxService.getById(id);
                setBox(data);
            } catch (err: any) {
                setError(err.response?.data?.message || "Box não encontrado ou erro ao carregar dados.");
            } finally {
                setIsLoading(false);
            }
        };
        fetchBox();
    }, [id]);

    if (isLoading) return (
        <>
            <NavBar active="box" />
            <main className="flex justify-center items-center min-h-screen bg-black"><Loader2 className="h-12 w-12 animate-spin text-[var(--color-mottu-light)]" /></main>
        </>
    );

    if (error) return (
        <>
            <NavBar active="box" />
            <main className="flex justify-center items-center min-h-screen bg-black p-4">
                <div className="text-center bg-red-900/50 p-8 rounded-lg">
                    <AlertCircle className="mx-auto h-12 w-12 text-red-400" />
                    <p className="mt-4 text-red-400">{error}</p>
                    <Link href="/box/listar" className="mt-6 inline-flex items-center gap-2 px-6 py-2 bg-slate-600 text-white rounded-md"><ArrowLeft size={18}/> Voltar para Lista</Link>
                </div>
            </main>
        </>
    );

    if (!box) return null;

    return (
        <>
            <NavBar active="box" />
            <main className="min-h-screen bg-black text-white p-4 md:p-8">
                <div className="container max-w-4xl mx-auto bg-[var(--color-mottu-default)] p-6 md:p-8 rounded-lg shadow-xl">
                    <div className="flex flex-col sm:flex-row justify-between items-start mb-6">
                        <div>
                            <h1 className="text-2xl md:text-3xl font-bold text-white">{box.nome}</h1>
                            <p className="text-slate-300">Detalhes do Box (ID: {box.idBox})</p>
                        </div>
                        <div className="flex gap-2 mt-4 sm:mt-0">
                            <Link href="/box/listar" className="flex items-center gap-2 px-4 py-2 font-medium text-[var(--color-mottu-dark)] bg-white rounded-md shadow hover:bg-gray-100">
                                <ArrowLeft size={18} /> Voltar
                            </Link>
                            <Link href={`/box/alterar/${box.idBox}`} className="flex items-center gap-2 px-4 py-2 font-semibold text-white bg-[var(--color-mottu-dark)] rounded-md shadow hover:bg-opacity-80">
                                <Edit size={18} /> Editar
                            </Link>
                        </div>
                    </div>

                    <div className="bg-black/20 p-4 rounded-lg">
                        <h2 className="text-xl font-semibold mb-3 text-slate-100 flex items-center"><BoxIcon className="mr-2"/>Dados do Box</h2>
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-x-6 gap-y-2 text-sm">
                            <p><strong>Nome:</strong> {box.nome}</p>
                            <p><strong>Status:</strong> <span className={box.status === 'L' ? 'text-green-400' : 'text-red-400'}>{box.status === 'L' ? 'Livre' : 'Ocupado'}</span></p>
                            <p><strong>Data de Entrada:</strong> {formatDate(box.dataEntrada)}</p>
                            <p><strong>Data de Saída:</strong> {formatDate(box.dataSaida)}</p>
                            <p className="md:col-span-2"><strong>Observação:</strong> {box.observacao || '-'}</p>
                        </div>
                    </div>
                </div>
            </main>
        </>
    );
}