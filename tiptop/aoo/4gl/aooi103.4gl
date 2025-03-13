# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Descriptions...: 料件單位換算資料維護作業(aooi103)
# Date & Author..: 91/08/10 By Nora
# Date & Author..: 91/09/30 By May  反向單位資料
# Modify.........: 92/05/06 By David Wang
#----------------------------deBUG History------------------------------
# 1992/09/25(Lee):在輸入單身時, 無法按ESC 結束. 單身原輸入時, 在甲單
#    位地方判斷一定要輸入值後, 方可結束該欄位的其餘動作, 造成esc 鍵無
#    效, 故將該判斷改成在after field smd02時判斷若非null, 則為相關的
#    判斷, 在before field smd03時, 先判斷該smd02是否為null, 若null則
#    不允許進入該欄位即可.
# 1992/09/25(Lee): 在單身輸入後, 程式會自動增加一筆反相的資料, 但會將
#    資料insert到第三個line中, 而留第二個line再輸入其他值, 造成困擾.
#    程式原先在insert反相的資料後, 只單純的將資料顯示在第三行, 造成上
#    述現象. 改進的方式為: 在insert該筆資料後, 重填array, exit input
#    再重進input array, 如此便可
# genero  script marked # 1992/09/25(Lee): 在單身按arrow key移動時, arrow的欄位reverse. 原因是
#    雖然在相對的地方有做清除, 但有. 已拿掉該attribute
# Modify..........: No.MOD-490217 04/09/10 by yiting 料號欄位放大
#-----------------------------------------------------------------------
# Modify.........: No.MOD-490344 04/09/21 By Kitty Controlp 未加display
# Modify.........: No.MOD-470515 04/10/06 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0020 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510027 05/02/14 By pengu 報表轉XML
# Modify.........: No.MOD-530850 05/03/31 By Will 增加料件的開窗
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-5C0086 06/01/05 By Sarah 如aimi100依asms290設定動態DISPLAY單位管制方式,第二單位
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0015 06/10/25 By jamie FUNCTION _fetch() 一開始應清空key值
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/14 By bnlent 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0072 06/11/15 By Ray 查詢時光標順序有誤，料件編號后直接跳到版本再跳到來源碼、品名、分群碼
# Modify.........: No.TQC-710032 07/01/15 By Smapmin 雙單位畫面調整
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760083 07/07/09 By mike 報表格式修改為crystal reports
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-8C0130 09/01/09 By claire 銷售單位顯示
# Modify.........: No.FUN-870100 09/07/02 By lala  add smdpos
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A30030 10/03/15 By Cockroach err_msg:aim-944-->art-648
# Modify.........: No.FUN-AA0059 10/10/28 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.TQC-B30004 11/03/10 By suncx delete smdpos` 
# Modify.........: No:FUN-B50042 11/05/10 by jason 已傳POS否狀態調整
# Modify.........: No:TQC-B90002 11/09/02 by suncx 單身新增最近修改日期
# Modify.........: No:FUN-B90104 11/10/17 by huangrh 服飾開發：子料件不可修改，母料件需要把smd資料更新到子料件中
# Modify.........: No:FUN-BB0086 12/01/29 By tanxc 增加數量欄位小數取位
# Modify.........: No:CHI-BB0048 12/02/07 by jt_chen 刪除時增加寫入azo_file紀錄異動
# Modify.........: No:TQC-C20183 12/02/21 By fengrui 數量欄位小數取位處理
# Modify.........: No:MOD-C30093 12/03/09 By zhuhao 新增時smddate最近修改日期值為空 
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
	g_ima		RECORD LIKE ima_file.*,	#料件基本資料(假單頭)
	g_ima_t		RECORD LIKE ima_file.*,	#料件基本資料(舊值)
	g_ima01_t	LIKE ima_file.ima01,	#料件單號(舊值)
        #g_smd		DYNAMIC ARRAY OF RECORD	#程式變數(Program Variables)
        g_smd           DYNAMIC ARRAY OF RECORD	#程式變數(Program Variables)
		smd04		LIKE smd_file.smd04,	#甲單位數量
		smd02		LIKE smd_file.smd02,	#甲單位
		smd06		LIKE smd_file.smd06,	#乙單位數量
		smd03		LIKE smd_file.smd03,	#乙單位
		smdacti		LIKE smd_file.smdacti,	#資料有效碼
		smdpos 		LIKE smd_file.smdpos,   #FUN-870100
                smddate         LIKE smd_file.smddate   #最近修改日期 #TQC-B90002
		END RECORD,
	g_smd_t		RECORD			#程式變數 (舊值)
		smd04		LIKE smd_file.smd04,	#甲單位數量
		smd02		LIKE smd_file.smd02,	#甲單位
		smd06		LIKE smd_file.smd06,	#乙單位數量
		smd03		LIKE smd_file.smd03,	#乙單位
		smdacti		LIKE smd_file.smdacti,	#資料有效碼
		smdpos 		LIKE smd_file.smdpos,   #FUN-870100
                smddate         LIKE smd_file.smddate   #最近修改日期 #TQC-B90002
		END RECORD,
	g_smd_tm	RECORD		#程式變數 (舊值)
		smd04		LIKE smd_file.smd04,	#甲單位數量
		smd02		LIKE smd_file.smd02,	#甲單位
		smd06		LIKE smd_file.smd06,	#乙單位數量
		smd03		LIKE smd_file.smd03,	#乙單位
		smdacti		LIKE smd_file.smdacti,	#資料有效碼
		smdpos 		LIKE smd_file.smdpos,   #FUN-870100
                smddate         LIKE smd_file.smddate   #最近修改日期 #TQC-B90002
		END RECORD,
