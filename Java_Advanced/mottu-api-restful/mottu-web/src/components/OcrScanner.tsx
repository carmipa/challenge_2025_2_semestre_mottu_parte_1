// mottu-web/src/components/OcrScanner.tsx

"use client";
import React, { useRef, useState, useCallback, useEffect } from 'react';
import Webcam from 'react-webcam';
import { createWorker } from 'tesseract.js';
import { Camera, Loader2, ScanLine, QrCode, Smartphone } from 'lucide-react';
import { QRCodeSVG } from 'qrcode.react';
import { RadarService, OcrSession } from '@/utils/api';

interface OcrScannerProps {
    onPlateRecognized: (plate: string) => void;
}

const OcrScanner: React.FC<OcrScannerProps> = ({ onPlateRecognized }) => {
    const webcamRef = useRef<Webcam>(null);
    const [isScanning, setIsScanning] = useState(false);
    const [status, setStatus] = useState('Aponte a câmara para a placa ou use o seu celular.');

    // Novos estados para o fluxo de QR Code
    const [sessionId, setSessionId] = useState<string | null>(null);
    const [sessionStatus, setSessionStatus] = useState<OcrSession['status'] | null>(null);
    const pollingIntervalRef = useRef<NodeJS.Timeout | null>(null);

    const cleanPlate = (text: string) => {
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

        const worker = await createWorker('por');
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

    // Limpa o intervalo de polling quando o componente é desmontado
    useEffect(() => {
        return () => {
            if (pollingIntervalRef.current) {
                clearInterval(pollingIntervalRef.current);
            }
        };
    }, []);

    // Função que inicia o polling para verificar o status da sessão
    const startPolling = (currentSessionId: string) => {
        pollingIntervalRef.current = setInterval(async () => {
            try {
                const session = await RadarService.getStatusSessao(currentSessionId);
                setSessionStatus(session.status);

                if (session.status === 'COMPLETED' && session.recognizedPlate) {
                    if (pollingIntervalRef.current) clearInterval(pollingIntervalRef.current);
                    setStatus(`Placa ${session.recognizedPlate} recebida do celular!`);
                    onPlateRecognized(session.recognizedPlate);
                } else if (session.status === 'ERROR') {
                    if (pollingIntervalRef.current) clearInterval(pollingIntervalRef.current);
                    setStatus(`Erro no celular: ${session.errorMessage || 'Tente novamente.'}`);
                    setTimeout(() => {
                        setSessionId(null); // Permite tentar de novo
                        setStatus('Aponte a câmara para a placa ou use o seu celular.');
                    }, 5000);
                }
            } catch (error) {
                console.error("Erro ao verificar status da sessão:", error);
                if (pollingIntervalRef.current) clearInterval(pollingIntervalRef.current);
                setStatus('Erro de comunicação. Tente novamente.');
                setTimeout(() => setSessionId(null), 5000);
            }
        }, 3000); // Verifica a cada 3 segundos
    };

    const handleUsePhone = async () => {
        if (sessionId) return; // Evita múltiplas chamadas
        try {
            setStatus('A gerar QR Code...');
            const { sessionId: newSessionId } = await RadarService.iniciarSessao();
            setSessionId(newSessionId);
            setStatus('Escaneie o QR Code com seu celular.');
            startPolling(newSessionId);
        } catch (error) {
            setStatus('Erro ao iniciar sessão com o celular. Verifique o backend.');
            console.error(error);
        }
    };

    const getMobileUploadUrl = () => {
        if (!sessionId) return '';
        // Constrói a URL completa para o QR Code
        const url = new URL(`/radar/mobile-upload/${sessionId}`, window.location.origin);
        return url.toString();
    };

    return (
        <div className="w-full max-w-md mx-auto flex flex-col items-center gap-4 p-4 border-2 border-dashed border-gray-500 rounded-lg">

            {!sessionId ? (
                <>
                    {/* Visualização da Webcam */}
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
                    {/* Botões de Ação */}
                    <div className="w-full flex flex-col sm:flex-row gap-4">
                        <button
                            onClick={handleScan}
                            disabled={isScanning}
                            className="flex-1 flex items-center justify-center gap-2 px-6 py-3 font-semibold text-white bg-[var(--color-mottu-default)] rounded-md shadow hover:bg-opacity-80 transition-colors disabled:opacity-50"
                        >
                            {isScanning ? <Loader2 className="animate-spin" /> : <ScanLine />}
                            {isScanning ? 'Analisando...' : 'Escanear Placa'}
                        </button>
                        <button
                            onClick={handleUsePhone}
                            className="flex-1 flex items-center justify-center gap-2 px-6 py-3 font-semibold text-white bg-slate-700 rounded-md shadow hover:bg-slate-600 transition-colors"
                        >
                            <Smartphone /> Usar Celular
                        </button>
                    </div>
                </>
            ) : (
                <>
                    {/* Visualização do QR Code */}
                    <div className="w-full h-64 bg-white rounded-md overflow-hidden flex items-center justify-center p-4">
                        <QRCodeSVG value={getMobileUploadUrl()} size={220} />
                    </div>
                    <p className="text-center text-sm text-slate-300 min-h-[20px]">{status}</p>
                    <div className='text-center text-sky-300 flex items-center gap-2'>
                        <Loader2 className="animate-spin" />
                        Aguardando imagem do celular...
                    </div>
                </>
            )}
        </div>
    );
};

export default OcrScanner;