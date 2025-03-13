# Prog. Version..: '5.30.06-13.03.29(00007)'     #
#
# Pattern name...: abmq617.4gl
# Desc/riptions..: 主件插件位置差異分析查詢
# Date & Author..: 92/11/09 By Apple
# Modify.........: 93/12/29 By Apple 
#                : 單階時同一插件位置/料號相同列示一行
# Modify.........: No.FUN-4A0003 04/10/05 By Yuna 
#                              1.元件編號開窗
#                              2.主件料件(一), 應開BOM,主件,而不是開料件編號
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-550093 05/06/02 By kim 配方BOM
# Modify.........: No.FUN-560021 05/06/08 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.FUN-560074 05/06/16 By pengu  CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-560085 05/06/18 By kim 查詢時, 輸入主件編號還未輸入特性代碼即show BOM不存在
# Modify.........: No.FUN-560227 05/06/27 By kim 將組成用量/底數/QPA全部alter成 DEC(16,8)
# Modify.........: No.TQC-660046 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/17 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-760078 07/06/07 By Judy 查詢時候，彈出一頁面，點擊此彈出頁面中的“退出”，abmq617頁面也退出
# Modify.........: No.FUN-8B0015 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910
# Modify.........: No.MOD-920245 09/02/19 By claire 調整OUTER寫法
# Modify.........: No.TQC-970046 09/07/27 By sherry 尾階的插件位置沒有進行換算       
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-CA0115 12/10/29 By Elise q617_bcs2的sql加上條件bmt02=bmb02
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
	tm          RECORD
                    wc      LIKE type_file.chr1000,   # Where condition  #No.FUN-680096 VARCHAR(500)
                    part1   LIKE bma_file.bma01,      # 主件料件-1
                    acode1  LIKE bma_file.bma06,      #FUN-550093
                    part2   LIKE bma_file.bma01,      # 主件料件-2
                    acode2  LIKE bma_file.bma06,      #FUN-550093
                    num     LIKE type_file.num5,      #No.FUN-680096 SMALLINT
                    vdate   LIKE bmb_file.bmb04,      # 有效日期
                    choice  LIKE type_file.chr1       # (1).單階 (2).多階 #No.FUN-680096 VARCHAR(1)
                    END RECORD,
	g_bmb       DYNAMIC ARRAY OF RECORD           #程式變數(Program Variables)
                    bmb13   LIKE bmb_file.bmb13,      #插件位置
                    bmb03   LIKE bmb_file.bmb03,      #元件
                    ima02   LIKE ima_file.ima02,      #品名規格
                    ima021  LIKE ima_file.ima021,     #品名規格
                    bmb06_1 LIKE bmb_file.bmb06,      #QPA  #FUN-560227 
                    bmb06_2 LIKE bmb_file.bmb06       #QPA  #FUN-560227  
                    END RECORD,
        l_flag      LIKE type_file.chr1,             #No.FUN-680096 VARCHAR(1)
        g_no        LIKE type_file.num10,            #No.FUN-680096 INTEGER,
	g_rec_b     LIKE type_file.num5,             #單身筆數        #No.FUN-680096 SMALLINT
	l_ac        LIKE type_file.num5,             #目前處理的ARRAY CNT        #No.FUN-680096 SMALLINT
	l_sl        LIKE type_file.num5              #目前處理的SCREEN LINE #No.FUN-680096 SMALLINT
DEFINE  p_row,p_col LIKE type_file.num5              #No.FUN-680096 SMALLINT
 
