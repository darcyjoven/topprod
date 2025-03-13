# Prog. Version..: '5.10.00-08.01.04(00000)'     #
#
# Pattern name...: axdq100.4gl
# Descriptions...: 客戶商品ＢＩＮ卡查詢
# Date & Author..: 2003/12/04 By Leagh
 # Modify.........: No.MOD-4B0067 04/11/09 By Elva 將變數用Like方式定義
 # Modify.........: No.MOD-570124 05/07/29 By Carrier 多筆資料顯示時，單身有問題 
#                                                    期初數量累計有誤
# Modify.........: NO:FUN-570250 05/12/23 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     
#
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:FUN-6A0092 06/11/16 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE 
    tm  RECORD
            wc  	LIKE type_file.chr1000,	# Head Where condition   #No.FUN-680108 VARCHAR(500)
            wc1  	LIKE type_file.chr1000, # Body Where condition   #No.FUN-680108 VARCHAR(500)
            wc2  	LIKE type_file.chr1000	# Body Where condition   #No.FUN-680108 VARCHAR(500)
        END RECORD,
    g_adp  RECORD
            adp01	LIKE adp_file.adp01, # 料件編號
            adp02	LIKE adp_file.adp02, # 倉庫編號
            adp03	LIKE adp_file.adp03, # 存放位置
            adp05	LIKE adp_file.adp05, # 批號
            adp04	LIKE adp_file.adp04  # 批號
        END RECORD,
    g_bdate     LIKE type_file.dat,    #No.FUN-680108 DATE
    g_adr09	LIKE adr_file.adr09, # 期初庫存
    g_occ02	LIKE occ_file.occ02, # 來源碼  
    g_ima02	LIKE ima_file.ima02, # 品名    
    g_year 	LIKE type_file.num5,   #No.FUN-680108 SMALLINT
    g_month	LIKE type_file.num5,   #No.FUN-680108 SMALLINT
    g_flag      LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(01)
    g_adq   DYNAMIC ARRAY OF RECORD
            adq04   LIKE adq_file.adq04,  #異動數量
            adq10   LIKE adq_file.adq10,  #異動數量
            desc    LIKE type_file.chr50, #No.FUN-680108 VARCHAR(10)
            adq05   LIKE adq_file.adq05,  #異動數量
            adq09   LIKE adq_file.adq09,  #異動數量
            tot     LIKE adq_file.adq09   #MOD-4B0067
        END RECORD,
    g_base          LIKE adq_file.adq09,  #MOD-4B0067
    g_query_flag    LIKE type_file.num5,   #第一次進入程式時即進入Query之後進入N.下筆 #No.FUN-680108 SMALLINT
    g_sql           string,  #No:FUN-580092 HCN
    i               LIKE type_file.num10,  #No.FUN-680108 INTEGER
    g_rec_b         LIKE type_file.num5   		  #單身筆數                    #No.FUN-680108 SMALLINT
DEFINE p_row,p_col     LIKE type_file.num5                                             #No.FUN-680108 SMALLINT
DEFINE   g_cnt         LIKE type_file.num10                                          #No.FUN-680108 INTEGER
DEFINE   g_msg         LIKE type_file.chr1000,                                       #No.FUN-680108 VARCHAR(72)
         l_ac          LIKE type_file.num5                                           #No.FUN-680108 SMALLINT

DEFINE   g_row_count    LIKE type_file.num10                                           #No.FUN-680108 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10                                           #No.FUN-680108 INTEGER
DEFINE   g_jump         LIKE type_file.num10                                           #No.FUN-680108 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5                                           #No.FUN-680108 SMALLINT 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0091

   OPTIONS                                #改變一些系統預設值
        FORM LINE       FIRST + 2,         #畫面開始的位置
        MESSAGE LINE    LAST,              #訊息顯示的位置
        PROMPT LINE     LAST,              #提示訊息的位置
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
  IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXD")) THEN
      EXIT PROGRAM
   END IF


      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091
    #FUN-570250 mark
    #LET g_msg=g_today USING 'yy/mm/dd'
    #LET g_bdate=DATE(g_msg) 
    LET g_bdate=g_today
    #FUN-570250 end 
    LET g_query_flag=1
       LET p_row = 3 LET p_col = 6

 OPEN WINDOW q100_w AT p_row,p_col
        WITH FORM "axd/42f/axdq100"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
    
    CALL cl_ui_init()
