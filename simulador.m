clc %limpa a tela
clear all;
maxsimulacoes  = 100; %numero max de simulacoes, proj = 2000
initialframe = 64; %numero inicial de slots no frame, proj = 64
initialetiquetas = 100; % numero inicial de etiquetas para cada teste , proj = 100
stepetiquetas = 100; % numero do passo do for de etiquetas, proj = 100
finaletiquetas = 1000; % numero final de etiquetas, proj  = 1000

for algorithm = 3:3
    
    grcolisoes = [];
    grvazio = [];
    gracuracia = [];
    grframes = [];

for etiquetas = initialetiquetas:stepetiquetas:finaletiquetas
    simcolisoes = [];
    simvazio = [];
    simacuracia = [];
    simframes = [];
    
    for simulacao = 1:maxsimulacoes
        frames = initialframe;
        terminou = false;
        iteracoes = 0;
        muting = 0;
        
        totalcolisoes = 0;
        totalvazio = 0;
        totalacuracia = 0;
        totalframes = 0;
        
        while ~terminou
            iteracoes = iteracoes + 1;
            slots = zeros(frames,1);
            
            % preenche os slots randomicamente
            for et = 1:(etiquetas - muting)
                framescolhido = randi(frames);
                slots(framescolhido,1) = slots(framescolhido,1) + 1;
            end
            
            vazio = sum(slots == 0);
            colisoes = sum(slots > 1);
            sucesso = sum(slots == 1);
            
            % ativando o muting
            muting = muting + sucesso;
            sucesso = muting;
            
            if sucesso == etiquetas % ou vazios ==0
                terminou = true;
            else
                if algorithm == 1
                    [frames, nestimado] = lowerBound(sucesso, colisoes);
                elseif algorithm == 2
                    [frames, nestimado] = schoute(sucesso, colisoes);
                elseif algorithm == 3
                    [frames, nestimado] = eomLee(frames, sucesso, colisoes);
                end
                  frames = round(frames);
            end
            
            % atualizando os graficos
            totalcolisoes = totalcolisoes + colisoes;
            totalvazio = totalvazio + vazio;
            totalacuracia = totalacuracia + abs(etiquetas - nestimado);
            totalframes = totalframes + frames;
        end
        
        simcolisoes = [simcolisoes totalcolisoes];
        simvazio = [simvazio totalvazio];
        simframes = [simframes totalframes];
        simacuracia = [simacuracia (totalacuracia/iteracoes)];
               
    end
    
    grcolisoes = [grcolisoes [etiquetas; mean(simcolisoes)]];
    grvazio = [grvazio [etiquetas; mean(simvazio)]];
    gracuracia = [gracuracia [etiquetas; mean(simacuracia)]];
    grframes = [grframes [etiquetas; mean(simframes)]];
    
    disp('-------------------------------------');
end

    disp('virou o algoritmo');

    todoscolisoes(:,:,algorithm) = grcolisoes;
    todosvazio(:,:,algorithm) = grvazio;
    todosacuracia(:,:,algorithm) = gracuracia;
    todosframes(:,:,algorithm) = grframes;

end

figure; hold on; grid on;
plot(todoscolisoes(1,:,1), todoscolisoes(2,:,1), '-om');
plot(todoscolisoes(1,:,2), todoscolisoes(2,:,2), '-dr');
plot(todoscolisoes(1,:,3), todoscolisoes(2,:,3), '-*b');
legend('Lower-Bound', 'Schoute', 'Eom-Lee');
title('Colisões'); 
xlabel('Quantidade de etiquetas');
ylabel('Quantidade de colisÃµes');
print('colisoes', '-dpng');

figure; hold on; grid on;
plot(todosacuracia(1,:,1), todosacuracia(2,:,1), '-om');
plot(todosacuracia(1,:,2), todosacuracia(2,:,2), '-dr');
plot(todosacuracia(1,:,3), todosacuracia(2,:,3), '-*b');
legend('Lower-Bound', 'Schoute', 'Eom-Lee');
title('Acurácia'); 
xlabel('Quantidade de etiquetas');
ylabel('Acurácia');
print('sucessos', '-dpng');

figure; hold on; grid on;
plot(todosvazio(1,:,1), todosvazio(2,:,1), '-om');
plot(todosvazio(1,:,2), todosvazio(2,:,2), '-dr');
plot(todosvazio(1,:,3), todosvazio(2,:,3), '-*b');
legend('Lower-Bound', 'Schoute', 'Eom-Lee');
title('Slots vazios'); 
xlabel('Quantidade de etiquetas');
ylabel('Quantidade de slots vazios');
print('vazios', '-dpng');

figure; hold on; grid on;
plot(todosframes(1,:,1), todosframes(2,:,1), '-om');
plot(todosframes(1,:,2), todosframes(2,:,2), '-dr');
plot(todosframes(1,:,3), todosframes(2,:,3), '-*b');
legend('Lower-Bound', 'Schoute', 'Eom-Lee');
title('Número de slots'); 
xlabel('Quantidade de etiquetas');
ylabel('NÃºmeros de slots');
print('slots', '-dpng');