#主程式開始
DEFINE   g_cnt      LIKE type_file.num10             #No.FUN-680096 INTEGER
MAIN
# DEFINE                                #No.FUN-6A0060 
#       l_time	LIKE type_file.chr8     #No.FUN-6A0060
 
	OPTIONS						    #改變一些系統預設值
  INPUT NO WRAP
	DEFER INTERRUPT				#擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
 
 	 CALL  cl_used(g_prog,g_time,1)	#計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time               #No.FUN-6A0060
        LET p_row = 3 LET p_col = 2
 
	OPEN WINDOW q617_w  AT p_row,p_col
		WITH FORM "abm/42f/abmq617" 
                 ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
        CALL cl_ui_init()
 
        #FUN-560021................begin
        CALL cl_set_comp_visible("bma06_1,bma06_2",g_sma.sma118='Y')
        #FUN-560021................end
 
#	IF cl_chk_act_auth() THEN
#		CALL q617_q()
		IF INT_FLAG THEN
			LET INT_FLAG=0
    		CLOSE WINDOW q617_w		#結束畫面
			EXIT PROGRAM
		END IF
#	END IF
        CALL q617_menu()
	CLOSE WINDOW q617_w			#結束畫面
    DROP TABLE q617_file
 	 CALL  cl_used(g_prog,g_time,2)	#計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060
END MAIN
 
#QBE 查詢資料
FUNCTION q617_cs()
   DEFINE   l_cnt   LIKE type_file.num5           #No.FUN-680096 SMALLINT
 
 
   CLEAR FORM #清除畫面
   CALL g_bmb.clear()
   LET p_row = 7 
   LET p_col = 11
   OPEN WINDOW q617_w2 AT p_row,p_col				#條件劃面
      WITH FORM "abm/42f/abmq6171" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("abmq6171")
 
    #FUN-560021................begin
    CALL cl_set_comp_visible("acode1,acode2",g_sma.sma118='Y')
    #FUN-560021................end
 
   CALL cl_opmsg('q')
   LET tm.vdate  = g_today
   LET tm.choice = '1'
   LET tm.num    =  1
   WHILE TRUE
      CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
      CONSTRUCT BY NAME tm.wc ON bmb03,bmt06 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         #--No.FUN-4A0003--------
         ON ACTION CONTROLP
           CASE WHEN INFIELD(bmb03) #元件編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
         	  LET g_qryparam.form = "q_ima"
         	  CALL cl_create_qry() RETURNING g_qryparam.multiret
         	  DISPLAY g_qryparam.multiret TO bmb03
         	  NEXT FIELD bmb03
            OTHERWISE EXIT CASE
            END CASE
         #--END---------------    
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW q617_w2 
#        EXIT PROGRAM  #TQC-760078 mark
         RETURN    #TQC-760078
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   DISPLAY BY NAME tm.num,tm.vdate,tm.choice  
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
   INPUT BY NAME tm.part1,tm.acode1,tm.part2,tm.acode2,tm.num,tm.vdate,tm.choice WITHOUT DEFAULTS #FUN-550093
 
      AFTER FIELD part1  
   	 IF cl_null(tm.part1) THEN
    	    NEXT FIELD part1   
         ELSE
            CALL q617_item(tm.part1,tm.acode1) #FUN-550093
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.part1,g_errno,0)
               DISPLAY BY NAME tm.part1 
               NEXT FIELD part1
            END IF
         END IF
 
      AFTER FIELD part2  
         IF g_sma.sma118!='Y' THEN
            IF tm.part1 = tm.part2 THEN 
               NEXT FIELD part1 
            END IF
         END IF
   	 IF cl_null(tm.part2) THEN
    	    NEXT FIELD part2   
         ELSE 
            CALL q617_item(tm.part2,tm.acode2) #FUN-550093
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.part2,g_errno,0)
               DISPLAY BY NAME tm.part2 
               NEXT FIELD part2
            END IF
   	 END IF
 
      #FUN-560085................begin
      AFTER FIELD acode1
         IF NOT cl_null(tm.part1) THEN
            CALL q617_item(tm.part1,tm.acode1) #FUN-550093
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.part1,g_errno,0)
               LET tm.acode1=NULL
               DISPLAY BY NAME tm.acode1
               NEXT FIELD part1 
            END IF
         END IF 
      #FUN-560085................end
 
      #FUN-560085................begin
      AFTER FIELD acode2
         IF g_sma.sma118='Y' THEN
            IF (tm.part1 = tm.part2) AND (tm.acode1 = tm.acode2) THEN 
               NEXT FIELD part1 
            END IF
         END IF
         IF NOT cl_null(tm.part2) THEN
            CALL q617_item(tm.part2,tm.acode2) #FUN-550093
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.part2,g_errno,0)
               LET tm.acode2=NULL
               DISPLAY BY NAME tm.acode2
               NEXT FIELD part2
            END IF
         END IF 
      #FUN-560085................end
 
      AFTER FIELD num
         IF cl_null(tm.num) OR tm.num <=0 THEN
            NEXT FIELD num
         END IF 
 
      AFTER FIELD choice 
   	 IF cl_null(tm.choice) OR tm.choice NOT MATCHES'[12]' THEN
    	    NEXT FIELD choice  
   	 END IF
   
      AFTER INPUT 
   	 IF INT_FLAG THEN 
            CLOSE WINDOW q617_w2 
            EXIT INPUT
         END IF
         LET l_flag = 'N'
   	 IF cl_null(tm.part1) THEN 
            LET l_flag = 'Y' 
            DISPLAY BY NAME tm.part1 
         END IF
   	 IF cl_null(tm.part2) THEN 
            LET l_flag = 'Y' 
            DISPLAY BY NAME tm.part2 
         END IF
   	 IF cl_null(tm.num) OR tm.num <= 0 THEN 
            LET l_flag = 'Y' 
            DISPLAY BY NAME tm.part2 
         END IF
   	 IF cl_null(tm.choice) OR tm.choice NOT MATCHES'[12]' THEN 
            LET l_flag = 'Y' 
            DISPLAY BY NAME tm.part2 
         END IF
         IF l_flag='Y' THEN
            CALL cl_err('','9033',0)
            NEXT FIELD part1
         END IF
 
         #FUN-560085................begin
         IF cl_null(tm.acode1) THEN
            LET tm.acode1=' '
         END IF 
         IF cl_null(tm.acode2) THEN
            LET tm.acode2=' '
         END IF 
         #FUN-560085................end
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()		# Command execution
 
 
      ON ACTION CONTROLP     #查詢條件 
         CASE
            WHEN INFIELD(part1) #主件-1
               CALL cl_init_qry_var()
               #FUN-550093................begin
