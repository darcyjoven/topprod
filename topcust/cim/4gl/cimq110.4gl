# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: cimq110.4gl
# Descriptions...: 仓库日出入汇总表
# Date & Author..: 93/03/16 BY try
# No:190109        19/01/09 By pulf 数量未考虑换算率

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE
     tm  RECORD
              bdate     DATE,
              edate     DATE,
        	wc      LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(600)# Head Where condition
        	wc2  	LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(600)# Body Where condition
        END RECORD,
    g_tlf  RECORD
            tlf902     LIKE tlf_file.tlf902,
            tlf903     LIKE tlf_file.tlf903,
            tlf01      LIKE tlf_file.tlf01
        END RECORD,
    g_tlf1 DYNAMIC ARRAY OF RECORD
            tlf06     LIKE tlf_file.tlf06,
            tlf011     LIKE tlf_file.tlf01,
            ima02     LIKE ima_file.ima02,
            ima021    LIKE ima_file.ima021,
            qichu     LIKE img_file.img10,
            ruku      LIKE img_file.img10,
            chuku     LIKE img_file.img10,
            jiecun    LIKE img_file.img10,
            tlf902    LIKE tlf_file.tlf902,
            tlf903    LIKE tlf_file.tlf903 
        END RECORD,
#   g_argv1     LIKE ima_file.ima01,              # INPUT ARGUMENT - 1
     g_wc,g_wc2      string, #WHERE CONDITION  #No.FUN-580092 HCN
     g_sql           string, #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b LIKE type_file.num5   	       #單身筆數        #No.FUN-680121 SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10          #No.FUN-680121 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10          #No.FUN-680121 INTEGER
DEFINE   g_jump         LIKE type_file.num10          #No.FUN-680121 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE   g_yy        LIKE imk_file.imk05,
         g_mm        LIKE imk_file.imk06,
         g_bdate     DATE,
         g_edate     DATE


MAIN
#     DEFINE   l_time LIKE type_file.chr8	     #No.FUN-6A0090
      DEFINE   l_sl,p_row,p_col LIKE type_file.num5  #No.FUN-680121 SMALLINT #No.FUN-6A0090
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CIM")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
         RETURNING g_time    #No.FUN-6A0090
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 20
   ELSE LET p_row = 3 LET p_col = 2
   END IF
    OPEN WINDOW cimq110_w AT p_row,p_col
        WITH FORM "cim/42f/cimq110"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    CALL cl_set_comp_visible("sfa012,ecu014,sfa013,sfa08",g_sma.sma541 = 'Y')     #No.FUN-A60027  
    CALL q110_menu()
    CLOSE WINDOW q110_srn               #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
         RETURNING g_time    #No.FUN-6A0090
END MAIN
 
#QBE 查詢資料
FUNCTION q110_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
      CLEAR FORM #清除畫面
   CALL g_tlf1.clear()
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL			        # Default condition
      CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_tlf.* TO NULL    #No.FUN-750051
      INPUT BY NAME tm.bdate,tm.edate
      BEFORE INPUT
        LET tm.bdate=g_today
        LET tm.edate=g_today
        DISPLAY BY NAME tm.bdate,tm.edate
 
      AFTER FIELD bdate
        IF cl_null(tm.bdate) THEN
           CALL cl_err('','cim-090',1)
           NEXT FIELD bdate
        END IF 
        DISPLAY BY NAME tm.bdate
      AFTER FIELD edate
        IF cl_null(tm.edate) THEN
           CALL cl_err('','cim-090',1)
           NEXT FIELD edate
        ELSE
           IF tm.edate<tm.bdate THEN
              CALL cl_err('','cim-091',1)
              NEXT FIELD edate
           END IF           

        END IF
        DISPLAY BY NAME tm.edate


       ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END INPUT

      CONSTRUCT BY NAME tm.wc ON tlf902,tlf903,tlf01
                                 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      #MOD-530850
     ON ACTION CONTROLP
        CASE
          WHEN INFIELD(tlf902)
             CALL cl_init_qry_var()
             LET g_qryparam.form     = "q_imd01"
             LET g_qryparam.state    = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO tlf902
          WHEN INFIELD(tlf903)
             CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","")
                          RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO tlf903
             NEXT FIELD tlf903
          WHEN INFIELD(tlf01) 
             CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO tlf01
             NEXT FIELD tlf01
 
 
 
         OTHERWISE
            EXIT CASE
       END CASE
    #--
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
      IF INT_FLAG THEN
         RETURN
      END IF
     # CALL q110_b_askkey()
      IF INT_FLAG THEN
         RETURN
      END IF
