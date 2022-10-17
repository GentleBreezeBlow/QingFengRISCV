_start:

#	lb	x2,0(x0)
#	add	x4,x2,1

	li	x2,5
	sb	x2,0(x0)
	
	# add sub
	li	x1,50
	li	x2,55
	add	x3,x2,x1
	sub	x4,x2,x1

	li	x1,1
	li	x2,1
	li	x3,16
	beq	x1,x2,branch_to_here

	lui	a5,0x10013
	addi	a5,a5,8
	li	a4,1
	sw	a4,0(a5)
	lui	a5,0x10013
	li	a4,0x41
	sw	a4,0(a5)
	li	a4,101
	sw	a4,0(a5)
	li	a4,108
	sw	a4,0(a5)
	sw	a4,0(a5)
	li	a4,111
	sw	a4,0(a5)
	li	a4,33
	sw	a4,0(a5)
	li	a4,10
	sw	a4,0(a5)
	lui	a5,0x10
	addi	a5,a5,0x4a
	jr	a5

branch_to_here:
	li	x15,6