#     IF cl_chk_act_auth() THEN
#       CALL q100_q()
#    END IF           
    CALL q100_menu()    #中文
    CLOSE WINDOW q100_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091
END MAIN

#QBE 查詢資料
FUNCTION q100_curs()
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No:FUN-580031
   DEFINE   l_cnt LIKE type_file.num5           #No.FUN-680108 SMALLINT

   CLEAR FORM
   CALL g_adq.clear() 
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL		
   DISPLAY g_bdate TO bdate
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

   INITIALIZE g_adp.* TO NULL    #No.FUN-750051
   INITIALIZE g_occ02 TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON adp01,adp02,adp03
      #No:FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No:FUN-580031 --end--       HCN

      ON IDLE g_idle_seconds                                            
         CALL cl_on_idle()                                              
         CONTINUE CONSTRUCT                                             

      #No:FUN-580031 --start--     HCN
      ON ACTION qbe_select
         CALL cl_qbe_select() 
      #No:FUN-580031 --end--       HCN
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
                                                                                
    END CONSTRUCT 
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   INPUT g_bdate WITHOUT DEFAULTS FROM bdate

      BEFORE INPUT             
          CALL cl_qbe_display_condition(lc_qbe_sn)   

      AFTER FIELD bdate
        IF cl_null(g_bdate) THEN
           CALL cl_err('','aim-372',0)
           NEXT FIELD bdate
        END IF

      AFTER INPUT
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           RETURN       
        END IF
        IF cl_null(g_bdate) THEN
           CALL cl_err('','aim-372',0)
           NEXT FIELD bdate
        END IF
      ON IDLE g_idle_seconds                                  
        CALL cl_on_idle()                                                       
        CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121

      #No:FUN-580031 --start--         
      ON ACTION qbe_save            
          CALL cl_qbe_save()         
      #No:FUN-580031 ---end---
 
    END INPUT
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    LET tm.wc2 = " adq04 >= '",g_bdate,"'"
    MESSAGE ' WAIT ' ATTRIBUTE(REVERSE,BLINK)
    LET g_sql= " SELECT UNIQUE adp01,occ02,adp02,ima02,adp03, ",
               "        0,adp05,adp04 ",
               "   FROM adp_file, adq_file,OUTER occ_file, OUTER ima_file ",
               "  WHERE adp01 = occ_file.occ01 ",
               "    AND adp02 = ima_file.ima01 ",
               "    AND adp01 = adq01 ",
               "    AND adp02 = adq02 ",
               "    AND adp03 = adq03 ",
               "    AND ",tm.wc  CLIPPED,
               "    AND ",tm.wc2 CLIPPED,
               "  ORDER BY adp01,adp02,adp03"
    PREPARE q100_prepare FROM g_sql
    DECLARE q100_cs                         #SCROLL CURSOR
            SCROLL CURSOR FOR q100_prepare
 
    # 取合乎條件筆數
    #若使用組合鍵值, 則可以使用本方法去得到筆數值
    LET g_sql=" SELECT UNIQUE adp01,adp02,adp03 FROM adp_file,adq_file ",
               " WHERE adp01 = adq01 ",
               "   AND adp02 = adq02 ",
               "   AND adp03 = adq03 ",
               "   AND ",tm.wc  CLIPPED ,
               "   AND ",tm.wc2 CLIPPED,
                " INTO TEMP x "
    DROP TABLE x
    PREPARE q100_precount_x FROM g_sql
    EXECUTE q100_precount_x
 
    LET g_sql="SELECT COUNT(*) FROM x"
    PREPARE q100_precount FROM g_sql
    DECLARE q100_cnt CURSOR FOR q100_precount
    OPEN q100_cnt                                                            
    FETCH q100_cnt INTO g_row_count                                           
    CLOSE q100_cnt
