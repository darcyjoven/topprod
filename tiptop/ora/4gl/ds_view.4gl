database ds
DEFINE ss ARRAY[2300] OF VARCHAR(320)
DEFINE tt  VARCHAR(320)
DEFINE out_name VARCHAR(15)
DEFINE vv VARCHAR(1)
DEFINE i,j,k,last_line integer
DEFINE line,col	INTEGER
define g_seg    INTEGER 
define g_max,l_i  INTEGER 
define g_i,g_j,num_b,num_e,num_e_old  integer
define g_lang VARCHAR(1) 
DEFINE g_user 		  VARCHAR(10),
       g_grup 		  VARCHAR(6),
       g_clas 		  VARCHAR(10)
DEFINE l_zb01 VARCHAR(1),
       l_zb02 VARCHAR(1),
       l_zb03 VARCHAR(1),
       l_chr	 VARCHAR(1),
       l_buf	 VARCHAR(20),
       l_n		INTEGER

MAIN
    options prompt line last,
            MESSAGE LINE last,  
     input no wrap
    WHENEVER ERROR CONTINUE
    LET out_name = ARG_VAL(1)
    CREATE TEMP TABLE seq_file (ss VARCHAR(300))
    LOAD FROM out_name INSERT INTO seq_file
  
    DECLARE seq_cur SCROLL CURSOR WITH HOLD FOR 
       SELECT * FROM seq_file
    SELECT COUNT(*) INTO g_max FROM seq_file  #計算總筆數
    OPEN seq_cur 
 #  DISPLAY '第',g_seg using '<<','段','總共 ',last_line using '<<<<<',' lines',' 現為第',i using '<<<<<','行',' 第',j using '<<<<','列',' 看上段請按5/下段按6(無下段default第1行)' 
    CALL ins_ss(0,1)
    let last_line=g_j-1
    let col=0
    let line=0
    SELECT zb01,zb02,zb03 INTO l_zb01,l_zb02,l_zb03 FROM zb_file WHERE zb00='0'
    IF l_zb02 = "2" THEN
       CALL fgl_getenv('LOGTTY') RETURNING l_buf          # TTY no
       LET g_user = l_buf[6,20]
    ELSE #SELECT USER,COUNT(*) INTO g_user,l_n FROM SYSUSERS     # Login user
         LET g_user=fgl_getenv('LOGNAME') 
    END IF
    SELECT zx03,zx04,zx06 INTO g_grup,g_clas,g_lang
     FROM zx_file WHERE zx01 = g_user
    CALL ds_view() 
    WHILE TRUE
       let i=line+21 + num_b - 1 
       let j=col +78
    IF g_lang='0' THEN
       display '第',g_seg using '<<<','段','總共 ',last_line using '<<<<<',
               ' lines',
               ' 現為第',i using '<<<<<','行',
               ' 第',j using '<<<','列',
               ' 看上段請按5/下段按6(無下段default第1行)' at 23,1 
    PROMPT ' 0首頁 1下頁 2上頁 3左頁 4右頁 9末頁 JD下移 KU上移 HN左移 LM右移 Q.結束:'  for char vv
    ELSE
       display 'Sec:',g_seg using '<<<',' Totl:',last_line using '<<<<<',
               ' Lines',
               ' Pos.:Ln.',i using '<<<<<',
               '/Col.',j using '<<<<',
               ' 5:Prev Sec 6:Next Sec' at 23,1 
       PROMPT ' 0:Home 1:PgDn 2:PgUp 3:L.Pg 4:R.Pg 9:End JD:Down KU:Up HN:Left LM:Right Quit:'  for char vv
    END IF