#              LET g_qryparam.form = "q_bma2"
#              LET g_qryparam.default1 = tm.part1
#              CALL cl_create_qry() RETURNING tm.part1
#              DISPLAY BY NAME tm.part1    
               LET g_qryparam.form = "q_bma6"
               LET g_qryparam.default1 = tm.part1
               LET g_qryparam.default2 = tm.acode1
               CALL cl_create_qry() RETURNING tm.part1,tm.acode1
               DISPLAY BY NAME tm.part1,tm.acode1    
               #FUN-550093................end
               NEXT FIELD part1
            WHEN INFIELD(part2) #主件-1
               CALL cl_init_qry_var()
               #FUN-550093................begin
#              LET g_qryparam.form = "q_bma2"
#              LET g_qryparam.default1 = tm.part2
#              CALL cl_create_qry() RETURNING tm.part2
#              DISPLAY BY NAME tm.part2    
               LET g_qryparam.form = "q_bma6"
               LET g_qryparam.default1 = tm.part2
               LET g_qryparam.default2 = tm.acode2
               CALL cl_create_qry() RETURNING tm.part2,tm.acode2
               DISPLAY BY NAME tm.part2,tm.acode2    
               #FUN-550093................end
               NEXT FIELD part2
            OTHERWISE EXIT CASE
         END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
   END INPUT
   IF INT_FLAG THEN 
      CLOSE WINDOW q617_w2
      RETURN
   END IF
   CLOSE WINDOW q617_w2
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
END FUNCTION
   