END FUNCTION
 {
FUNCTION q110_b_askkey()
 
      CONSTRUCT  tm.wc2 ON  # 螢幕上取單身條件
      sfb13,sfb01,sfa05,sfa06,sfa25,sfa012,sfa013,sfa08         #FUN-A60027 add sfa012,sfa013,sfa08
      FROM s_sfb[1].sfb13,s_sfb[1].sfb01,
           s_sfb[1].sfa05,s_sfb[1].sfa06,s_sfb[1].sfa25,s_sfb[1].sfa012,s_sfb[1].sfa013,s_sfb[1].sfa08   #FUN-A60027 modify 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
 
END FUNCTION
 }
FUNCTION q110_menu()
 
   WHILE TRUE
      CALL q110_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q110_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#FUN-4B0011
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tlf1),'','')
            END IF
##
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q110_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
  # DISPLAY '   ' TO FORMONLY.cnt
    CALL q110_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE " SEARCHING ! "
    #OPEN q110_cs                            # 從DB產生合乎條件TEMP(0-30秒)
#    IF SQLCA.sqlcode THEN
#        CALL cl_err('',SQLCA.sqlcode,0)
#    ELSE
    #    OPEN q110_count
    #    FETCH q110_count INTO g_row_count
       #CALL q110_fetch('F')                  # 讀出TEMP第一筆並顯示
        CALL q110_b_fill()
 #   END IF
    MESSAGE ""
END FUNCTION
 