#	g_wc,g_wc2,g_sql VARCHAR(300),  #NO.TQC-630166 MARK   
	g_wc,g_wc2,g_sql STRING,  #NO.TQC-630166       
 	g_argv1		LIKE ima_file.ima01,    #No.MOD-490217
	g_rec_b		LIKE type_file.num5,  		#單身筆數        #No.FUN-680102 SMALLINT
	i		LIKE type_file.num5,  		#單身筆數        #No.FUN-680102 SMALLINT
	l_ac		LIKE type_file.num5   		#目前處理的ARRAY CNT        #No.FUN-680102 SMALLINT
DEFINE  g_cnt           LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE  g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680102 SMALLINT
DEFINE  g_msg           LIKE type_file.chr1000       #No.FUN-680102CHAR(72)
DEFINE  g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL   
DEFINE  g_row_count     LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE  g_curs_index    LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE  g_jump          LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE  mi_no_ask       LIKE type_file.num5          #No.FUN-680102 SMALLINT
DEFINE  l_table         STRING                       #No.FUN-760083
DEFINE  g_str           STRING                       #No.FUN-760083
DEFINE g_smd02_t        LIKE smd_file.smd02          #No.FUN-BB0086
DEFINE g_smd03_t        LIKE smd_file.smd03          #No.FUN-BB0086

MAIN
#     DEFINEl_time LIKE type_file.chr8		    #No.FUN-6A0081
DEFINE p_row,p_col      LIKE type_file.num5          #No.FUN-680102 SMALLINT
	OPTIONS					#改變一些系統預設值
  INPUT NO WRAP
	DEFER INTERRUPT				#擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_argv1=ARG_VAL(1)
 
   CALL  cl_used(g_prog,g_time,1)	#計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
 
