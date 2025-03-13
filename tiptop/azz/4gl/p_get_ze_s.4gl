# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: p_get_ze_s.4gl    #FUN-B20036
# Descriptions...: 1.會抓取所有寫在 p_link 作業中的程式資料 (p_get_ze提供檔名)
#                  2.程式行起始若為 #井號 --雙短線 {左大括號  則該行視為註解
#                  3.若行首為 {} or  該整行一樣視為註解, 理由同上
#
# Modify.........: No.FUN-B60050 11/06/08 By alex 新增抓取項目

IMPORT os  
DATABASE ds
 
DEFINE ga_get           DYNAMIC ARRAY OF RECORD
          ze01           LIKE ze_file.ze01
                            END RECORD

FUNCTION p_get_ze_s(ls_prog)    #FUN-B20036
 
    DEFINE ls_prog          STRING
    DEFINE lp_prog          base.Channel
    DEFINE lc_analy         LIKE type_file.chr1000 
    DEFINE ls_analy         STRING
    DEFINE li_i,li_j        LIKE type_file.num5    
    DEFINE li_k,li_l,li_m   LIKE type_file.num5    
    DEFINE li_length        LIKE type_file.num5  
    DEFINE ls_analy_tmp     STRING   
 
    #安全機制的action id需要以合法的方式補到別支作業 
    IF NOT os.Path.exists(ls_prog) THEN
       RETURN "",""
    END IF
 
    LET lp_prog = base.Channel.create()

    CALL ga_get.clear()
    CALL lp_prog.openFile(ls_prog,"r")
 
    WHILE lp_prog.read([lc_analy])
       LET ls_analy = DOWNSHIFT(lc_analy)
       LET ls_analy = ls_analy.trim()
 
       #先判斷本行行頭是否以 # 或 -- 為開頭, 如果是就放棄這個找下個
       #補上 { 符號   請勿在行首放大括號
       IF ls_analy.subString(1,1) = "#" OR ls_analy.subString(1,2) = "--" OR
          ls_analy.subString(1,1) = "{" THEN
          CONTINUE WHILE
       END IF
 
       #抓 第一個參數  如 cl_getmsg(   範例:CALL cl_getmsg('asm-302',g_lang)   #FUN-B60050
       #                  cl_confirm(  範例:IF cl_confirm('aws-081')

       LET li_i = ls_analy.getIndexOf("cl_getmsg(",1) 
       LET li_k = ls_analy.getIndexOf("cl_confirm(",1) 

       IF li_i > 0 OR li_k > 0 THEN
          LET ls_analy = ls_analy.subString(ls_analy.getIndexOf("(",1)+1,
                                            ls_analy.getIndexOf(")",1)-1 )
          LET ls_analy_tmp = p_get_ze_getans(ls_analy.trim(),1)

          LET ls_analy_tmp = ls_analy_tmp.trim()
          CALL p_get_ze_checkarray(ls_analy_tmp)
          CONTINUE WHILE
       END IF

       #抓 第二個參數  如 cl_err(      範例:CALL cl_err(g_apa.apa51,'aap-704',0)
       #                  cl_err_msg(  範例:CALL cl_err_msg('','aap-923','aapt160,aapt260',1)

       LET li_i = ls_analy.getIndexOf("cl_err(",1) 
       LET li_k = ls_analy.getIndexOf("cl_err_msg(",1) 

       IF li_i > 0 OR li_k > 0 THEN
          LET ls_analy = ls_analy.subString(ls_analy.getIndexOf("(",1)+1,
                                            ls_analy.getIndexOf(")",1)-1 )
          LET ls_analy_tmp = p_get_ze_getans(ls_analy.trim(),2)

          LET ls_analy_tmp = ls_analy_tmp.trim()
          CALL p_get_ze_checkarray(ls_analy_tmp)
          CONTINUE WHILE
       END IF

       #抓 第三個參數  如 cl_msgany(   範例: CALL cl_msgany(0,0,"aap-113")

       LET li_i = ls_analy.getIndexOf("cl_getmsg(",1) 

       IF li_i > 0 THEN
          LET ls_analy = ls_analy.subString(ls_analy.getIndexOf("(",1)+1,
                                            ls_analy.getIndexOf(")",1)-1 )
          LET ls_analy_tmp = p_get_ze_getans(ls_analy.trim(),3)

          LET ls_analy_tmp = ls_analy_tmp.trim()
          CALL p_get_ze_checkarray(ls_analy_tmp)
          CONTINUE WHILE
       END IF

       #抓 第五個參數  如 cl_err3(   範例:CALL cl_err3("upd","npp_file",g_apa.apa01,"",STATUS,"","upd npp02:",1) 
       LET li_i = ls_analy.getIndexOf("cl_err3(",1)

       IF li_i > 0 THEN
          LET ls_analy = ls_analy.subString(ls_analy.getIndexOf("(",1)+1,
                                            ls_analy.getIndexOf(")",1)-1 )
          LET ls_analy_tmp = p_get_ze_getans(ls_analy.trim(),5)
          LET ls_analy_tmp = ls_analy_tmp.trim()

          CALL p_get_ze_checkarray(ls_analy_tmp)
          CONTINUE WHILE
       END IF

       #抓 LET g_errno  範例:LET g_errno = 'apj-005'

       LET li_l = ls_analy.getIndexOf("g_errno",1) 
       LET li_m = ls_analy.getIndexOf("let",1) 
       IF li_l > 0 AND li_m > 0 AND li_m < li_l THEN
          #去除 LET xxx = cl_getmsg(g_errno,xxx) 程式段
          LET ls_analy_tmp = ls_analy.subString(li_m +3 ,li_l - 1)
          LET ls_analy_tmp = ls_analy_tmp.trim()
          IF ls_analy_tmp.getLength() > 0 THEN CONTINUE WHILE END IF
           
          LET ls_analy = ls_analy.subString(li_l + 7,ls_analy.getLength() )
          LET ls_analy_tmp = ls_analy.subString(ls_analy.getIndexOf("=",1) + 1,ls_analy.getLength()) 

          LET ls_analy_tmp = ls_analy_tmp.trim()
          CALL p_get_ze_checkarray(ls_analy_tmp)
       END IF
 
    END WHILE
 
    CALL lp_prog.close()
    RETURN p_get_ze_compose()