FUNCTION q617_item(p_item,p_acode)    #主件編號 #FUN-550093
    DEFINE p_item    LIKE bma_file.bma01,
           p_acode   LIKE bma_file.bma06,   #FUN-550093
           l_sql     STRING,                #FUN-550093
           l_cn      LIKE type_file.num10,  #No.FUN-680096 INTEGER
           l_bmaacti LIKE bma_file.bmaacti
 
    LET g_errno = ' '
    #FUN-550093................begin
    IF (p_acode is NULL) OR (p_acode=' ') THEN
       IF INFIELD(part1) OR INFIELD(part2) THEN
          SELECT COUNT(*) INTO l_cn FROM bma_file WHERE bma01=p_item 
                                   #AND (bma06 is NULL OR bma06='' OR bma06=' ') #FUN-560085 
       ELSE
          SELECT COUNT(*) INTO l_cn FROM bma_file WHERE bma01=p_item 
                                    AND (bma06 is NULL OR bma06='' OR bma06=' ') #FUN-560085 
       END IF
       IF l_cn=0 THEN
           LET g_errno  = 'mfg2744'
           LET l_bmaacti= NULL
           RETURN
       END IF
 
       LET l_sql="SELECT bmaacti FROM bma_file WHERE bma01 = '",p_item,"'",
                 " AND (bma06 is NULL OR bma06='' OR bma06=' ')"
       PREPARE q617_item_sql FROM l_sql
       DECLARE q617_item_c1 CURSOR FOR q617_item_sql
       OPEN q617_item_c1
       IF (SQLCA.sqlcode=100) THEN 
           LET g_errno  = 'mfg2744'
           LET l_bmaacti= NULL
       END IF
       FETCH q617_item_c1 INTO l_bmaacti
       IF l_bmaacti='N' THEN
          LET g_errno = '9028'
       END IF
       CLOSE q617_item_c1
    ELSE
    #FUN-550093................end
       SELECT bmaacti INTO l_bmaacti
              FROM bma_file WHERE bma01 = p_item 
              AND bma06=p_acode
       CASE WHEN SQLCA.SQLCODE = 100  LET g_errno  = 'mfg2744'
                                      LET l_bmaacti= NULL
            WHEN l_bmaacti='N' LET g_errno = '9028'
            OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
    END IF
END FUNCTION
 
FUNCTION q617_menu()
 
   WHILE TRUE
      CALL q617_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN 
               CALL q617_q() 
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"       
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bmb),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION q617_q()
	CALL cl_opmsg('q')
	MESSAGE ""
	CLEAR FORM
   CALL g_bmb.clear()
	DISPLAY '   ' TO FORMONLY.cnt  
	CALL q617_cs()
	IF INT_FLAG THEN RETURN END IF
	MESSAGE 'SEARCHING ' 
    CALL q617_show()
	MESSAGE ""
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION q617_show()
 DEFINE l_str    LIKE type_file.chr8     #No.FUN-680096 VARCHAR(8)
 
    IF tm.choice = '1' THEN    #單階
         CALL cl_getmsg('mfg2742',g_lang) RETURNING l_str
    ELSE
         CALL cl_getmsg('mfg2743',g_lang) RETURNING l_str
    END IF 
    DISPLAY tm.vdate TO FORMONLY.vdate 
    DISPLAY tm.part1 TO FORMONLY.part1 
    CALL q617_ima01(tm.part1,"1")
    DISPLAY tm.part2 TO FORMONLY.part2 
    CALL q617_ima01(tm.part2,"2")
	DISPLAY l_str   TO FORMONLY.desc 
    #FUN-550093................begin
      DISPLAY tm.acode1 TO FORMONLY.bma06_1
      DISPLAY tm.acode2 TO FORMONLY.bma06_2
    #FUN-550093................end    
    CALL q617_temp()
    IF tm.choice = '1' THEN  #單階
    	CALL q617_b_fill()   
    ELSE 
        CALL q617_b_fill2()  #尾階
    END IF
    DROP TABLE q617_file 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#Body Fill Up