#No.FUN-760083  --BEGIN--
   LET g_sql="smd01.smd_file.smd01,",
             "smd02.smd_file.smd02,",
             "smd03.smd_file.smd03,",
             "smd04.smd_file.smd04,",
             "smd06.smd_file.smd06,",
             "smd05.smd_file.smd05,",
             "smdacti.smd_file.smdacti,",
             "ima02.ima_file.ima02"
   LET l_table=cl_prt_temptable("aooi103",g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
     CALL cl_err("insert_prep:",status,1)
   END IF   
#No.FUN-760083  --END--
 
   LET p_row = 4 LET p_col = 26
   OPEN WINDOW i103_w AT p_row,p_col		#顯示畫面
     WITH FORM "aoo/42f/aooi103"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#NO.FUN-870100 -----start-----
    IF g_aza.aza88 = 'N' THEN
       CALL cl_set_comp_visible('smdpos',FALSE)
    END IF
#No.FUN-870100---end---
 
 
   #-----TQC-710032---------
   CALL i103_mu_ui()
   ##start FUN-5C0086
   # CALL cl_set_comp_visible("ima906",g_sma.sma115 = 'Y')
   # CALL cl_set_comp_visible("group043",g_sma.sma115 = 'Y')
   # CALL cl_set_comp_visible("ima907",g_sma.sma115 = 'Y')
   # CALL cl_set_comp_visible("group044",g_sma.sma115='Y')
   # IF g_sma.sma122='1' THEN
   #    CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
   #    CALL cl_set_comp_att_text("ima907",g_msg CLIPPED)
   # END IF
   # IF g_sma.sma122='2' THEN
   #    CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
   #    CALL cl_set_comp_att_text("ima907",g_msg CLIPPED)
   # END IF
   ##end FUN-5C0086
   #-----END TQC-710032-----
    CALL cl_set_comp_visible('smdpos',FALSE)  #TQC-B30004 add
 
    LET g_forupd_sql = "SELECT * FROM ima_file  WHERE ima01 =? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i103_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    IF NOT cl_null(g_argv1) THEN CALL i103_q() END IF
 
    CALL i103_menu()
 
   CLOSE WINDOW i103_w			#結束畫面
     CALL  cl_used(g_prog,g_time,2)	#計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN
 
#QBE 查詢資料
FUNCTION i103_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
    IF cl_null(g_argv1) THEN
       CLEAR FORM                             #清除畫面
       CALL g_smd.clear()
       CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_ima.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON              # 螢幕上取單頭條件
#                ima01,ima05,ima08,ima02,ima06,ima25,ima44,ima63,ima55   #No.TQC-6B0072
                 ima01,ima02,ima08,ima06,ima05,ima25,ima44,ima63,ima55   #No.TQC-6B0072
                ,ima906,ima907,ima31   #FUN-5C0086  #FUN-8C0130 add ima31
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
               WHEN INFIELD(ima01)
#FUN-AA0059 --Begin--
              #  CALL cl_init_qry_var()
              #  LET g_qryparam.form = "q_ima"
              #  LET g_qryparam.state = "c"
              #  LET g_qryparam.default1 = g_ima.ima01
              #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima( TRUE, "q_ima","",g_ima.ima01,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                 DISPLAY g_qryparam.multiret TO ima01
                 NEXT FIELD ima01
              OTHERWISE
                 EXIT CASE
            END CASE
           #--
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
 
          ON ACTION controlg      #MOD-4C0121
             CALL cl_cmdask()     #MOD-4C0121
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
       END CONSTRUCT
       IF INT_FLAG THEN
          RETURN
       END IF
 
      #CONSTRUCT g_wc2 ON smd02,smd03 FROM s_smd[1].smd02,s_smd[1].smd03             #FUN-870100 MARK
      #CONSTRUCT g_wc2 ON smd02,smd03 FROM s_smd[1].smd02,s_smd[1].smd03             #FUN-870100 add #FUN-B50042 remove POS
       CONSTRUCT g_wc2 ON smd02,smd03,smddate                               #TQC-B90002 add smddate
            FROM s_smd[1].smd02,s_smd[1].smd03,s_smd[1].smddate             #FUN-870100 add #FUN-B50042 remove POS  #TQC-B90002 add smddate
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
          ON ACTION controlp
             CASE
                WHEN INFIELD(smd02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gfe"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO smd02
                   NEXT FIELD smd02
                WHEN INFIELD(smd03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gfe"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO smd03
                   NEXT FIELD smd03
                OTHERWISE EXIT CASE
             END CASE
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
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
       END CONSTRUCT
       IF INT_FLAG THEN
          RETURN
       END IF
    ELSE
       LET g_wc=" ima01='",g_argv1,"'"
       LET g_wc2=' 1=1'
    END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #       LET g_wc = g_wc clipped," AND imauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #       LET g_wc = g_wc clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #       LET g_wc = g_wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
    #End:FUN-980030
 
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT  ima01 FROM ima_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY ima01"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE ima_file. ima01 ",
                   "  FROM ima_file, smd_file ",
                   " WHERE ima01 = smd01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY ima01"
    END IF
 
    PREPARE i103_prepare FROM g_sql
    DECLARE i103_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i103_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM ima_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT ima01)",
                  " FROM ima_file,smd_file WHERE ",
                  "smd01=ima01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i103_precount FROM g_sql
    DECLARE i103_count CURSOR FOR i103_precount
END FUNCTION
 
FUNCTION i103_menu()
 
   WHILE TRUE
      CALL i103_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i103_q()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i103_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i103_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL i103_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_ima.ima01 IS NOT NULL THEN
                  LET g_doc.column1 = "ima01"
                  LET g_doc.value1 = g_ima.ima01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_smd),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION i103_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i103_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    OPEN i103_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_ima.* TO NULL
    ELSE
       OPEN i103_count
       FETCH i103_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL i103_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i103_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680102 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680102 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i103_cs INTO g_ima.ima01
        WHEN 'P' FETCH PREVIOUS i103_cs INTO g_ima.ima01
        WHEN 'F' FETCH FIRST    i103_cs INTO g_ima.ima01
        WHEN 'L' FETCH LAST     i103_cs INTO g_ima.ima01
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
            FETCH ABSOLUTE g_jump i103_cs INTO g_ima.ima01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
       INITIALIZE g_ima.* TO NULL              #No.FUN-6A0015
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
    SELECT * INTO g_ima.* FROM ima_file WHERE ima01 = g_ima.ima01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)   #No.FUN-660131
       CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
       INITIALIZE g_ima.* TO NULL
       RETURN
    END IF
 
    CALL i103_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i103_show()
   LET g_ima_t.* = g_ima.*                #保存單頭舊值
   DISPLAY BY NAME                              # 顯示單頭值
       g_ima.ima01,g_ima.ima05,g_ima.ima08,g_ima.ima02,g_ima.ima06,
       g_ima.ima25,g_ima.ima44,g_ima.ima63,g_ima.ima55
      ,g_ima.ima906,g_ima.ima907,g_ima.ima31   #FUN-5C0086  #FUN-8C0130 add ima31
   CALL i103_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i103_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680102 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680102 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680102 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680102 VARCHAR(1)
   acti_tm         LIKE type_file.chr1,           #No.FUN-680102   VARCHAR(01),             #
   l_sw            LIKE type_file.chr1,           #No.FUN-680102    VARCHAR(01),            #可更改否 (含取消)
   sw              LIKE type_file.chr1,           #No.FUN-680102    VARCHAR(01),            #可更改否 (含取消)
   l_allow_insert  LIKE type_file.chr1,           #No.FUN-680102     VARCHAR(01),           #可新增否
   l_allow_delete  LIKE type_file.chr1,           #No.FUN-680102    VARCHAR(01)           #可刪除否
   l_azo06         LIKE azo_file.azo06,           #No.CHI-BB0048
   l_azo05         LIKE azo_file.azo05            #No.CHI-BB0048
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF g_ima.ima01 IS NULL
      THEN RETURN
   END IF
   SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_ima.ima01
   IF g_ima.imaacti ='N'
      THEN CALL cl_err(g_ima.ima01,'mfg1000',0)     #檢查資料是否為無效
      RETURN
   END IF

#FUN-B90104----add--begin---- 服飾行業，子料件不可更改
   IF s_industry('slk') THEN
      IF g_ima.ima151='N' AND g_ima.imaag='@CHILD' THEN
         CALL cl_err(g_ima.ima01,'axm_665',1)
         RETURN
      END IF
   END IF
