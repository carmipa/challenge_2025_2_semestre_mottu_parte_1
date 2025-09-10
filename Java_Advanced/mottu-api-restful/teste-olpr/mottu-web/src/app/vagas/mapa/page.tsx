"use client";

import { useEffect, useMemo, useState } from "react";
import { useSearchParams, useRouter } from "next/navigation";

type BoxResponseDto = {
    idBox: number;
    nome: string;
    status: string;
    dataEntrada: string | null;
    dataSaida: string | null;
    observacao: string | null;
};

type BoxWithPlateResponse = {
    box: BoxResponseDto;
    placa: string | null;
};

type MapaResponse = {
    rows: number;
    cols: number;
    boxes: BoxWithPlateResponse[];
};

export default function MapaVagasPage() {
    const params = useSearchParams();
    const router = useRouter();

    const highlight = (params.get("highlight") || "").toUpperCase(); // pode ser id numérico como string
    const placaParam = params.get("placa") || "";
    const boxNomeParam = params.get("box") || "";

    const [mapa, setMapa] = useState<MapaResponse | null>(null);

    useEffect(() => {
        let alive = true;
        const fetchMapa = async () => {
            const res = await fetch("/api/vagas/mapa", { cache: "no-store" });
            if (!res.ok) return;
            const data = (await res.json()) as MapaResponse;
            if (alive) setMapa(data);
        };
        fetchMapa();
        const t = setInterval(fetchMapa, 2000);
        return () => { alive = false; clearInterval(t); };
    }, []);

    const gridStyle = useMemo(() => {
        if (!mapa) return { gridTemplateColumns: "repeat(5, minmax(0,1fr))" };
        return { gridTemplateColumns: `repeat(${mapa.cols}, minmax(0,1fr))` };
    }, [mapa]);

    const isOcupado = (b: BoxWithPlateResponse) => (b.box.status ?? "").toUpperCase() === "O";

    const onLiberar = async (boxId: number) => {
        if (!confirm(`Liberar box ${boxId}?`)) return;
        const res = await fetch(`/api/vagas/liberar/${boxId}`, { method: "POST" });
        if (res.ok) router.replace("/vagas/mapa");
    };

    return (
        <main className="min-h-screen bg-black text-white p-6">
            <div className="mx-auto max-w-5xl">
                <div className="flex items-baseline justify-between mb-6">
                    <h1 className="text-3xl font-bold">Mapa de Vagas (2D)</h1>
                    <div className="text-sm text-zinc-400">
                        {placaParam ? (
                            <>
                                Placa: <span className="font-mono text-emerald-300">{placaParam}</span>
                                {boxNomeParam ? <> • Box: <span className="font-mono">{boxNomeParam}</span></> : null}
                            </>
                        ) : null}
                    </div>
                </div>

                <div className="rounded-2xl border border-zinc-700 bg-zinc-900 p-4">
                    {!mapa ? (
                        <div className="text-zinc-300">Carregando mapa...</div>
                    ) : (
                        <div className="grid gap-3" style={gridStyle}>
                            {mapa.boxes.map((item) => {
                                const b = item.box;
                                const isHL =
                                    highlight &&
                                    (String(b.idBox).toUpperCase() === highlight || (b.nome || "").toUpperCase() === highlight);
                                const ocupado = isOcupado(item);
                                return (
                                    <div
                                        key={b.idBox}
                                        className={[
                                            "relative rounded-xl border p-4 transition",
                                            ocupado ? "border-emerald-600 bg-emerald-600/10" : "border-zinc-700 bg-zinc-800",
                                            isHL ? "ring-4 ring-amber-400/60 animate-pulse" : ""
                                        ].join(" ")}
                                    >
                                        <div className="text-sm text-zinc-300">{b.nome || `BOX ${b.idBox}`}</div>
                                        <div className="mt-2 text-2xl font-mono tracking-widest">
                                            {ocupado ? (item.placa || "OCUPADO") : "LIVRE"}
                                        </div>
                                        <div className="mt-3 flex gap-2">
                                            {ocupado ? (
                                                <button
                                                    onClick={() => onLiberar(b.idBox)}
                                                    className="px-3 py-1 rounded-lg bg-rose-600 hover:bg-rose-700 text-sm"
                                                >
                                                    Liberar
                                                </button>
                                            ) : (
                                                <span className="text-xs text-zinc-400">Disponível</span>
                                            )}
                                        </div>
                                    </div>
                                );
                            })}
                        </div>
                    )}
                </div>

                <div className="mt-6 flex gap-3">
                    <button
                        onClick={() => router.push("/vagas/buscar")}
                        className="px-4 py-2 rounded-xl bg-emerald-600 hover:bg-emerald-700"
                    >
                        Buscar outra placa
                    </button>
                    <button
                        onClick={() => router.push("/radar/armazenar")}
                        className="px-4 py-2 rounded-xl bg-zinc-700 hover:bg-zinc-600"
                    >
                        Voltar ao Radar (OCR)
                    </button>
                </div>
            </div>
        </main>
    );
}
