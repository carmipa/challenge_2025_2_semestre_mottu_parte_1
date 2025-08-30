// src/components/OcrScanner.tsx
"use client";
import React, { useRef, useState, useCallback } from 'react';
import Webcam from 'react-webcam';
import { createWorker } from 'tesseract.js';
import { Camera, Loader2, ScanLine } from 'lucide-react';

interface OcrScannerProps {
    onPlateRecognized: (plate: string) => void;
}

const OcrScanner: React.FC<OcrScannerProps> = ({ onPlateRecognized }) => {
    const webcamRef = useRef<Webcam>(null);
    const [isScanning, setIsScanning] = useState(false);
    const [status, setStatus] = useState('Aponte a câmera para a placa');

    const cleanPlate = (text: string) => {
        // Remove caracteres especiais e formata para o padrão Mercosul (ABC1D23) ou antigo (ABC1234)
        return text.replace(/[^A-Z0-9]/gi, '').toUpperCase().trim();
    };

    const handleScan = useCallback(async () => {
        if (isScanning || !webcamRef.current) return;

        setIsScanning(true);
        setStatus('Lendo imagem...');
        const imageSrc = webcamRef.current.getScreenshot();

        if (!imageSrc) {
            setStatus('Não foi possível capturar a imagem.');
            setIsScanning(false);
            return;
        }

        const worker = await createWorker('por'); // Portuguese language
        try {
            setStatus('Processando placa...');
            const { data: { text } } = await worker.recognize(imageSrc);
            const plate = cleanPlate(text);
            setStatus(`Placa encontrada: ${plate}`);

            if (plate.length >= 7) {
                onPlateRecognized(plate);
            } else {
                setStatus('Placa não reconhecida. Tente novamente.');
            }
        } catch (error) {
            console.error(error);
            setStatus('Erro no reconhecimento. Tente novamente.');
        } finally {
            await worker.terminate();
            setIsScanning(false);
        }
    }, [isScanning, onPlateRecognized]);

    return (
        <div className="w-full max-w-md mx-auto flex flex-col items-center gap-4 p-4 border-2 border-dashed border-gray-500 rounded-lg">
            <div className="relative w-full h-64 bg-black rounded-md overflow-hidden">
                <Webcam
                    audio={false}
                    ref={webcamRef}
                    screenshotFormat="image/jpeg"
                    videoConstraints={{ facingMode: 'environment' }}
                    className="w-full h-full object-cover"
                />
                <div className="absolute top-0 left-0 w-full h-full flex items-center justify-center pointer-events-none">
                    <div className="w-4/5 h-2/5 border-4 border-green-400 rounded-lg animate-pulse"/>
                </div>
            </div>
            <p className="text-center text-sm text-slate-300 min-h-[20px]">{status}</p>
            <button
                onClick={handleScan}
                disabled={isScanning}
                className="w-full flex items-center justify-center gap-2 px-6 py-3 font-semibold text-white bg-[var(--color-mottu-default)] rounded-md shadow hover:bg-opacity-80 transition-colors disabled:opacity-50"
            >
                {isScanning ? <Loader2 className="animate-spin" /> : <ScanLine />}
                {isScanning ? 'Analisando...' : 'Escanear Placa'}
            </button>
        </div>
    );
};

export default OcrScanner;