END FUNCTION


#由於TIPTOP傳參數的特殊性 ( 1,2,"3,4,5",4,5,6 ) 無法直接使用 tok
PRIVATE FUNCTION p_get_ze_getans(ls_analy,li_i)
    DEFINE l_tok        base.StringTokenizer
    DEFINE ls_analy     STRING
    DEFINE ls_ans       STRING
    DEFINE li_i,li_j    LIKE type_file.num5

    LET l_tok = base.StringTokenizer.create(ls_analy.trim(),",")
    LET ls_ans = ""
    LET li_j = 1
    WHILE l_tok.hasMoreTokens() 
       LET ls_ans = ls_ans,l_tok.nextToken()
       IF ls_ans.subString(1,1) = "'" THEN
          IF NOT ls_ans.subString(ls_ans.getLength(),ls_ans.getLength()) = "'" THEN
             CONTINUE WHILE
          END IF
       END IF
       IF ls_ans.subString(1,1) = '"' THEN
          IF NOT ls_ans.subString(ls_ans.getLength(),ls_ans.getLength()) = '"' THEN
             CONTINUE WHILE
          END IF
       END IF
       IF li_j = li_i THEN EXIT WHILE END IF
       LET li_j = li_j + 1
       LET ls_ans = ""
    END WHILE

    RETURN ls_ans

END FUNCTION


# 抓 array 組合
PRIVATE FUNCTION p_get_ze_compose()  

    DEFINE li_array     LIKE type_file.num5    
    DEFINE li_j         LIKE type_file.num5    
    DEFINE ls_compose   STRING

    LET ls_compose=""
    LET li_array = ga_get.getLength()
    FOR li_j=1 TO li_array
       LET ls_compose = ls_compose, ga_get[li_j].ze01 CLIPPED, ", "
    END FOR

    LET ls_compose = ls_compose.trim()
    LET ls_compose = ls_compose.subString(1,ls_compose.getLength()-1)

    RETURN ls_compose

END FUNCTION

# 比對是否已經有加進來的  所以把它寫到 array 最後再組出來
PRIVATE FUNCTION p_get_ze_checkarray(ls_analy_tmp)

    DEFINE li_j         LIKE type_file.num5    
    DEFINE li_array     LIKE type_file.num5    
    DEFINE ls_analy_tmp STRING

    #濾除引號
    IF ls_analy_tmp.subString(1,1) = "'" THEN
       LET ls_analy_tmp = ls_analy_tmp.subString(2,ls_analy_tmp.getIndexOf("'",2)-1)
    END IF
    IF ls_analy_tmp.subString(1,1) = '"' THEN
       LET ls_analy_tmp = ls_analy_tmp.subString(2,ls_analy_tmp.getIndexOf('"',2)-1)
    END IF
    IF ls_analy_tmp.getIndexOf("#",2) THEN
       LET ls_analy_tmp = ls_analy_tmp.subString(1,ls_analy_tmp.getIndexOf("#",2)-1)
    END IF
 
    LET ls_analy_tmp = ls_analy_tmp.trim()

    #濾除status, sqlca.sqlcode訊息
    IF ls_analy_tmp = "status" OR ls_analy_tmp.getIndexOf("sqlca.sql",1) OR
       ls_analy_tmp = "g_errno" OR ls_analy_tmp.getIndexOf("null",1) OR
       ls_analy_tmp.getLength() = 0 THEN
       RETURN
    END IF

    LET li_array = ga_get.getLength()
    FOR li_j=1 TO li_array
        IF ls_analy_tmp.trim() = ga_get[li_j].ze01 CLIPPED THEN
           RETURN
        END IF
    END FOR
    LET ga_get[li_array+1].ze01 = ls_analy_tmp.trim() CLIPPED

END FUNCTION