#FUN-B90104----add--end---
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
   LET g_action_choice = ""
 
   CALL cl_opmsg('b')
 
  #LET g_forupd_sql = "SELECT smd04,smd02,smd06,smd03,smdacti,smdpos",   #FUN-870100
   LET g_forupd_sql = "SELECT smd04,smd02,smd06,smd03,smdacti,smdpos,smddate",   #TQC-B90002 add smddate
                      "  FROM smd_file  WHERE smd01=? AND smd02=?",
                      "   AND smd03=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i103_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_smd WITHOUT DEFAULTS FROM s_smd.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         #No.FUN-BB0086--add--begin--
         LET g_smd02_t = NULL   
         LET g_smd03_t = NULL
         #No.FUN-BB0086--add--end--
 
      BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
          BEGIN WORK
          OPEN i103_cl USING g_ima.ima01
          IF SQLCA.sqlcode
             THEN CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
             CLOSE i103_cl
             ROLLBACK WORK
             RETURN
          ELSE
             FETCH i103_cl INTO g_ima.*
             IF SQLCA.sqlcode
                THEN CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
                CLOSE i103_cl
                ROLLBACK WORK
                RETURN
              END IF
          END IF
          IF g_rec_b >= l_ac THEN
             LET p_cmd='u'
             LET g_smd_t.* = g_smd[l_ac].*  #BACKUP
             #No.FUN-BB0086--add--begin--
             LET g_smd02_t = g_smd[l_ac].smd02
             LET g_smd03_t = g_smd[l_ac].smd03
             #No.FUN-BB0086--add--end--
             OPEN i103_bcl USING g_ima.ima01,g_smd_t.smd02,g_smd_t.smd03               #表示更改狀態
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_smd_t.smd02,SQLCA.sqlcode,1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i103_bcl INTO g_smd[l_ac].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_smd_t.smd02,SQLCA.sqlcode,1)
                   LET l_lock_sw="Y"
                END IF
             END IF
             CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_smd[l_ac].* TO NULL      #900423
         LET g_smd[l_ac].smd04=1               #DEFAULT
         LET g_smd[l_ac].smd06=1
         LET g_smd[l_ac].smdacti='Y'
         #LET g_smd[l_ac].smdpos='N'           #FUN-870100 #FUN-B50042 mark 
         #DISPLAY BY NAME g_smd[l_ac].smdpos   #FUN-870100 #FUN-B50042 mark
         LET g_smd[l_ac].smddate=g_today       #TQC-B90002  
         LET g_smd_t.* = g_smd[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD smd04
 
      AFTER INSERT
         IF INT_FLAG THEN                      #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO smd_file (smd01,smd02,smd03,smd04,smd06,smdacti,smddate)      #FUN-870100   #MOD-C30093 add smddate
                       VALUES (g_ima.ima01,g_smd[l_ac].smd02,
                               g_smd[l_ac].smd03,g_smd[l_ac].smd04,
                               g_smd[l_ac].smd06,g_smd[l_ac].smdacti,g_smd[l_ac].smddate)   #FUN-870100 #FUN-B50042 remove POS  ##MOD-C30093 add g_smd[l_ac].smddate
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_smd[l_ac].smd02,SQLCA.sqlcode,0)   #No.FUN-660131
            CALL cl_err3("ins","smd_file",g_smd[l_ac].smd02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD smd02                        #check 甲單位是否重複
         IF NOT cl_null(g_smd[l_ac].smd02) THEN
            IF g_smd[l_ac].smd02 != g_smd_t.smd02 OR g_smd_t.smd02 IS NULL THEN
               SELECT * FROM gfe_file WHERE gfe01 = g_smd[l_ac].smd02
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_smd[l_ac].smd02,'aoo-012',0)   #No.FUN-660131
                  CALL cl_err3("sel","gfe_file",g_smd[l_ac].smd02,"","aoo-012","","",1)  #No.FUN-660131
                  LET g_smd[l_ac].smd02 = g_smd_t.smd02
                  NEXT FIELD smd02
               END IF
            END IF
            #No.FUN-BB0086--add--begin--
            CALL i103_smd04_check()
            LET g_smd02_t = g_smd[l_ac].smd02
            #No.FUN-BB0086--add--end--
         END IF

      #No.FUN-BB0086--add--begin--
      AFTER FIELD smd04
         CALL i103_smd04_check()
      #No.FUN-BB0086--add--end--
 
      AFTER FIELD smd06
         IF NOT i103_smd06_check() THEN NEXT FIELD smd06 END IF   #No.FUN-BB0086
        #No.FUN-BB0086--mark--begin--
        #IF NOT cl_null(g_smd[l_ac].smd06) THEN
        #   IF g_smd[l_ac].smd06 <=0 THEN
        #      NEXT FIELD smd06
        #   END IF
        #END IF
        #No.FUN-BB0086--mark--end--
 
      AFTER FIELD smd03
        IF g_smd_t.smd03 IS NOT NULL THEN
           IF g_smd[l_ac].smd03 IS NULL THEN  #重要欄位空白,無效
              LET g_smd[l_ac].smd03 = g_smd_t.smd03
              NEXT FIELD smd03
           END IF
        END IF
        IF NOT cl_null(g_smd[l_ac].smd03) THEN
           IF g_smd[l_ac].smd03 != g_smd_t.smd03 OR g_smd_t.smd03 IS NULL THEN
              SELECT * FROM gfe_file WHERE gfe01 = g_smd[l_ac].smd03
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_smd[l_ac].smd03,'aoo-012',0)   #No.FUN-660131
                 CALL cl_err3("sel","gfe_file",g_smd[l_ac].smd03,"","aoo-012","","",1)  #No.FUN-660131
                 LET g_smd[l_ac].smd03 = g_smd_t.smd03
                 NEXT FIELD smd03
               END IF
             #檢查資料是否重覆(1992/09/25 Lee)
              SELECT COUNT(*) INTO g_cnt FROM smd_file WHERE smd01=g_ima.ima01
                 AND smd02=g_smd[l_ac].smd02 AND smd03=g_smd[l_ac].smd03
              IF g_cnt>0 THEN
                 CALL cl_err(g_smd[l_ac].smd03,-239,0)
                 LET g_smd[l_ac].smd02 = g_smd_t.smd02
                 LET g_smd[l_ac].smd03 = g_smd_t.smd03
                 NEXT FIELD smd03
              END IF
           END IF
           #No.FUN-BB0086--add--begin--
           IF NOT i103_smd06_check() THEN NEXT FIELD smd03 END IF   
           LET g_smd03_t = g_smd[l_ac].smd03
           #No.FUN-BB0086--add--end--
        END IF
 
      BEFORE DELETE                            #是否取消單身
        IF g_smd_t.smd02 != ' ' AND g_smd_t.smd02 IS NOT NULL THEN
           #TQC-B30004 mark begin-------------------
           ##FUN-870100---begin
           #IF g_aza.aza88='Y' THEN
           #   IF NOT (g_smd[l_ac].smdacti='N' AND g_smd[l_ac].smdpos='Y') THEN
           #     #CALL cl_err("", 'aim-944', 1)     #FUN-A30030 MARK
           #      CALL cl_err("", 'art-648', 1)      #ADD
           #      CANCEL DELETE
           #   END IF
           #END IF
           ##FUN-870100---end
           #TQC-B30004 mark end---------------------
 
           IF NOT cl_delb(0,0) THEN
              CANCEL DELETE
           END IF
           IF l_lock_sw = "Y" THEN
              CALL cl_err("", -263, 1)
              CANCEL DELETE
           END IF
           DELETE FROM smd_file
            WHERE smd01 = g_ima.ima01
              AND smd02 = g_smd[l_ac].smd02
              AND smd03 = g_smd[l_ac].smd03
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_smd_t.smd02,SQLCA.sqlcode,0)   #No.FUN-660131
              CALL cl_err3("del","smd_file",g_smd_t.smd02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              CLOSE i103_bcl
              ROLLBACK WORK
              CANCEL DELETE
           ELSE
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
              MESSAGE "Delete Ok"
              CLOSE i103_bcl
              COMMIT WORK
           END IF
           #CHI-BB0048 -- add start --
           LET g_msg = TIME
           LET l_azo05 = 'smd01:',g_ima.ima01,' smd02:',g_smd[l_ac].smd02,' smd03:',g_smd[l_ac].smd03
           LET l_azo06 = 'delete'
           INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)
             VALUES ('aooi103',g_user,g_today,g_msg,l_azo05,l_azo06,g_plant,g_legal)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","azo_file","aooi103","",SQLCA.sqlcode,"","",1)
              ROLLBACK WORK
              EXIT INPUT
           END IF
           #CHI-BB0048 -- add end --
        END IF

      ON ROW CHANGE
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_smd[l_ac].* = g_smd_t.*
            CLOSE i103_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         #FUN-870100---start
        #FUN-B50042 mark --START--
        #IF g_aza.aza88= 'Y' THEN   #FUN-A30030 ADD
        #   IF g_smd[l_ac].smd02<>g_smd_t.smd02 OR g_smd[l_ac].smd03<>g_smd_t.smd03 OR g_smd[l_ac].smd04<>g_smd_t.smd04
        #      OR g_smd[l_ac].smd06<>g_smd_t.smd06 OR g_smd[l_ac].smdacti<>g_smd_t.smdacti THEN
        #      LET g_smd[l_ac].smdpos = 'N'       
        #      DISPLAY BY NAME g_smd[l_ac].smdpos
        #   END IF
        #END IF
        #FUN-B50042 mark --END--
        #FUN-870100---end
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_smd[l_ac].smd02,-263,1)
            LET g_smd[l_ac].* = g_smd_t.*
         ELSE
            LET g_smd[l_ac].smddate = g_today   #TQC-B90002
            UPDATE smd_file SET smd02=g_smd[l_ac].smd02,
                                smd03=g_smd[l_ac].smd03,
                                smd04=g_smd[l_ac].smd04,
                                smd06=g_smd[l_ac].smd06,
                                smdacti=g_smd[l_ac].smdacti,
                                #smdpos=g_smd[l_ac].smdpos #FUN-870100 #FUN-B50042 mark
                                smddate=g_smd[l_ac].smddate   #TQC-B90002
             WHERE smd01=g_ima.ima01
               AND smd02=g_smd_t.smd02
               AND smd03=g_smd_t.smd03
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_smd[l_ac].smd02,SQLCA.sqlcode,0)   #No.FUN-660131
               CALL cl_err3("upd","smd_file",g_ima.ima01,g_smd_t.smd02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
               LET g_smd[l_ac].* = g_smd_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
          LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac    #FUN-D40030 Mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_smd[l_ac].* = g_smd_t.*
             #FUN-D40030--add--str--
             ELSE
                CALL g_smd.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D40030--add--end--
             END IF
             CLOSE i103_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac    #FUN-D40030 Add
          CLOSE i103_bcl
          COMMIT WORK
 
#     ON ACTION CONTROLN
#         CALL i103_b_askkey()
#         EXIT INPUT
 
#     ON ACTION CONTROLO                        #沿用所有欄位
#         IF INFIELD(smd02) AND l_ac > 1 THEN
#             LET g_smd[l_ac].* = g_smd[l_ac-1].*
#             DISPLAY g_smd[l_ac].* TO s_smd[l_ac].*
#             NEXT FIELD smd02
#         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION create_unit
          CASE
             WHEN  INFIELD(smd02)
                CALL cl_cmdrun("aooi101")
             WHEN  INFIELD(smd03)
                CALL cl_cmdrun("aooi101")
             OTHERWISE EXIT CASE
          END CASE
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(smd02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gfe"
               LET g_qryparam.default1 = g_smd[l_ac].smd02
               CALL cl_create_qry() RETURNING g_smd[l_ac].smd02
#               CALL FGL_DIALOG_SETBUFFER( g_smd[l_ac].smd02 )
                DISPLAY BY NAME g_smd[l_ac].smd02             #No.MOD-490344
               NEXT FIELD smd02
            WHEN INFIELD(smd03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gfe"
               LET g_qryparam.default1 = g_smd[l_ac].smd03
               CALL cl_create_qry() RETURNING g_smd[l_ac].smd03
#               CALL FGL_DIALOG_SETBUFFER( g_smd[l_ac].smd03 )
                DISPLAY BY NAME g_smd[l_ac].smd03             #No.MOD-490344
               NEXT FIELD smd03
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------    
 
   END INPUT
 
   CLOSE i103_bcl
#FUN-B90104----add--begin---- 服飾行業，母料件更改后修改，更新子料件資料
   IF s_industry('slk') THEN
      IF g_ima.ima151='Y' THEN
         CALL i103_ins_smd()
      END IF
   END IF
#FUN-B90104----add--end---
   COMMIT WORK
END FUNCTION

#FUN-B90104----add--begin---- 服飾行業，母料件更改后修改，更新子料件資料
FUNCTION i103_ins_smd()
 DEFINE l_imx000 LIKE imx_file.imx000
 DEFINE l_sql    STRING
 DEFINE l_smd    RECORD LIKE smd_file.*

   DECLARE smd_ins_upd CURSOR FOR SELECT * FROM smd_file WHERE smd01=g_ima.ima01
   DECLARE smd_ins1_upd CURSOR FOR SELECT imx000 FROM imx_file WHERE imx00=g_ima.ima01

   DELETE FROM smd_file WHERE smd01 IN (SELECT imx000 FROM imx_file WHERE imx00=g_ima.ima01)
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","smd_file","","",SQLCA.sqlcode,"","",1)
   END IF

   FOREACH smd_ins_upd INTO l_smd.*
      FOREACH smd_ins1_upd INTO l_imx000
         LET l_smd.smd01=l_imx000
         INSERT INTO smd_file VALUES(l_smd.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","smd_file",l_smd.smd01,"",SQLCA.sqlcode,"","",1)
            CONTINUE FOREACH
         END IF
      END FOREACH

   END FOREACH
    
END FUNCTION
#FUN-B90104----add--end---
 
FUNCTION i103_b_askkey()
DEFINE
    l_wc2    LIKE type_file.chr1000       #No.FUN-680102 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON smd04,smd02,smd06,smd03,smdacti  #FUN-870100
         FROM s_smd[1].smd04,s_smd[1].smd02,s_smd[1].smd06,s_smd[1].smd03,
              s_smd[1].smdacti  #FUN-870100 #FUN-B50042 remove POS
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
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
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    CALL i103_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i103_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680102CHAR(200)
 
    LET g_rec_b = 0
   #LET g_sql = "SELECT smd04,smd02,smd06,smd03,smdacti,smdpos",  #FUN-870100
    LET g_sql = "SELECT smd04,smd02,smd06,smd03,smdacti,smdpos,smddate",  #TQC-B90002
                " FROM smd_file",
                " WHERE smd01 ='",g_ima.ima01,"' AND ",p_wc2 CLIPPED,
                " ORDER BY 1"
    PREPARE i103_pb FROM g_sql
    DECLARE smd_cs                       #SCROLL CURSOR
        CURSOR FOR i103_pb
 
    CALL g_smd.clear()
    LET g_cnt = 1
    FOREACH smd_cs INTO g_smd[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_smd.deleteElement(g_cnt)
    IF SQLCA.sqlcode THEN
       CALL cl_err('foreach:',SQLCA.sqlcode,1)
    END IF
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
 
FUNCTION i103_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_smd TO s_smd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL i103_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i103_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i103_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i103_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i103_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL i103_mu_ui()   #TQC-710032
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------    
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i103_copy()
DEFINE
    l_newno            LIKE ima_file.ima01,
    l_oldno            LIKE ima_file.ima01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ima.ima01 IS NULL
       THEN CALL cl_err('',-400,0)
            RETURN
    END IF
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT l_newno FROM ima01
 
       AFTER FIELD ima01
             IF NOT cl_null(l_newno) THEN
              #FUN-AA0059 ---------------add start----------
               IF NOT s_chk_item_no(l_newno,'') THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD ima01
               END IF
              #FUN-AA0059 -------------add end------------ 
               SELECT count(*) INTO g_cnt FROM ima_file
                WHERE ima01 = l_newno
               IF g_cnt = 0 THEN
                  CALL cl_err(l_newno,'aoo-002',0)
                  NEXT FIELD ima01
               END IF
               SELECT count(*) INTO g_cnt FROM smd_file
                WHERE smd01 = l_newno
               IF g_cnt > 0 THEN
                  CALL cl_getmsg('mfg0003',g_lang) RETURNING g_msg
                  DISPLAY g_msg AT 2,1
                  NEXT FIELD ima01
               END IF
             END IF
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      #MOD-530850
     ON ACTION CONTROLP
        CASE
          WHEN INFIELD(ima01)
#FUN-AA0059 --Begin--
         #  CALL cl_init_qry_var()
         #  LET g_qryparam.form = "q_ima"
         #  LET g_qryparam.default1 = g_ima.ima01
         #  CALL cl_create_qry() RETURNING l_newno
            CALL q_sel_ima(FALSE, "q_ima", "", g_ima.ima01, "", "", "", "" ,"",'' )  RETURNING l_newno   
#FUN-AA0059 --End--
            DISPLAY l_newno TO ima01
            NEXT FIELD ima01
         OTHERWISE
            EXIT CASE
       END CASE
    #--
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END INPUT
    IF INT_FLAG
       THEN LET INT_FLAG = 0
            DISPLAY BY NAME g_ima.ima01
            RETURN
    END IF
    DROP TABLE x
    SELECT * FROM smd_file         #單身複製
        WHERE smd01=g_ima.ima01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)   #No.FUN-660131
       CALL cl_err3("ins","x",g_ima.ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
       RETURN
    END IF
    #UPDATE x SET smd01=l_newno,smdacti='Y'       #有效資料 #FUN-870100 MARK
    #UPDATE x SET smd01=l_newno,smdacti='Y'        #有效資料   #FUN-870100 #FUN-B50042 mark ,smdpos='N'
    UPDATE x SET smd01=l_newno,smdacti='Y',smddate=g_today        #有效資料   #FUN-870100 #FUN-B50042 mark ,smdpos='N'  #TQC-B90002 add smddate=g_today
    INSERT INTO smd_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)   #No.FUN-660131
       CALL cl_err3("ins","smd_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
       RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
    DISPLAY BY NAME g_ima.ima01
    LET l_oldno = g_ima.ima01
    SELECT ima_file.* INTO g_ima.* FROM ima_file WHERE ima01 = l_newno
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)      # 資料被他人LOCK   #No.FUN-660131
       CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
       CLOSE i103_cl
       RETURN
    END IF
    CALL i103_show()
    CALL i103_b()
    #SELECT ima_file.* INTO g_ima.* FROM ima_file WHERE ima01 = l_oldno  #FUN-C80046
    #CALL i103_show()    #FUN-C80046
END FUNCTION
 
FUNCTION i103_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680102 SMALLINT
    sr              RECORD
        smd01       LIKE smd_file.smd01,   #料件單號
        smd02       LIKE smd_file.smd02,   #甲單位
        smd03       LIKE smd_file.smd03,   #甲單位數量
        smd04       LIKE smd_file.smd04,   #乙單位
        smd06       LIKE smd_file.smd06,   #乙單位數量
        smd05       LIKE smd_file.smd05,   #說明
        smdacti     LIKE smd_file.smdacti  #說明
                    END RECORD,
    l_name          LIKE type_file.chr20,               #External(Disk) file name        #No.FUN-680102 VARCHAR(20)
    l_za05          LIKE za_file.za05,                   #No.FUN-680102 VARCHAR(40)
    l_ima02         LIKE ima_file.ima02                 #No.FUN-760083
    IF g_wc IS NULL THEN
    #   CALL cl_err('',-400,0)
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
    CALL cl_del_data(l_table)                           #No.FUN-760083
    LET g_str=''                                        #No.FUN-760083
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog  #No.FUN-760083
#   LET l_name = 'aooi103.out'
    CALL cl_outnam('aooi103') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT smd01,smd02,smd03,",
              "smd04,smd06,smd05,smdacti",
              " FROM smd_file,ima_file",
              " WHERE ima01=smd01 AND ",g_wc CLIPPED,
              " AND ",g_wc2 CLIPPED
    PREPARE i103_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i103_co                         # SCROLL CURSOR
        CURSOR FOR i103_p1
 
    #START REPORT i103_rep TO l_name                        #No.FUN-760083
 
    FOREACH i103_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)    
            EXIT FOREACH
            END IF
        IF sr.smd01 IS NULL THEN LET sr.smd01 = ' ' END IF
        SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=sr.smd01     #No.FUN-760083
        EXECUTE insert_prep USING  sr.*,l_ima02             #No.FUN-760083
        #OUTPUT TO REPORT i103_rep(sr.*)                    #No.FUN-760083
    END FOREACH
 
    #FINISH REPORT i103_rep                                 #No.FUN-760083
 
    CLOSE i103_co
    ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)                        #No.FUN-760083
    LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED      #No.FUN-760083
    IF g_zz05='Y' THEN                                             #No.FUN-760083
       CALL cl_wcchp(g_wc,'ima01,ima02,ima08,ima06,ima05,ima25,ima44,ima63,ima55,   #No.FUN-760083                                              
                           ima906,ima907')                         #No.FUN-760083
       RETURNING g_wc                                              #No.FUN-760083
    END IF                                                         #No.FUN-760083
    LET g_str=g_wc                                                 #No.FUN-760083
    CALL cl_prt_cs3("aooi103","aooi103",g_sql,g_str)               #No.FUN-760083
END FUNCTION
 
#No.FUN-760083 --begin--
{
REPORT i103_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,           #No.FUN-680102 VARCHAR(1),
    l_ima02         LIKE ima_file.ima02,
    l_i             LIKE type_file.num5,          #No.FUN-680102 SMALLINT
    sr              RECORD
        smd01       LIKE smd_file.smd01,   #料件單號
        smd02       LIKE smd_file.smd02,   #甲單位
        smd03       LIKE smd_file.smd03,   #甲單位數量
        smd04       LIKE smd_file.smd04,   #乙單位
        smd06       LIKE smd_file.smd06,   #乙單位數量
        smd05       LIKE smd_file.smd05,   #說明
        smdacti     LIKE smd_file.smdacti  #說明
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line   #No.MOD-580242
 
    ORDER BY sr.smd01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
 
            PRINT g_dash[1,g_len]
            PRINT COLUMN (g_c[34]+(g_w[34]+g_w[35]-FGL_WIDTH(g_x[11]))/2),g_x[11],
                  COLUMN (g_c[36]+(g_w[36]+g_w[37]-FGL_WIDTH(g_x[12]))/2),g_x[12]
            PRINT COLUMN g_c[34],g_dash2[1,(g_w[34]+g_w[35])],
                  COLUMN g_c[36],g_dash2[1,(g_w[36]+g_w[37])]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
                  g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.smd01
            IF sr.smdacti = 'N' OR sr.smdacti = 'n' THEN
               PRINT COLUMN g_c[31],'*';
            ELSE PRINT ' ';
            END IF
            SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=sr.smd01
            PRINT COLUMN g_c[32],sr.smd01,
                  COLUMN g_c[33],l_ima02;
 
        ON EVERY ROW
            PRINT COLUMN g_c[34],sr.smd02,
                  COLUMN g_c[35],cl_numfor(sr.smd04,35,3),
                  COLUMN g_c[36],sr.smd03,
                  COLUMN g_c[37],cl_numfor(sr.smd06,37,3),
                  COLUMN g_c[38],sr.smd05
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
               THEN 
#NO.TQC-630166 start--
#                    IF g_wc[001,080] > ' ' THEN
#		       PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
#                    IF g_wc[071,140] > ' ' THEN
#		       PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
#                    IF g_wc[141,210] > ' ' THEN
#		       PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
                     CALL cl_prt_pos_wc(g_wc)
#NO.TQC-630166 end---
                    PRINT g_dash[1,g_len]
            END IF
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
#No.FUN-760083 --end--
 
#-----TQC-710032---------
FUNCTION i103_mu_ui()
    CALL cl_set_comp_visible("ima906",g_sma.sma115 = 'Y')
    CALL cl_set_comp_visible("group043",g_sma.sma115 = 'Y')
    CALL cl_set_comp_visible("ima907",g_sma.sma115 = 'Y')
    CALL cl_set_comp_visible("group044",g_sma.sma115='Y')
    IF g_sma.sma122='1' THEN
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ima907",g_msg CLIPPED)
    END IF
    IF g_sma.sma122='2' THEN
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ima907",g_msg CLIPPED)
    END IF
END FUNCTION
#-----END TQC-710032-----

#No.FUN-BB0086---add---begin---
FUNCTION i103_smd06_check()
   IF NOT cl_null(g_smd[l_ac].smd06) AND NOT cl_null(g_smd[l_ac].smd03) THEN
      #IF cl_null(g_smd[l_ac].smd06) OR cl_null(g_smd03_t) OR g_smd_t.smd06 != g_smd[l_ac].smd06 OR g_smd03_t != g_smd[l_ac].smd03 THEN    #TQC-C20183
      IF cl_null(g_smd_t.smd06) OR cl_null(g_smd03_t) OR g_smd_t.smd06 != g_smd[l_ac].smd06 OR g_smd03_t != g_smd[l_ac].smd03 THEN         #TQC-C20183
         LET g_smd[l_ac].smd06=s_digqty(g_smd[l_ac].smd06,g_smd[l_ac].smd03)
         DISPLAY BY NAME g_smd[l_ac].smd06
      END IF
   END IF
   IF NOT cl_null(g_smd[l_ac].smd06) THEN
      IF g_smd[l_ac].smd06 <=0 THEN
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION i103_smd04_check()
   IF NOT cl_null(g_smd[l_ac].smd04) AND NOT cl_null(g_smd[l_ac].smd02) THEN
      #IF cl_null(g_smd[l_ac].smd04) OR cl_null(g_smd02_t) OR g_smd_t.smd04 != g_smd[l_ac].smd04 OR g_smd02_t != g_smd[l_ac].smd02 THEN   #TQC-C20183
      IF cl_null(g_smd_t.smd04) OR cl_null(g_smd02_t) OR g_smd_t.smd04 != g_smd[l_ac].smd04 OR g_smd02_t != g_smd[l_ac].smd02 THEN        #TQC-C20183
         LET g_smd[l_ac].smd04=s_digqty(g_smd[l_ac].smd04,g_smd[l_ac].smd02)
         DISPLAY BY NAME g_smd[l_ac].smd04
      END IF
   END IF
END FUNCTION
#No.FUN-BB0086---add---end---
