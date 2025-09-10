// src/app/zona/listar/page.tsx
"use client";
import { useState, useEffect, FormEvent, ChangeEvent } from 'react';
import Link from 'next/link';
import NavBar from '@/components/nav-bar';
import { ZonaService } from '@/utils/api';
import { ZonaResponseDto, ZonaFilter } from '@/types/zona';
import { SpringPage } from '@/types/common';
import { MdSearch, MdClear, MdAdd, MdChevronLeft, MdChevronRight, MdEdit, MdDelete, MdVisibility, MdErrorOutline } from 'react-icons/md';
import { Map as MapIcon } from 'lucide-react';

const initialFilterState: ZonaFilter = { nome: "" };

export default function ListarZonasPage() {
    const [zonas, setZonas] = useState<ZonaResponseDto[]>([]);
    const [pageInfo, setPageInfo] = useState<SpringPage<ZonaResponseDto> | null>(null);
    const [currentPage, setCurrentPage] = useState(0);
    const [filtros, setFiltros] = useState<ZonaFilter>(initialFilterState);
    const [isLoading, setIsLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);

    const ITEMS_PER_PAGE = 9;

    const fetchData = async (page = 0, currentFilters = filtros) => {
        setIsLoading(true);
        setError(null);
        try {
            const data = await ZonaService.listarPaginadoFiltrado(currentFilters, page, ITEMS_PER_PAGE);
            setZonas(data.content);
            setPageInfo(data);
            setCurrentPage(data.number);
        } catch (err: any) {
            setError(err.response?.data?.message || 'Erro ao buscar zonas.');
        } finally {
            setIsLoading(false);
        }
    };

    useEffect(() => {
        fetchData();
    }, []);

    const handleFilterChange = (e: ChangeEvent<HTMLInputElement>) => {
        setFiltros({ ...filtros, [e.target.name]: e.target.value });
    };

    const handleFilterSubmit = (e: FormEvent) => {
        e.preventDefault();
        fetchData(0, filtros);
    };

    const handleClearFilters = () => {
        setFiltros(initialFilterState);
        fetchData(0, initialFilterState);
    };

    const handlePageChange = (newPage: number) => {
        fetchData(newPage, filtros);
    };

    return (
        <>
            <NavBar active="zona" />
            <main className="min-h-screen bg-black text-white p-4 md:p-8">
                <div className="container mx-auto bg-[var(--color-mottu-default)] p-6 md:p-8 rounded-lg shadow-xl">
                    <div className="flex flex-col sm:flex-row justify-between items-center mb-8">
                        <h1 className="text-2xl md:text-3xl font-bold text-white flex items-center">
                            <MapIcon size={32} className="mr-3" />
                            Zonas Cadastradas
                        </h1>
                        <Link href="/zona/cadastrar" className="mt-4 sm:mt-0 flex items-center gap-2 px-4 py-2.5 font-semibold text-[var(--color-mottu-dark)] bg-white rounded-md shadow hover:bg-gray-100">
                            <MdAdd size={20} /> Nova Zona
                        </Link>
                    </div>
                    {error && <div className="mb-4 text-center text-red-700 p-3 rounded-md bg-red-100"><MdErrorOutline className="inline mr-2" />{error}</div>}
                    <form onSubmit={handleFilterSubmit} className="mb-8 p-4 bg-black/20 rounded-lg">
                        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4 items-end">
                            <input type="text" name="nome" value={filtros.nome} onChange={handleFilterChange} placeholder="Filtrar por nome..." className="w-full p-2 h-10 rounded bg-white text-slate-900"/>
                            <div className="flex gap-2 md:col-start-3">
                                <button type="submit" className="flex-1 flex items-center justify-center gap-2 h-10 px-4 font-semibold text-white bg-[var(--color-mottu-dark)] rounded-md hover:bg-opacity-80">
                                    <MdSearch /> Buscar
                                </button>
                                <button type="button" onClick={handleClearFilters} className="flex-1 flex items-center justify-center gap-2 h-10 px-4 font-medium text-slate-700 bg-gray-200 rounded-md hover:bg-gray-300">
                                    <MdClear /> Limpar
                                </button>
                            </div>
                        </div>
                    </form>
                    {isLoading ? <p className="text-center text-slate-100 py-10">Carregando...</p> : zonas.length > 0 ? (
                        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
                            {zonas.map((zona) => (
                                <div key={zona.idZona} className="bg-white text-slate-800 rounded-lg shadow-lg p-5 flex flex-col justify-between transition-all hover:shadow-2xl hover:scale-105">
                                    <div>
                                        <div className="flex items-center mb-3">
                                            <span className="text-xs font-semibold bg-slate-200 text-slate-700 px-2 py-0.5 rounded-full mr-2">ID: {zona.idZona}</span>
                                            <h2 className="text-xl font-bold text-[var(--color-mottu-dark)] truncate">{zona.nome}</h2>
                                        </div>
                                        <p className="text-sm text-slate-600">Entrada: {new Date(zona.dataEntrada).toLocaleDateString('pt-BR')}</p>
                                    </div>
                                    <div className="flex justify-end items-center gap-2 border-t border-slate-200 pt-3 mt-4">
                                        <Link href={`/zona/detalhes/${zona.idZona}`} className="p-2 rounded-full text-blue-600 hover:bg-blue-100" title="Ver Detalhes"><MdVisibility size={22}/></Link>
                                        <Link href={`/zona/alterar/${zona.idZona}`} className="p-2 rounded-full text-yellow-500 hover:bg-yellow-100" title="Editar Zona"><MdEdit size={20}/></Link>
                                        <Link href={`/zona/deletar/${zona.idZona}`} className="p-2 rounded-full text-red-500 hover:bg-red-100" title="Excluir Zona"><MdDelete size={20}/></Link>
                                    </div>
                                </div>
                            ))}
                        </div>
                    ) : <p className="text-center text-slate-300 py-10">Nenhuma zona encontrada.</p>}
                    {!isLoading && pageInfo && pageInfo.totalPages > 1 && (
                        <div className="mt-8 flex justify-between items-center text-sm text-slate-100">
                            <span>Página {pageInfo.number + 1} de {pageInfo.totalPages}</span>
                            <div className="flex gap-2">
                                <button onClick={() => handlePageChange(currentPage - 1)} disabled={pageInfo.first} className="px-3 py-1.5 rounded-md bg-slate-700 hover:bg-slate-600 disabled:opacity-50"><MdChevronLeft/></button>
                                <button onClick={() => handlePageChange(currentPage + 1)} disabled={pageInfo.last} className="px-3 py-1.5 rounded-md bg-slate-700 hover:bg-slate-600 disabled:opacity-50"><MdChevronRight/></button>
                            </div>
                        </div>
                    )}
                </div>
            </main>
        </>
    );
}