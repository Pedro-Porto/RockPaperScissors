		.data
		.align 0
		# mensagens de console
str_msg1: 	.asciz "Selecione uma das alternativas: \n[1] Pedra\n[2] Papel\n[3] Tesoura\n[4] Finalizar\n"
str_msg2: 	.asciz "Voce ganhou! \nAs escolhas foram:\nJogador -> "
str_msg3: 	.asciz "O computador ganhou :(\nAs escolhas foram:\nJogador -> "
str_msg4: 	.asciz "\nComputador -> "
str_msg5: 	.asciz "Empate! \nAs escolhas foram:\nJogador -> "
str_msg6: 	.asciz "\n -------------------------------------------------------------------------- \n"
str_msg7: 	.asciz " -> "
str_msg8: 	.asciz "Escolhas do computador"
str_msg9: 	.asciz "\nResultado final:\n\n        "
str_msg10: 	.asciz "          "
str_msg11: 	.asciz "\n     jogador   computador\n"

str_pedra: 	.asciz "Pedra"
str_papel: 	.asciz "Papel"
str_tesoura: 	.asciz "Tesoura"
		.align 2
head:		.word -1 # ponteiro para o inicio da lista
		.globl main
		.text
		# t1: selecao do usuario
		# t2: sorteado
		# t4: numero 4
		# s0: topo da pilha
		# s1: pontuacao do jogador
		# s2: pontuacao do pc 
main:		
		addi t4, zero, 4
		# inicia pontuacoes com 0
		addi, s1, zero, 0
		addi s2, zero, 0
		

loop:		addi a7, zero, 4 # imprime a mensagem de escolha
		la a0, str_msg1
		ecall
		
		# leitura da entrada do usuario
		addi a7, zero, 5
		ecall
		add t1, zero, a0 # salva escolha do usuario
		
		beq t1, t4, fim # finaliza o programa na selecao 4
		addi a7, zero, 42 # rand int bound
		addi a1, zero, 3 # [0, 3]
		ecall
		addi t2, a0, 1 # numero sorteado no t2
		# definir resultado
		
		beq t1, t2, empate
		addi t0, t1, 2 # faz pedra = tesoura
		beq, t0, t2, jog_ganhou # jogador: pedra (1), pc: tesoura (3)
		addi t0, t2, 2 # faz pedra = tesoura
		beq, t0, t1, pc_ganhou # jogador: tesoura (3), pc: pedra (1)
		bgt t1, t2, jog_ganhou
		j pc_ganhou
		
jog_ganhou:	la a0, str_msg2 # mensagem que o jogador ganhou
		addi a7, zero, 4
		ecall
		addi, s1, s1, 1 # adiciona um ponto para o jogador
		j continue
pc_ganhou:	la a0, str_msg3 # mensagem que o pc ganhou
		addi a7, zero, 4
		ecall
		addi, s2, s2, 1 # adiciona um ponto para o pc
		j continue
empate:		la a0, str_msg5 # mensagem de empate
		addi a7, zero, 4
		ecall
		
		# imprime as escolhas
continue:	add, a0, zero, t1
		jal print_selec # imprime a selecao do jogador
		la a0, str_msg4
		addi a7, zero, 4
		ecall
		add, a0, zero, t2
		jal print_selec # imprime a selecao do pc
		la a0, str_msg6
		addi a7, zero, 4
		ecall
		add a0, zero, t2
		jal inserir_lista
		j loop # continua o loop ate digitar 4
		
		
		
fim:		jal print_lista
		add a0, zero, s1
		add a1, zero, s2
		jal print_placar
		
		addi a7, zero, 10
		ecall

# -------------------------- funções -------------------------- #

print_selec:	# imprime o que foi escolhido de acordo com o numero do parametro
		#  a0: numero
		addi a7, zero, 4
		addi, t0, zero, 1
		beq a0, t0, print_pedra
		addi, t0, zero, 2
		beq a0, t0, print_papel
		# imprime tesoura
		la, t0, str_tesoura
		add a0, zero, t0
		ecall
		jr ra
print_pedra:	la, t0, str_pedra # imprime pedra
		add a0, zero, t0
		ecall
		jr ra
print_papel:	la, t0, str_papel # imprime pedra
		add a0, zero, t0
		ecall
		jr ra
		
		
inserir_lista:	# Insere um nó no final da lista encadeada O(n)
		# a0: valor a ser inserido
		# s0: ponteiro para head
		# t0: valor a ser inserido (cópia de a0)
		# t1: ponteiro para o novo nó
		# t2: valor -1 (indicador de fim de lista)
		# t3: ponteiro para o próximo nó
		# salvar s0 e ra na pilha
		addi sp, sp, -8
		sw ra, 4(sp)
		sw s0, 0(sp)
		
		add t0, zero, a0       # t0 = a0 (valor a ser inserido)
		addi t2, zero, -1      # t2 = -1
		
		# criar novo nó
		addi a7, zero, 9
		addi a0, zero, 8 # Alocar 8 bytes na heap
		ecall
		add t1, zero, a0 # t1 = endereço do novo nó
		sw t0, 0(t1) # armazena o valor no novo nó
		sw t2, 4(t1) # próximo nó = -1 (fim da lista)

		la s0, head # carrega o endereço de head em s0
		lw t3, 0(s0) # t3 = conteúdo de head
		beq t3, t2, lista_vazia # Se head == -1, a lista está vazia
		
		add s0, zero, t3  # s0 = ponteiro para o primeiro nó
		
loop_no:	lw t3, 4(s0) # t3 = próximo nó
		beq t3, t2, adicionar_no # se próximo == -1, fim da lista
		add s0, zero, t3 # vai para o próximo nó
		j loop_no 
		
adicionar_no:	sw t1, 4(s0) # atualiza o próximo do ultimo no
		j fim_il
		
lista_vazia:	sw t1, 0(s0) # atualiza head para o novo no
		
fim_il:		lw s0, 0(sp)
		lw ra, 4(sp)
		addi sp, sp, 4
		jr ra
		
print_lista:	# imprime a lista encadeada
		# t0: ponteiro de head
		# s1: ponteiro prox no
		# s2: -1
		addi, sp, sp, -12
		sw ra, 8(sp)
		sw s1, 4(sp)
		sw s2, 0(sp)
		
		addi s2, zero, -1
		la t0, head
		lw s1, 0(t0) # t1 fica com o conteudo de head (end primeiro no)
		beq s1, s2, fim_pl
		la a0, str_msg8
		addi a7, zero, 4
		ecall
		
loop_pl:	addi a7, zero, 4
		la a0, str_msg7
		ecall
		lw a0, 0(s1)
		jal print_selec
		
		lw s1, 4(s1)
		bne s1, s2, loop_pl
		
fim_pl:		lw ra, 8(sp)
		lw s1, 4(sp)
		lw s2, 0(sp)
		addi sp, sp, 12
		jr ra
		
print_placar:	# imprime o placar final formatado
		# a0: pontuacao jogador
		# a1: pontuacao computador
		# salva a0 e a1 em t0 e t1
		add t0, zero, a0
		add t1, zero, a1 
		la a0, str_msg9
		addi, a7, zero, 4
		ecall
		# imprime pontuacao do jogador
		addi a7, zero, 1
		add, a0, zero, t0
		ecall
		la a0, str_msg10
		addi a7, zero, 4
		ecall
		# imprime pontuacao do computador
		addi a7, zero, 1
		add, a0, zero, t1
		ecall
		la a0, str_msg11
		addi a7, zero, 4
		ecall
		jr ra
		
		
		