END FUNCTION

FUNCTION q100_b_askkey()
   CONSTRUCT tm.wc2 ON adq04,adq10,adq05,adq09 FROM
	   s_adq[1].adq04,s_adq[1].adq10,s_adq[1].adq05,s_adq[1].adq09
              #No:FUN-580031 --start--     HCN

       #No:FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
           CALL cl_qbe_init()
        #No:FUN-580031 --end--       HCN

       ON IDLE g_idle_seconds                                                   
          CALL cl_on_idle()                                                     
          CONTINUE CONSTRUCT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
  
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
  
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
       #No:FUN-580031 --start--     HCN
       ON ACTION qbe_select
          CALL cl_qbe_select() 
       ON ACTION qbe_save
          CALL cl_qbe_save()
       #No:FUN-580031 --end--       HCN
   END CONSTRUCT
END FUNCTION

FUNCTION q100_menu()
    WHILE TRUE
      CALL q100_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q100_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION

FUNCTION q100_q()
    LET g_row_count = 0                                                        
    LET g_curs_index = 0                                                       
    CALL cl_navigator_setting( g_curs_index, g_row_count )                    
    MESSAGE ""      
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  #ATTRIBUTE(YELLOW)
    CALL q100_curs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       RETURN 
    END IF
    OPEN q100_cnt
    FETCH q100_cnt INTO g_row_count
    DISPLAY g_row_count TO cnt  #ATTRIBUTE(MAGENTA)
    OPEN q100_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       CALL q100_fetch('F')                 # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION

