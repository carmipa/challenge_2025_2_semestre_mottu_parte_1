// src/app/veiculo/cadastrar/page.tsx
"use client";

import React, { useState, FormEvent, ChangeEvent } from 'react'; // Adicionado ChangeEvent
import Link from 'next/link';
import NavBar from '@/components/nav-bar';
import { MdAddCircleOutline, MdSave, MdArrowBack, MdErrorOutline, MdCheckCircle } from 'react-icons/md';
import { Car, Hash, Building, Settings, Calendar as CalendarIcon, Info } from 'lucide-react'; // Renomeado Calendar para CalendarIcon
import { VeiculoRequestDto, VeiculoResponseDto, combustiveis, CombustivelType } from '@/types/veiculo'; // Ajuste o path
import { VeiculoService } from '@/services/VeiculoService'; // Ajuste o path

export default function CadastrarVeiculoPage() {
    const initialState: VeiculoRequestDto = {
        placa: '', renavam: '', chassi: '', fabricante: '', modelo: '',
        motor: '', ano: new Date().getFullYear(), combustivel: '',
    };
    const [formData, setFormData] = useState<VeiculoRequestDto>(initialState);
    const [isLoading, setIsLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);
    const [success, setSuccess] = useState<string | null>(null);

    const handleChange = (e: ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
        const { name, value } = e.target;
        if (name === "ano") {
            setFormData(prev => ({ ...prev, ano: parseInt(value, 10) || 0 }));
        } else {
            setFormData(prev => ({ ...prev, [name]: value }));
        }
    };

    const handleSubmit = async (e: FormEvent<HTMLFormElement>) => {
        e.preventDefault();
        setIsLoading(true);
        setError(null);
        setSuccess(null);

        const payload = {
            ...formData,
            ano: Number(formData.ano) // Certifica que ano é number
        };

        try {
            const createdVeiculo: VeiculoResponseDto = await VeiculoService.create(payload);
            setSuccess(`✅ Veículo "${createdVeiculo.placa}" (ID: ${createdVeiculo.idVeiculo}) cadastrado com sucesso!`);
            setFormData(initialState); // Limpa o formulário
            setTimeout(() => setSuccess(null), 5000);
        } catch (err: any) {
            const apiError = err.response?.data;
            if (apiError && typeof apiError === 'object') {
                if (apiError.errors) {
                    const messages = Object.values(apiError.errors).flat().join('; ');
                    setError(`❌ Erro de validação: ${messages}`);
                } else if (apiError.message) {
                    setError(`❌ ${apiError.message}`);
                }  else if (typeof apiError === 'string' && apiError.includes("ORA-00001")) { // Exemplo de tratamento de erro de unique constraint do Oracle
                    setError('❌ Erro: Já existe um veículo com a mesma Placa, RENAVAM ou Chassi.');
                }
                else {
                    setError(`❌ ${JSON.stringify(apiError)}`);
                }
            } else if (err.message) {
                setError(`❌ ${err.message}`);
            } else {
                setError('Falha ao cadastrar veículo. Verifique os dados e tente novamente.');
            }
            console.error("Erro detalhado ao cadastrar veículo:", err.response || err);
        } finally {
            setIsLoading(false);
        }
    };

    return (
        <>
            <NavBar active="veiculo-cadastrar" />
            <main className="container mx-auto px-4 py-12 bg-[#012A46] min-h-screen text-white">
                <div className="bg-slate-900 p-6 md:p-8 rounded-lg shadow-xl w-full max-w-4xl mx-auto">
                    <h1 className="flex items-center justify-center gap-2 text-2xl md:text-3xl font-bold mb-8 text-center">
                        <Car className="text-3xl text-sky-400" /> Novo Veículo {/* Ícone Car */}
                    </h1>

                    {error && (
                        <div className="relative text-red-400 bg-red-900/50 p-4 pr-10 rounded border border-red-500 mb-4" role="alert">
                            <div className="flex items-center gap-2"> <MdErrorOutline className="text-xl" /> <span>{error}</span> </div>
                            <button type="button" className="absolute top-0 bottom-0 right-0 px-4 py-3 hover:text-red-200" onClick={() => setError(null)} aria-label="Fechar"><span className="text-xl">&times;</span></button>
                        </div>
                    )}
                    {success && (
                        <div className="flex items-center justify-center gap-2 text-green-400 p-3 rounded bg-green-900/30 border border-green-700 mb-4">
                            <MdCheckCircle className="text-xl" /> <span>{success}</span>
                        </div>
                    )}

                    <form onSubmit={handleSubmit} className="space-y-5">
                        <fieldset className="mb-6 border border-slate-700 p-4 rounded">
                            <legend className="text-xl font-semibold mb-2 px-2">Detalhes do Veículo</legend>
                            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <div>
                                    <label htmlFor="placa" className="block mb-1 flex items-center gap-1"><Hash size={16} /> Placa:</label>
                                    <input type="text" id="placa" name="placa" value={formData.placa} onChange={handleChange} required maxLength={10} className="w-full p-2 rounded bg-slate-800 border border-slate-700 focus:ring-sky-500 h-10" />
                                </div>
                                <div>
                                    <label htmlFor="renavam" className="block mb-1 flex items-center gap-1"><Info size={16} /> RENAVAM:</label> {/* Usando Info como placeholder, pode trocar para ScanLine se disponível */}
                                    <input type="text" id="renavam" name="renavam" value={formData.renavam} onChange={handleChange} required maxLength={11} className="w-full p-2 rounded bg-slate-800 border border-slate-700 focus:ring-sky-500 h-10" />
                                </div>
                                <div>
                                    <label htmlFor="chassi" className="block mb-1 flex items-center gap-1"><Hash size={16} /> Chassi:</label>
                                    <input type="text" id="chassi" name="chassi" value={formData.chassi} onChange={handleChange} required maxLength={17} className="w-full p-2 rounded bg-slate-800 border border-slate-700 focus:ring-sky-500 h-10" />
                                </div>
                                <div>
                                    <label htmlFor="fabricante" className="block mb-1 flex items-center gap-1"><Building size={16} /> Fabricante:</label>
                                    <input type="text" id="fabricante" name="fabricante" value={formData.fabricante} onChange={handleChange} required maxLength={50} className="w-full p-2 rounded bg-slate-800 border border-slate-700 focus:ring-sky-500 h-10" />
                                </div>
                                <div>
                                    <label htmlFor="modelo" className="block mb-1 flex items-center gap-1"><Car size={16} /> Modelo:</label>
                                    <input type="text" id="modelo" name="modelo" value={formData.modelo} onChange={handleChange} required maxLength={60} className="w-full p-2 rounded bg-slate-800 border border-slate-700 focus:ring-sky-500 h-10" />
                                </div>
                                <div>
                                    <label htmlFor="motor" className="block mb-1 flex items-center gap-1"><Settings size={16} /> Motor:</label>
                                    <input type="text" id="motor" name="motor" value={formData.motor || ''} onChange={handleChange} maxLength={30} className="w-full p-2 rounded bg-slate-800 border border-slate-700 focus:ring-sky-500 h-10" />
                                </div>
                                <div>
                                    <label htmlFor="ano" className="block mb-1 flex items-center gap-1"><CalendarIcon size={16} /> Ano:</label>
                                    <input type="number" id="ano" name="ano" value={formData.ano} onChange={handleChange} required min={1900} max={new Date().getFullYear() + 2} className="w-full p-2 rounded bg-slate-800 border border-slate-700 focus:ring-sky-500 h-10" />
                                </div>
                                <div>
                                    <label htmlFor="combustivel" className="block mb-1 flex items-center gap-1"><Info size={16} /> Combustível:</label>
                                    <select id="combustivel" name="combustivel" value={formData.combustivel} onChange={handleChange} required className="w-full p-2 rounded bg-slate-800 border border-slate-700 focus:ring-sky-500 h-10">
                                        <option value="">Selecione...</option>
                                        {combustiveis.map(cb => (<option key={cb} value={cb}>{cb}</option>))}
                                    </select>
                                </div>
                            </div>
                        </fieldset>

                        <div className="flex flex-col sm:flex-row items-center justify-center gap-4 pt-4">
                            <button
                                type="submit"
                                className={`flex items-center justify-center gap-2 px-6 py-3 font-semibold text-white bg-sky-600 rounded-md shadow hover:bg-sky-700 focus:outline-none focus:ring-2 focus:ring-sky-500 focus:ring-offset-2 focus:ring-offset-slate-900 transition-opacity duration-300 ${isLoading ? 'opacity-50 cursor-not-allowed' : ''}`}
                                disabled={isLoading}
                            >
                                <MdSave size={20} /> {isLoading ? 'Salvando...' : 'Salvar Veículo'}
                            </button>
                            <Link href="/veiculo/listar" className="flex items-center justify-center gap-2 px-6 py-3 font-semibold text-white bg-slate-600 rounded-md shadow hover:bg-slate-700 text-center focus:outline-none focus:ring-2 focus:ring-slate-500 focus:ring-offset-2 focus:ring-offset-slate-900">
                                <MdArrowBack size={20} /> Voltar para Lista
                            </Link>
                        </div>
                    </form>
                </div>
            </main>
            <style jsx global>{`
                input[type="number"]::-webkit-inner-spin-button,
                input[type="number"]::-webkit-outer-spin-button {
                    -webkit-appearance: none; margin: 0;
                }
                input[type="number"] { -moz-appearance: textfield; }
            `}</style>
        </>
    );
}