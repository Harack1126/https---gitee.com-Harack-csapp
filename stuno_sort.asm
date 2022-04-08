#C program
##################
#int getval()
#{
#    int sortstuno = 0;
#    int stuno = 0x99999999;
#    int date = 0;
#    unsigned int p = 0xf;
#    int i;
#    int tmp = date, res = 0;
#    for (i = 0; i < 8; i++)
#    {
#        int num = (stuno & p) >> (i * 4);
#        p <<= 4;
#        date += 1 << (num * 3);
#    }
#    while (tmp)
#    {
#        res += tmp & 7;
#        tmp >>= 3;
#    }
#    if (res != 8)
#        return stuno;
#    for (i = 0; i < 10; i++)
#    {
#        p = i * 3;
#        int count = ((0x7 << p) & date) >> p;
#        while (count)
#        {
#            sortstuno <<= 4;
#            count--;
#            date -= 1 << p;
#            sortstuno += i;
#        }
#    }
#    return sortstuno;
#}
##################
#mips:
#	stuno:$1
#	sortstuno:$2
#	date:$3
#	p:$4
#	i:$5
#	limit:$6
#	const_num:$7
#	tmp1:$8
#	tmp2:$9
#	tmp3:$10
##################

getval:
	lui $1,0x0523			#										
	ori $1,0x3007           #stuno = 0x23815259;					
	addi $4,$0,0xf          #p = 0xf;								
	addi $6,$0,0x8          #limit = 8;                             
	addi $7,$0,0x1          #const_num = 1;                         
label1:                     #                                       
	beq $5,$6,label1_end    #while (i != limit)                     
	and $8,$1,$4            #tmp1 = stuno & p;                      
	sll $9,$5,0x2           #tmp2 = i << 2;                         
	srlv $8,$8,$9           #tmp1 =  tmp1 >> tmp2;                         
	sll $4,$4,0x4           #p =  p << 4;                               
	sll $9,$8,1             #tmp2 = tmp1 << 1;                      
	add $9,$9,$8            #tmp2 = tmp2 + tmp1;                          
	sllv $8,$7,$9           #tmp1 = const_num << tmp2;              
	add $3,$3,$8            #date = date + tmp1;                    
	addi,$5,$5,1            #i = i + 1;                             
	j label1                #                                       
label1_end:                 #                                       
	add $8,$0,$3            #tmp1 = date;                           
	addi $9,$0,0            #tmp2 = 0;                              
label2:                     #                                       
	beq $8,$0,label2_end    #while (tmp1 != 0)                      
	andi $10,$8,0x7         #tmp3 = tmp1 & 7;                       
	add $9,$9,$10           #tmp2 = tmp2 + tmp3;                    
	srl $8,$8,0x3           #tmp1 = tmp1 >> 3;                      
	j label2                #                                       
label2_end:                 #                                       
	bne $9,$6,main          #if (tmp2 != limit)return stuno;        
	addi $5,$0,0            #i = 0;                                 
	addi $6,$0,0xa          #limit = 10;                            
label3:                     #                                       
	beq $5,$6,label3_end    #while (i != limit)                     
	sll $4,$5,1             #p = i << 1;                            
	add $4,$4,$5            #p = p + i;                             
	addi $7,$0,0x7          #const_num = 7;                         
	sllv $8,$7,$4           #tmp1 = const_num << p;                 
	and $8,$8,$3            #tmp1 = tmp1 & date;                    
	srlv $8,$8,$4           #tmp1 = tmp1 >> p;                      
label4:                     #                                       
	beq $8,$0,label4_end    #while (tmp1 != 0)                      
	sll $2,$2,0x4           #sortstuno = sortstuno << 4;                           
	addi $7,$0,1            #const_num = 1;   
	sub $8,$8,$7            #tmp1 = tmp1 - 1;                              
	sllv $9,$7,$4           #tmp2 = const_num << p;                 
	sub $3,$3,$9            #date = date - tmp2;                    
	add $2,$2,$5            #sortstuno = sortstuno + i;             
	j label4                #                                       
label4_end:                 #                                       
	addi $5,$5,1            #i = i + 1;                             
	j label3                #                                       
label3_end:	                #                                       
	j main                  #return sortstuno;                      
main:                       #                                       
	sw $1,256($0)           #                                       
	sw $2,260($0)           #                                       
end:	                    #                                       
	j end                   #                                       