{
  display '第',g_seg using '<<','段','總共 ',last_line using '<<<<',' lines',
          ' 現為第',i using '<<<<','行',
          ' 第',j using '<<<','列',
          ' 看上段請按5/下段按6(無下段default第1行)' at 23,1 
        PROMPT ' 0首頁 1下頁 2上頁 3左頁 4右頁 9末頁 JD下移 KU上移 HN左移 LM右移 Q.結束:'  for char vv 
}
       if vv='+' or vv=' ' or vv is null then let vv='1' end if
       if vv='-'                         then let vv='2' end if

       clear screen  # For refresh Screen

       case when vv='0'            let line=1 let col=1  call ds_view()
            when vv MATCHES '1'    let line=line+22     
                                    call ds_view()
            when vv MATCHES '2'    let line=line-22      call ds_view()
            when vv MATCHES '3'    let col=col-79        call ds_view()
            when vv MATCHES '4'    let col=col+79        call ds_view()
            when vv ='5'           call ins_ss(1,2) 
                                   let last_line=g_j-1
                                   let col = 1 
                                   let line =1 
                                   call ds_view()
            when vv ='6'           call ins_ss(2,2)
                                   let last_line=g_j-1 
                                   let col =1 
                                   let line=1 
                                   call ds_view() 
            when vv MATCHES '[jJ]' let line=line+1       call ds_view()
            when vv MATCHES '[dD]' let line=line+11      call ds_view()
            when vv MATCHES '[kK]' let line=line-1       call ds_view()
            when vv MATCHES '[uU]' let line=line-11      call ds_view()
            when vv MATCHES '[hH]' let col=col-1         call ds_view()
            when vv MATCHES '[nN]' let col=col-40        call ds_view()
            when vv MATCHES '[lL]' let col=col+1         call ds_view()
            when vv MATCHES '[mM]' let col=col+40        call ds_view()
            when vv MATCHES '9'    let line=last_line-22 call ds_view()
            when vv MATCHES '[qQeE]' exit program
       end case
    END WHILE
END MAIN

FUNCTION ds_view()
  DEFINE g_chr VARCHAR(1)
  DEFINE str VARCHAR(79)
  if line < 1   then let line =1  end if
  if line > 1979 then let line = 1979 end if 
  if col  < 1   then let col  =1  end if
  #if col  > 160 then let col  =160 end if
  if col  > 242 then let col  =242 end if
  for i = 1 to 22
     let j = line + i - 1
     let k=col+78
     let str=ss[j][col,k]
     if str is null then let str=' ' end if
     display str at i,1
  end for
end function

function ins_ss(l_direct,l_flag)
define l_direct INTEGER     #方向 
define l_flag   INTEGER 
define p_flag,mod   INTEGER 


    let p_flag = l_flag 
    if l_direct = 0 then let g_seg = 1 let num_e = 2000 let num_b = 1 end if 
    case l_direct 
         when 1 let g_seg = g_seg - 1  #上段
                  let num_e = g_seg * 2000 
                  let num_b = num_e - 2000 + 1 
         when 2 let g_seg = g_seg + 1  #下段
                  let num_e = g_seg * 2000 
                  let num_b = num_e - 2000 + 1 
         otherwise exit case 
       exit case 
    end case
    if p_flag ='1' then  #第一次
       if g_max <= num_e then 
          for l_i = 1 to 2000  
              initialize ss[l_i] to null 
          end for 
        end if 
    end if 
    if p_flag ='2' then  #
     if g_seg <= 0 then 
         display '前面沒有資料了  !!!'  
         LET g_seg = 1 
         if num_e = 0 then 
            let num_e = 2000
            let num_b = 1 
         else 
            let num_b = num_b - 2000
            let num_e = num_e - 2000 
         end if 
         RETURN 
     else 
       if ((num_e <= g_max) or (g_max <= num_e and g_max >= num_b)) then 
         for l_i = 1 to 2000 
           initialize ss[l_i] to null 
         end for 
         #  let num_b = num_e - 2000 + 1 
       else 
       #超出最大筆數
        display '後面沒有資料啦 !!!'
        let g_seg = g_seg - 1 
        let num_b = num_b - 2000
        let num_e = num_e - 2000 
        return 
       end if    
     end if 
    end if  
    let g_j = 1 
    display 'Waiting for load !!'
    if g_max < num_e then let num_e_old = num_e #保存舊值
                          let num_e = g_max end if 
    for g_i = num_b to num_e 
      fetch absolute g_i seq_cur into ss[g_j]
      if g_j > 2000 then exit for end if 
      let g_j = g_j + 1 
    end for 
    let num_e = num_e_old 
end function 
 