{
FUNCTION q110_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680121 VARCHAR(1)
    l_abso          LIKE type_file.num10,                #絕對的筆數      #No.FUN-680121 INTEGER
    l_n1            LIKE type_file.num15_3,              ###GP5.2  #NO.FUN-A20044
    l_n2            LIKE type_file.num15_3,              ###GP5.2  #NO.FUN-A20044
    l_n3            LIKE type_file.num15_3               ###GP5.2  #NO.FUN-A20044 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q110_cs INTO g_ima.ima01
        WHEN 'P' FETCH PREVIOUS q110_cs INTO g_ima.ima01
        WHEN 'F' FETCH FIRST    q110_cs INTO g_ima.ima01
        WHEN 'L' FETCH LAST     q110_cs INTO g_ima.ima01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump q110_cs INTO g_ima.ima01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL  #TQC-6B0105
        RETURN
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
#	SELECT ima01,ima02,ima08,ima05,ima021,ima262   #NO.FUN-A20044
# SELECT ima01,ima02,ima08,ima05,ima021,0        #NO.FUN-A20044  #TQC-D70081-mark
        SELECT ima01,ima02,ima05,ima08,ima021,0    #TQC-D70081--add--
	  INTO g_ima.*
	  FROM ima_file
	 WHERE ima01 = g_ima.ima01
    IF SQLCA.sqlcode THEN
   #    CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)  #No.FUN-660128
        CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",0)          #No.FUN-660128
        RETURN
    END IF
    CALL s_getstock(g_ima.ima01,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044
    LET g_ima.avl_stk = l_n3 
    CALL q110_show()
END FUNCTION
  }
FUNCTION q110_show()
   DISPLAY BY NAME g_tlf.*   # 顯示單頭值
   CALL q110_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q110_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(1000)
#         l_qty     LIKE ima_file.ima26,          #No.FUN-680121 DECIMAL(12,3)
#         l_tt      LIKE ima_file.ima26           #No.FUN-680121 DECIMAL(12,3)
          l_qty     LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
          l_tt      LIKE type_file.num15_3        ###GP5.2  #NO.FUN-A20044
   DEFINE l_ecu014  LIKE ecu_file.ecu014          #No.FUN-A60027 
   DEFINE l_flag    LIKE type_file.num5           #MOD-AC0336
   DEFINE l_sfb05   LIKE sfb_file.sfb05           #MOD-AC0336
   DEFINE l_sfb06   LIKE sfb_file.sfb06           #MOD-AC0336
   DEFINE  l_tlf902  LIKE tlf_file.tlf902,
           l_tlf903  LIKE tlf_file.tlf903
   DEFINE  l_date    DATE 
   DEFINE  ll_yy     LIKE imk_file.imk05,
           ll_mm     LIKE imk_file.imk06,
           l_bdate   DATE,
           l_edate   DATE,
           ll_tlf10  LIKE tlf_file.tlf10,
           l_tlf10   LIKE tlf_file.tlf10,
           l_imk09   LIKE imk_file.imk09
   


   LET l_sql =
        "SELECT DISTINCT  tlf06,tlf01,ima02,ima021,0 qichu,0 ruku,0 chuku,0 jiecun,tlf902,tlf903  ",
        " FROM   tlf_file ",
        " LEFT JOIN ima_file ON tlf01=ima01 ",
        " WHERE  tlf06 BETWEEN  TO_DATE('",tm.bdate,"','yy/mm/dd') AND to_date ('",tm.edate,"','yy/mm/dd') AND ",tm.wc,
        " ORDER BY tlf01,tlf06,tlf902,tlf903  "
    PREPARE q110_pb FROM l_sql
    DECLARE q110_bcs                       #BODY CURSOR
        CURSOR FOR q110_pb
 
    FOR g_cnt = 1 TO g_tlf1.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_tlf1[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0
    LET g_cnt = 1
    SELECT add_months(to_date(tm.bdate,'yy/mm/dd'),-1) INTO l_date FROM dual
    LET g_yy=YEAR(l_date)  #上月年份
    LET g_mm=MONTH(l_date) #上月月份
    CALL s_azn01(g_yy,g_mm) RETURNING  g_bdate,g_edate   #上期期末最后一天
    LET ll_yy=YEAR(tm.bdate)  #开始日期年份
    lET ll_mm=MONTH(tm.edate) #开始日期月份
    CALL s_azn01(ll_yy,ll_mm) RETURNING  l_bdate,l_edate  #返回开始日期的第一天和 最后一天
    FOREACH q110_bcs INTO g_tlf1[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF 
        
        #期初给值  
           #取上期期末
        SELECT SUM(imk09) INTO l_imk09 FROM imk_file WHERE imk01=g_tlf1[g_cnt].tlf011 AND imk02=g_tlf1[g_cnt].tlf902 
        AND imk03=g_tlf1[g_cnt].tlf903 AND imk05=g_yy AND imk06=g_mm
        IF cl_null(l_imk09) THEN LET l_imk09=0 END IF 
 
        # 得到开始日期月份到开始日期前一天库存异动汇总  
        IF g_tlf1[g_cnt].tlf06=g_edate+1 THEN   #如果开始日期为当月第一天 则期初=上月期末
           LET g_tlf1[g_cnt].qichu=l_imk09 
        ELSE
           SELECT SUM(tlf10*tlf907*tlf12) INTO l_tlf10 FROM tlf_file WHERE tlf01=g_tlf1[g_cnt].tlf011 AND tlf902=g_tlf1[g_cnt].tlf902    #No:190109 add *tlf12
           AND tlf903=g_tlf1[g_cnt].tlf903 AND tlf06 BETWEEN g_edate+1 AND g_tlf1[g_cnt].tlf06-1 AND tlf907!=0 
           IF cl_null(l_tlf10) THEN LET l_tlf10=0 END IF
           LET g_tlf1[g_cnt].qichu =l_imk09 +l_tlf10   #期初=上期期末结存+当月异动
        END IF 
        #  当天入库
        SELECT  SUM(tlf10*tlf12) INTO g_tlf1[g_cnt].ruku FROM tlf_file WHERE tlf01=g_tlf1[g_cnt].tlf011 AND tlf902=g_tlf1[g_cnt].tlf902  #No:190109 add *tlf12
        AND tlf903=g_tlf1[g_cnt].tlf903 AND tlf06=g_tlf1[g_cnt].tlf06 AND tlf907=1 
        IF cl_null(g_tlf1[g_cnt].ruku) THEN LET g_tlf1[g_cnt].ruku=0 END IF 
        # 当天出库 
        SELECT  SUM(tlf10*tlf12) INTO g_tlf1[g_cnt].chuku FROM tlf_file WHERE tlf01=g_tlf1[g_cnt].tlf011 AND tlf902=g_tlf1[g_cnt].tlf902 #No:190109 add *tlf12
        AND tlf903=g_tlf1[g_cnt].tlf903 AND tlf06=g_tlf1[g_cnt].tlf06 AND tlf907=-1
        IF cl_null(g_tlf1[g_cnt].chuku) THEN LET g_tlf1[g_cnt].chuku=0 END IF 
        #当日结存  =上期期末+当月到当天的库存异动
        SELECT sum(tlf10*tlf907*tlf12) INTO ll_tlf10 FROM tlf_file WHERE tlf01=g_tlf1[g_cnt].tlf011 AND tlf902=g_tlf1[g_cnt].tlf902      #No:190109 add *tlf12
        AND tlf903=g_tlf1[g_cnt].tlf903 AND tlf06 BETWEEN g_edate+1 AND g_tlf1[g_cnt].tlf06  AND tlf907!=0
        IF cl_null(ll_tlf10) THEN LET ll_tlf10=0 END IF
        LET g_tlf1[g_cnt].jiecun=l_imk09+ll_tlf10 
        LET g_cnt=g_cnt+1

     # IF g_cnt > g_max_rec THEN
     #    CALL cl_err( '', 9035, 0 )
#	 EXIT FOREACH
#      END IF


    END FOREACH
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt=0
END FUNCTION
 
FUNCTION q110_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tlf1 TO s_tlf1.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
   {   ON ACTION first
      #   CALL q110_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
      #   CALL q110_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q110_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q110_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q110_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 }
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
 #MOD-530217........................begin
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 #MOD-530217........................end
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
#FUN-4B0011
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END       
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