FUNCTION q100_fetch(p_flag)
DEFINE
    l_year 	    LIKE adr_file.adr04, # 年度    
    l_month	    LIKE adr_file.adr05, # 期別    
     #No.MOD-570124  --begin                                                     
    l_date          LIKE type_file.dat,    #No.FUN-680108 DATE                                                     
    l_date1         LIKE type_file.dat,    #No.FUN-680108 DATE                                                      
    l_adq09         LIKE adq_file.adq09,                                        
    l_adq091        LIKE adq_file.adq09,                                        
    l_adq092        LIKE adq_file.adq09,                                        
    l_adq093        LIKE adq_file.adq09,                                        
     #No.MOD-570124  --end 
    p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-680108 VARCHAR(1)

    CASE p_flag
        WHEN 'N' FETCH NEXT     q100_cs INTO g_adp.adp01,g_occ02,
                                             g_adp.adp02,g_ima02,g_adp.adp03,
                                             g_adr09,g_adp.adp05,g_adp.adp04
        WHEN 'P' FETCH PREVIOUS q100_cs INTO g_adp.adp01,g_occ02,
                                             g_adp.adp02,g_ima02,g_adp.adp03,
                                             g_adr09,g_adp.adp05, g_adp.adp04
        WHEN 'F' FETCH FIRST    q100_cs INTO g_adp.adp01,g_occ02,
                                             g_adp.adp02,g_ima02,g_adp.adp03,
                                             g_adr09,g_adp.adp05, g_adp.adp04
        WHEN 'L' FETCH LAST     q100_cs INTO g_adp.adp01,g_occ02,
                                             g_adp.adp02,g_ima02,g_adp.adp03,
                                             g_adr09,g_adp.adp05, g_adp.adp04
        WHEN '/'
          IF (NOT mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds                                           
                  CALL cl_on_idle()                                             
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
            END PROMPT     
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
            END IF
          END IF
          FETCH ABSOLUTE g_jump q100_cs INTO g_adp.adp01,g_occ02,
                                             g_adp.adp02,g_ima02,g_adp.adp03,
                                             g_adr09,g_adp.adp05,g_adp.adp04
          LET mi_no_ask = FALSE
    END CASE
{
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adp.adp01,SQLCA.sqlcode,0)
        INITIALIZE g_occ.* TO NULL  #TQC-6B0105
        RETURN
    END IF
}    
    CALL s_yp(g_bdate) RETURNING l_year, l_month
     LET l_date=MDY(l_month,1,l_year)  #No.MOD-570124
    LET l_month = l_month - 1
    IF l_month = 0 THEN
       LET l_month = 12
       LET l_year = l_year - 1
    END IF

    LET g_sql = " SELECT adr09 FROM adr_file ",
                "  WHERE adr01 = '",g_adp.adp01,"'",
                "    AND adr02 = '",g_adp.adp02,"'",
                "    AND adr03 = '",g_adp.adp03,"'",
                "    AND adr04 = '",l_year,"'",
                "    AND adr05 = '",l_month,"'" 
     PREPARE q100_adr09pre FROM g_sql
     DECLARE q100_adr09 CURSOR FOR q100_adr09pre
     OPEN q100_adr09 
     FETCH q100_adr09 INTO g_adr09
     CLOSE q100_adr09
     IF cl_null(g_adr09) THEN LET g_adr09 = 0 END IF
      #No.MOD-570124  --begin                                                    
     #期初數量還要加上期初至輸入日期前一天的數量                                
     LET l_date1=g_bdate-1                                                      
     SELECT SUM(adq09) INTO l_adq091 FROM adq_file   #本期銷售                  
      WHERE adq01 = g_adp.adp01 AND adq02 = g_adp.adp02                         
        AND adq03 = g_adp.adp03 AND adq04 BETWEEN l_date AND l_date1            
        AND adq10 = '1'                                                         
     SELECT SUM(adq09) INTO l_adq092 FROM adq_file   #本期銷退                  
      WHERE adq01 = g_adp.adp01 AND adq02 = g_adp.adp02                         
        AND adq03 = g_adp.adp03 AND adq04 BETWEEN l_date AND l_date1            
        AND adq10 = '2'                                                         
     SELECT SUM(adq09) INTO l_adq093 FROM adq_file   #客戶銷售                  
      WHERE adq01 = g_adp.adp01 AND adq02 = g_adp.adp02                         
        AND adq03 = g_adp.adp03 AND adq04 BETWEEN l_date AND l_date1            
        AND adq10 = '3'                                                         
     IF cl_null(l_adq091) THEN LET l_adq091 = 0 END IF                          
     IF cl_null(l_adq092) THEN LET l_adq092 = 0 END IF                          
     IF cl_null(l_adq093) THEN LET l_adq093 = 0 END IF                          
     LET l_adq09 = l_adq091 + l_adq092 + l_adq093                               
     LET g_adr09=g_adr09+l_adq09                                                
      #No.MOD-570124  --end

#   SELECT adp01,adp02,adp03,adp04,adp05 INTO g_adp.* 
#     FROM adp_file
#    WHERE 
#   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_adp.adp01,SQLCA.sqlcode,0)
#      RETURN
#   END IF
    IF SQLCA.sqlcode THEN                                                       
        CALL cl_err(g_adp.adp01,SQLCA.sqlcode,0)                                
    ELSE
       CASE p_flag                                                              
          WHEN 'F' LET g_curs_index = 1                                        
          WHEN 'P' LET g_curs_index = g_curs_index - 1                        
          WHEN 'N' LET g_curs_index = g_curs_index + 1                        
          WHEN 'L' LET g_curs_index = g_row_count                             
          WHEN '/' LET g_curs_index = g_jump                                   
       END CASE                                                                 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    CALL q100_show()
END FUNCTION

FUNCTION q100_show()

   DISPLAY g_adp.adp01,g_adp.adp02,g_adp.adp03,g_adp.adp04,g_adp.adp05 
        TO adp01,adp02,adp03,adp04,adp05  #ATTRIBUTE(YELLOW)  # 顯示單頭值
   IF cl_null(g_occ02) THEN LET g_occ02='' END IF
   IF cl_null(g_ima02) THEN LET g_ima02='' END IF
   DISPLAY g_occ02, g_ima02, g_bdate, g_adr09
        TO occ02, ima02,  bdate, adr09 #ATTRIBUTE(YELLOW)
   CALL q100_b_fill() #單身
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

