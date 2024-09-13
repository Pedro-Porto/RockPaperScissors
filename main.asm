		.data
		.align 0
		# mensagens de console
str_msg1: 	.asciz "Selecione uma das alternativas: \n[1] Pedra\n[2] Papel\n[3] Tesoura\n[4] Finalizar\n"
str_msg2: 	.asciz "Voce ganhou! \nAs escolhas foram:\nJogador -> "
str_msg3: 	.asciz "O computador ganhou :(\nAs escolhas foram:\nJogador -> "
str_msg4: 	.asciz "\nComputador -> "

str_pedra: 	.asciz "Pedra"
str_papel: 	.asciz "Papel"
str_tesoura: 	.asciz "Tesoura"
		.align 2
		.globl main
		.text
		# t1: seleção do usuário
		# t2: sorteado
		# t4: numero 4
		# s0: topo da pilha
		# s1: pontuação do jogador
		# s2: pontuação do pc 
main:		# imprime a mensagem de escolha
		addi t4, zero, 4
		addi a7, zero, 4
		la t0, str_msg1
		add a0, zero, t0
		ecall
		
		# leitura da entrada do usuário
		addi a7, zero, 5
		add t1, zero, a0
		ecall
		beq t1, t4, fim # finaliza o programa na seleção 4
		addi a7, zero, 42 # rand int bound
		addi a1, zero, 3 # [0, 3]
		addi t2, a0, 1 # numero sorteado no t2
		# definir resultado
		
		
		
jog_ganhou:	
		
		
pc_ganhou:	
		
		
		
fim:		addi a7, zero, 10
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
		ret
print_pedra:	la, t0, str_pedra # imprime pedra
		add a0, zero, t0
		ecall
		ret
print_papel:	la, t0, str_papel # imprime pedra
		add a0, zero, t0
		ecall
		ret
		
		
		
		
		
		
		
		