FUNCTION q617_b_fill()
DEFINE l_sql     LIKE type_file.chr1000,       #No.FUN-680096 VARCHAR(1000)
       l_bmb     RECORD  
                 bmb01  LIKE bmb_file.bmb01,    #主件
                 bmb13  LIKE bmb_file.bmb13,    #插件位置
                 bmb03  LIKE bmb_file.bmb03,    #元件
                 ima02  LIKE ima_file.ima02,    #品名
                 ima021 LIKE ima_file.ima021,   #規格
                 bmb06  LIKE bmb_file.bmb06,    #組成用量
                 bmb29  LIKE bmb_file.bmb29     #特性代碼 #MOD-640274
                 END RECORD,
       l_qpa     LIKE bmb_file.bmb06 #FUN-560227
 
	LET l_sql=
		" SELECT bmb01,bmt06,bmb03,ima02,ima021,",
        " (bmt07 * bmb10_fac),bmb29", #MOD-640274 add bmb29
		" FROM bmb_file , bmt_file , OUTER ima_file ",
		" WHERE bmb_file.bmb03 = ima_file.ima01 AND  ",
		"       bmb01 = bmt01 AND  ",
		"       bmb02 = bmt02 AND  ",
		"       bmb03 = bmt03 AND  ",
		"       bmb04 = bmt04 AND  ",
        #FUN-550093................begin     
                "       bmb29 = bmt08 AND  ",
       #"     ( bmb01 ='",tm.part1,"' OR ",
       #"       bmb01 ='",tm.part2 ,"' ) "
        "    (( bmb01 ='",tm.part1,"' AND bmb29='",tm.acode1,"') OR ",
        "     ( bmb01 ='",tm.part2,"' AND bmb29='",tm.acode2,"')) "
        #FUN-550093................end
    IF tm.vdate IS NOT NULL THEN 
        LET l_sql = l_sql clipped, 
                  " AND (bmb04 <='",tm.vdate,"'"," OR bmb04 IS NULL )",
                  " AND (bmb05 > '",tm.vdate,"'"," OR bmb05 IS NULL ) "
    END IF
	PREPARE q617_pb FROM l_sql
	DECLARE q617_bcs	#CURSOR
		CURSOR FOR q617_pb
 
	FOREACH q617_bcs INTO l_bmb.*
		IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
        END IF
        LET l_qpa = l_bmb.bmb06 * tm.num
        IF l_bmb.bmb13 IS NULL THEN LET l_bmb.bmb13 = ' ' END IF
       #IF l_bmb.bmb01 = tm.part1 THEN #MOD-640274 
        IF (l_bmb.bmb01 = tm.part1) AND (l_bmb.bmb29=tm.acode1) THEN #MOD-640274
           INSERT INTO q617_file VALUES(l_bmb.bmb13,
                                        l_bmb.bmb03,
                                        l_bmb.ima02,
                                        l_bmb.ima021,
                                        l_qpa,       
                                        0)
           IF SQLCA.sqlcode THEN 
              UPDATE q617_file SET bmb06_1 = bmb06_1 + l_qpa
                             WHERE bmt06 = l_bmb.bmb13
                               AND bmb03 = l_bmb.bmb03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0
              THEN
              # CALL cl_err('ckp#1',SQLCA.sqlcode,1) #No.TQC-660046
               CALL cl_err3("upd","q617_file",l_bmb.bmb13,l_bmb.bmb03,SQLCA.sqlcode,"","ckp#1",1)  #NO.TQC-660046
                   EXIT FOREACH 
              END IF
           END IF
        ELSE 
           INSERT INTO q617_file VALUES(l_bmb.bmb13,
                                        l_bmb.bmb03,
                                        l_bmb.ima02,
                                        l_bmb.ima021,
                                        0,   
                                        l_qpa)
           IF SQLCA.sqlcode THEN
              UPDATE q617_file SET bmb06_2 = bmb06_2 + l_qpa
                             WHERE bmt06 = l_bmb.bmb13
                               AND bmb03 = l_bmb.bmb03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0
              THEN
 #              CALL cl_err('ckp#2',SQLCA.sqlcode,1) #No.TQC-660046
               CALL cl_err3("upd","q617_file",l_bmb.bmb13,l_bmb.bmb03,SQLCA.sqlcode,"","ckp#2",1)  # No.TQC-660046
                 
                   EXIT FOREACH 
              END IF
           END IF
        END IF
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
	FOR g_cnt = 1 TO g_bmb.getLength()					#單身 ARRAY 乾洗
		INITIALIZE g_bmb[g_cnt].* TO NULL
        LET g_bmb[g_cnt].bmb06_1 = 0
        LET g_bmb[g_cnt].bmb06_2 = 0
	END FOR
	LET g_rec_b=0
	LET g_cnt = 1
	LET g_no  = 0
    CALL q617_collect()