FUNCTION q100_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,#No.FUN-680108 VARCHAR(500)
          l_bdate   LIKE type_file.dat,    #No.FUN-680108 DATE
          l_edate   LIKE type_file.dat,    #No.FUN-680108 DATE
          l_base    LIKE adr_file.adr09,   #MOD-4B0067
          l_adq09   LIKE adq_file.adq09    #MOD-4B0067

   LET l_sql =
        "SELECT adq04,adq10,'',adq05,adq09,0 ",
        "  FROM adq_file",
        " WHERE adq01 = '",g_adp.adp01,"'",
        "   AND adq02 = '",g_adp.adp02 ,"'",
        "   AND adq03 = '",g_adp.adp03 ,"'",
        "   AND ",tm.wc2 CLIPPED,
        " ORDER BY adq04 "
    PREPARE q100_pb FROM l_sql
    DECLARE q100_bcs                       #BODY CURSOR
        CURSOR FOR q100_pb

    LET g_rec_b=0
    LET l_base =0
    LET g_base =0
    LET l_adq09=0
    LET g_year = YEAR(g_bdate)
    LET g_month= MONTH(g_bdate)
    CALL s_azm(g_year,g_month) RETURNING g_flag, l_bdate, l_edate
#   IF g_flag = 1 THEN 
     #No.MOD-570124  --begin
    #   SELECT SUM(adq09) INTO g_base FROM adq_file
    #    WHERE adq01 = g_adp.adp01
    #      AND adq02 = g_adp.adp02
    #      AND adq03 = g_adp.adp03
    #      AND adq04 < g_bdate
    #      AND adq04 >= l_bdate
    #   IF SQLCA.sqlcode THEN
    #       CALL cl_err('Sel adq09 ERROR..',SQLCA.sqlcode,0)
    #       RETURN
    #   END IF
     #No.MOD-570124  --end 
#   ELSE 
#      CALL cl_err('BDate ERROR..',SQLCA.sqlcode,0)
#      RETURN
#   END IF
    IF cl_null(g_base) THEN LET g_base = 0 END IF
    LET l_base = l_base + g_adr09
    LET g_cnt = 1
     CALL g_adq.clear()  #No.MOD-571024
    FOREACH q100_bcs INTO g_adq[g_cnt].* 
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        CASE WHEN g_adq[g_cnt].adq10 = '1' LET g_adq[g_cnt].desc = '銷售'
             WHEN g_adq[g_cnt].adq10 = '2' LET g_adq[g_cnt].desc = '銷退'
             WHEN g_adq[g_cnt].adq10 = '3' LET g_adq[g_cnt].desc = '實際異動'
        END CASE
        IF g_adq[g_cnt].adq09 IS NULL THEN 
           LET g_adq[g_cnt].adq09 = 0 
        END IF
        IF l_base IS NULL THEN 
           LET l_base = 0 
        END IF
        LET l_adq09 = l_adq09 + g_adq[g_cnt].adq09
        LET g_adq[g_cnt].tot = l_base + l_adq09 + g_base
        LET g_cnt = g_cnt + 1
          IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF

    END FOREACH
    CALL g_adq.deleteElement(g_cnt)  
        LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數

END FUNCTION

FUNCTION q100_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)


   IF p_ud <> "G" THEN
      RETURN
   END IF

   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_adq TO s_adq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY                                                            
                                                                                
         CALL cl_navigator_setting( g_curs_index, g_row_count )
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first 
         CALL q100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF
           ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION previous
         CALL q100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION jump 
         CALL q100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION next
         CALL q100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION last
         CALL q100_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

   ON ACTION accept
      LET l_ac = ARR_CURR()
      EXIT DISPLAY

   ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit" 
         EXIT DISPLAY 

      ON ACTION close
      LET g_action_choice="exit"
      EXIT DISPLAY

   ON IDLE g_idle_seconds                                                    
      CALL cl_on_idle()                                                      
      CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---

 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