END FUNCTION
   
FUNCTION q617_b_fill2()
 DEFINE  l_cmd   LIKE type_file.chr1000 #No.FUN-680096 VARCHAR(1000)
 
	FOR g_cnt = 1 TO g_bmb.getLength()					#單身 ARRAY 乾洗
		INITIALIZE g_bmb[g_cnt].* TO NULL
        LET g_bmb[g_cnt].bmb06_1 = 0
        LET g_bmb[g_cnt].bmb06_2 = 0
	END FOR
	LET g_rec_b=0
	LET g_cnt = 1
	LET g_no  = 0
    #TQC-970046---Begin
    #CALL q617_bom(1,tm.part1,tm.acode1)
    #CALL q617_bom(2,tm.part2,tm.acode2)
    CALL q617_bom(1,tm.part1,tm.acode1,1)                                                                                           
    CALL q617_bom(2,tm.part2,tm.acode2,1)                                                                                           
    #TQC-970046---end       
    CALL q617_collect()
END FUNCTION 
   
FUNCTION q617_collect()
 DEFINE l_cmd   LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(1000)
 
	LET l_cmd= " SELECT * FROM q617_file ",
#bugno:5668     "    WHERE ",tm.wc clipped,   
               "  WHERE bmt06 IS NOT NULL AND  ",tm.wc clipped,
               " ORDER BY bmt06,bmb03 "
 
	PREPARE q617_pshw1 FROM l_cmd
	DECLARE q617_bshw1    #CURSOR
		CURSOR FOR q617_pshw1
        LET g_no = 1
        LET g_rec_b=0
	FOREACH q617_bshw1 INTO g_bmb[g_no].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('Foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
           END IF
           IF cl_null(g_bmb[g_no].bmb13) THEN
               LET g_no = g_no
            ELSE
               LET g_no = g_no + 1
            END IF
        END FOREACH
        LET g_cnt=g_no-1
       #LET g_rec_b=g_cnt-1  #MOD-640274
        LET g_rec_b=g_cnt    #MOD-640274
        DISPLAY g_rec_b TO FORMONLY.cnt  
END FUNCTION 
 
#Body Fill Up
#FUNCTION q617_bom(p_loc,p_item,p_acode) #FUN-550093        #TQC-970046 mark 
FUNCTION q617_bom(p_loc,p_item,p_acode,p_qpa) #FUN-550093   #TQC-970046 add p_qpa   
DEFINE  l_sql    LIKE type_file.chr1000,#No.FUN-680096 VARCHAR(1000)
        p_loc    LIKE type_file.num5,   #No.FUN-680096 SMALLINT
        p_item   LIKE bmb_file.bmb01,
        p_acode  LIKE bmb_file.bmb29,   #FUN-550093
        l_i,l_k  LIKE type_file.num5,   #No.FUN-680096 SMALLINT
        l_cnt    LIKE type_file.num5,   #No.FUN-680096 SMALLINT
        l_bma01  LIKE bma_file.bma01,
    	g_bmb2 DYNAMIC ARRAY OF RECORD	
    		          bma01   LIKE bma_file.bma01,      #主件
         		  bmb13   LIKE bmb_file.bmb13,      #插件位置
	        	  bmb03   LIKE bmb_file.bmb03,      #元件
	        	  ima02   LIKE ima_file.ima02,      #品名
	        	  ima021  LIKE ima_file.ima021,     #規格
                          bmb06   LIKE bmb_file.bmb06       #QPA    #FUN-560227
		END RECORD
DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0015
DEFINE p_qpa          LIKE bmb_file.bmb06  #TQC-970046  
  
    LET l_cnt = 1
        LET l_sql =
              " SELECT bma01,bmt06,bmb03,ima02,ima021,bmt07 ",
              " FROM  bmb_file,OUTER bma_file,OUTER bmt_file,OUTER ima_file ",
              "    WHERE bmb_file.bmb03 = bma_file.bma01 ",
              "     AND  bmt_file.bmt01 = bmb_file.bmb01 ",
              "     AND bmt_file.bmt03 = bmb_file.bmb03 ",
              "     AND  ima_file.ima01 = bmb_file.bmb03 ", #BugNo:6584
              "     AND  bmb01 ='",p_item,"'",
              "     AND  bmb29 = bma_file.bma06 ", #FUN-550093  #MOD-920245 modify
              "     AND  bmb29 ='",p_acode,"'",  #FUN-550093
              "     AND  bmt_file.bmt02 = bmb_file.bmb02 ",  #MOD-CA0115 add
              "     AND ",tm.wc clipped
 
 
    IF tm.vdate IS NOT NULL THEN 
       LET l_sql = l_sql clipped, 
                 " AND (bmb04 <='",tm.vdate,"'"," OR bmb04 IS NULL )",
                 " AND (bmb05 > '",tm.vdate,"'"," OR bmb05 IS NULL ) "
    END IF
    LET l_sql = l_sql clipped," ORDER BY 2,3 " 
 
	PREPARE q617_pb2 FROM l_sql
	DECLARE q617_bcs2     #CURSOR
		CURSOR FOR q617_pb2
 
   FOREACH q617_bcs2 INTO g_bmb2[l_cnt].*
        IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
        END IF
        IF g_bmb2[l_cnt].bmb13 IS NULL THEN 
           LET g_bmb2[l_cnt].bmb13 = " "
        END IF
        #FUN-8B0015--BEGIN--                                                                                                     
        LET l_ima910[l_cnt]=''
        SELECT ima910 INTO l_ima910[l_cnt] FROM ima_file WHERE ima01=g_bmb2[l_cnt].bmb03 
        IF cl_null(l_ima910[l_cnt]) THEN LET l_ima910[l_cnt]=' ' END IF
        #FUN-8B0015--END--
        LET g_bmb2[l_cnt].bmb06 = g_bmb2[l_cnt].bmb06 * p_qpa * tm.num  #TQC-970046 add   
        LET l_cnt = l_cnt +1 
   END FOREACH 
   FOR l_k = 1 TO  l_cnt -1       
     IF g_bmb2[l_k].bma01 IS NOT NULL THEN         #若為主件(有BOM單頭)
       #CALL q617_bom(p_loc,g_bmb2[l_k].bmb03,' ') #FUN-550093 #FUN-8B0015 
       # CALL q617_bom(p_loc,g_bmb2[l_k].bmb03,l_ima910[l_k]) #FUN-8B0015   #TQC-970046 mark                                      
       CALL q617_bom(p_loc,g_bmb2[l_k].bmb03,l_ima910[l_k],g_bmb2[l_k].bmb06) #TQC-970046 add bmb06 
     ELSE 
        IF g_bmb2[l_k].bmb13 IS NULL THEN LET g_bmb2[l_k].bmb13 = ' ' END IF
        IF p_loc = 1 THEN 
           INSERT INTO q617_file VALUES(g_bmb2[l_k].bmb13,
                                        g_bmb2[l_k].bmb03,
                                        g_bmb2[l_k].ima02,
                                        g_bmb2[l_k].ima021,
                                        g_bmb2[l_k].bmb06,
                                        0)
           IF SQLCA.sqlcode THEN 
              UPDATE q617_file SET bmb06_1 = bmb06_1 + g_bmb2[l_k].bmb06
                             WHERE bmt06 = g_bmb2[l_k].bmb13
                               AND bmb03 = g_bmb2[l_k].bmb03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0
              THEN 
 #             CALL cl_err('ckp#1',SQLCA.sqlcode,1) #No.TQC-660046
              CALL cl_err3("upd","q617_file",g_bmb2[l_k].bmb13,g_bmb2[l_k].bmb03,SQLCA.sqlcode,"","ckp#1",1)  # No.TQC-660046
            
                   CONTINUE FOR 
              END IF
           END IF
        ELSE 
           INSERT INTO q617_file VALUES(g_bmb2[l_k].bmb13,
                                        g_bmb2[l_k].bmb03,
                                        g_bmb2[l_k].ima02,
                                        g_bmb2[l_k].ima021,
                                        0,  
                                        g_bmb2[l_k].bmb06)
           IF SQLCA.sqlcode THEN
              UPDATE q617_file SET bmb06_2 = bmb06_2 + g_bmb2[l_k].bmb06
                             WHERE bmt06 = g_bmb2[l_k].bmb13
                               AND bmb03 = g_bmb2[l_k].bmb03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0
              THEN 
#              CALL cl_err('ckp#2',SQLCA.sqlcode,1) #No.TQC-660046
               CALL cl_err3("upd","q617_file",g_bmb2[l_k].bmb13,g_bmb2[l_k].bmb03,SQLCA.sqlcode,"","ckp#2",1)  # No.TQC-660046
                   CONTINUE FOR 
              END IF
           END IF
        END IF
  	END IF
  END FOR
END FUNCTION
   
FUNCTION q617_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bmb TO s_bmb.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         #LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
   
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q617_temp()
#No.FUN-680096-------------begin----------------
CREATE TEMP TABLE q617_file(
       bmt06    LIKE bmt_file.bmt06,
       bmb03    LIKE bmb_file.bmb03,
       ima02    LIKE ima_file.ima02,
       ima021   LIKE ima_file.ima021,
       bmb06_1  LIKE bmb_file.bmb06,
       bmb06_2  LIKE bmb_file.bmb06)
   ;
#No.FUN-680096----------------end-----------------
   CREATE UNIQUE INDEX q617_01 ON q617_file(bmt06,bmb03);
END FUNCTION 
FUNCTION q617_ima01(p_ima01,p_code)
  DEFINE p_ima01  LIKE ima_file.ima01,
         p_code   LIKE type_file.chr1,    #No.FUN-680096  VARCHAR(1)
         l_ima02  LIKE ima_file.ima02,
         l_ima021 LIKE ima_file.ima021
         SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
          WHERE ima01 = p_ima01
     CASE p_code 
          WHEN "1" 
                  DISPLAY l_ima02,l_ima021 TO FORMONLY.ima02_1,FORMONLY.ima021_1
          WHEN "2" 
                  DISPLAY l_ima02,l_ima021 TO FORMONLY.ima02_2,FORMONLY.ima021_2
     END CASE
     
END FUNCTION 
