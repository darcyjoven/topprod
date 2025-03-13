# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abmi104.4gl
# Descriptions...: E-BOM取替代料件資料維護
# Date & Author..: 98/03/26  By HJC
# Modify.........: 99/12/31  By Kammy
# Modify.........: No.MOD-470051 04/07/20 By Mandy 加入相關文件功能
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No:BUG-530356 05/03/28 By kim MOD-530356 主件版本可以輸入一個不存在的版本
# Modify.........: NO.FUN-590002 05/12/19 By Monster radio type 應都要給預設值
# Modify.........: NO.TQC-630105 06/03/13 By Joe 單身筆數限制
# Modify.........: NO.TQC-660046 06/06/12 By xumin cl_err TO cl_err3
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690022 06/09/14 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0002 06/10/19 By jamie FUNCTION i104_q() 一開始應清空key值
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/13 By hellen 新增單頭折疊功能
# Modify.........: NO.CHI-710035 07/02/14 By jamie 取消複製功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-750041 07/05/16 By mike 報表格式修改
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770112 07/07/23 By pengu 查詢時若主件欄位有下條件時，其查詢出資料會異常
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.MOD-8B0114 08/11/12 By Sarah i104_bcs不用抓ROWID,i104_count改用FOREACH一筆一筆加總算筆數
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/22 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/25 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-AB0025 10/11/05 By vealxu 拿掉FUN-AA0059 料號管控，測試料件無需判斷
# Modify.........: No.FUN-AB0025 10/11/05 By lixh1 拿掉FUN-AA0059系統料號的開窗控管
# Modify.........: No.FUN-ABOO25 10/11/11 By lixh1 还原FUN-AA0059 系統開窗管控
# Modify.........: No.FUN-B50062 11/05/16 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:MOD-BC0119 11/12/12 By johung 由abmi100串連執行程式應default bed02的值
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_bed01         LIKE bed_file.bed01,
    g_bed011        LIKE bed_file.bed011,
    g_bed012        LIKE bed_file.bed012,
    g_bed02         LIKE bed_file.bed02,
    g_bed01_t       LIKE bed_file.bed01,
    g_bed011_t      LIKE bed_file.bed011,
    g_bed012_t      LIKE bed_file.bed012,
    g_bed02_t       LIKE bed_file.bed02,
    g_bed           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        bed03       LIKE bed_file.bed03,   #行序
        bed04       LIKE bed_file.bed04,   #舊料料號
        ima02_b     LIKE ima_file.ima02,   #No.FUN-680096 VARCHAR(30)
        ima021_b    LIKE ima_file.ima02,   #No.FUN-680096 VARCHAR(30)
        bed05       LIKE bed_file.bed05,   #Date
        bed06       LIKE bed_file.bed06,   #Date
        bed09       LIKE bed_file.bed09,   #Date
        bed07       LIKE bed_file.bed07    #QPA
                    END RECORD,
    g_bed_t         RECORD                 #程式變數 (舊值)
        bed03       LIKE bed_file.bed03,   #行序
        bed04       LIKE bed_file.bed04,   #舊料料號
        ima02_b     LIKE ima_file.ima02,   #No.FUN-680096 VARCHAR(30) 
        ima021_b    LIKE ima_file.ima02,   #No.FUN-680096 VARCHAR(30) 
        bed05       LIKE bed_file.bed05,   #Date
        bed06       LIKE bed_file.bed06,   #Date
        bed09       LIKE bed_file.bed09,   #Date
        bed07       LIKE bed_file.bed07    #QPA
                    END RECORD,
    g_bed04_o       LIKE bed_file.bed04,
    g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_delete        LIKE type_file.chr1,   #若刪除資料,則要重新顯示筆數a  #No.FUN-680096 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,   #單身筆數        #No.FUN-680096 SMALLINT
    g_ss            LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
    g_argv1  LIKE bed_file.bed01,
    g_argv21 LIKE bed_file.bed012,
    g_argv3  LIKE bed_file.bed02,   #No.FUN-680096 VARCHAR(1)
    g_argv4  LIKE bed_file.bed011,
    l_ac     LIKE type_file.num5,   #目前處理的ARRAY CNT   #No.FUN-680096 SMALLINT
    l_sl     LIKE type_file.num5    #目前處理的SCREEN LINE #No.FUN-680096 SMALLINT
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680096 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt          LIKE type_file.num10     #No.FUN-680096 INTEGER
DEFINE   g_msg          LIKE ze_file.ze03        #No.FUN-680096 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10     #No.FUN-680096 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10     #No.FUN-680096 INTEGER
DEFINE   g_jump         LIKE type_file.num10     #No.FUN-680096 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5      #No.FUN-680096 SMALLINT
 
MAIN
# DEFINE                                    #No.FUN-6A0060 
#       l_time    LIKE type_file.chr8       #No.FUN-6A0060
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060
    LET g_bed01 = NULL                     #清除鍵值
    LET g_bed011 = NULL                     #清除鍵值
    LET g_bed012 = NULL                     #清除鍵值
    LET g_bed02 = NULL                     #清除鍵值
    LET g_bed01_t = NULL
    LET g_bed011_t = NULL
    LET g_bed012_t = NULL
    LET g_bed02_t = NULL
 
    #取得參數
    LET g_argv1=ARG_VAL(1)      #主件
    IF g_argv1=' ' THEN LET g_argv1='' ELSE LET g_bed01=g_argv1 END IF
    LET g_argv21=ARG_VAL(2)     #項次
    IF g_argv21=' ' THEN LET g_argv21='' ELSE LET g_bed012=g_argv21 END IF
    LET g_argv3=ARG_VAL(3)      #UTE
    IF g_argv3=' ' THEN LET g_argv3='' ELSE LET g_bed02=g_argv3 END IF
    LET g_argv4=ARG_VAL(4)      #verno
    IF g_argv4=' ' THEN LET g_argv4='' ELSE LET g_bed011=g_argv4 END IF
 
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW i104_w AT p_row,p_col             #顯示畫面
        WITH FORM "abm/42f/abmi104"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN CALL i104_q() END IF
    IF NOT cl_null(g_argv1) AND g_row_count = 0  THEN CALL i104_a() END IF #FUN-560027 add
 
    LET g_delete='N'
 
    CALL i104_menu()
    CLOSE WINDOW i104_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060
END MAIN
 
#QBE 查詢資料
FUNCTION i104_cs()
    IF cl_null(g_argv1) THEN
       CLEAR FORM                             #清除畫面
       CALL g_bed.clear()
       CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
       INITIALIZE g_bed01 TO NULL    #No.FUN-750051
       INITIALIZE g_bed011 TO NULL    #No.FUN-750051
       INITIALIZE g_bed012 TO NULL    #No.FUN-750051
       INITIALIZE g_bed02 TO NULL    #No.FUN-750051
       CONSTRUCT g_wc ON bed01,bed011,bed012,
                         bed02,bed03,bed04    #螢幕上取條件
        	FROM bed01,bed011,bed012,
                     bed02,s_bed[1].bed03,s_bed[1].bed04
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bed01)
                    #CALL q_ima(10,3,g_bed01) RETURNING g_bed01
#FUN-AB0025 --Begin--  remark
#FUN-AA0059 --BAEGIN--
                   #  CALL cl_init_qry_var()
                   #  LET g_qryparam.form = "q_ima"
                   #  LET g_qryparam.state = 'c'
                   #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
#FUN-AB0025 --End--  remark
                     DISPLAY g_qryparam.multiret TO bed01
                     NEXT FIELD bed01
                    #no.6542
                 WHEN INFIELD(bed011) #料件主檔
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_bmo1"
                      LET g_qryparam.state = 'c'
                      LET g_qryparam.construct = 'N'
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO bed011
                      NEXT FIELD bed011
                 WHEN INFIELD(bed012) #料件主檔
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_bmp01"
                      LET g_qryparam.state = 'c'
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO bed012
                      NEXT FIELD bed012
                      #no.6542(end)
                 WHEN INFIELD(bed04)
#FUN-AB0025 --Begin--  remark
#FUN-AA0059 --Begin--
                    #  CALL cl_init_qry_var()
                    #  LET g_qryparam.form = "q_ima"
                    #  LET g_qryparam.state = 'c'
                    #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                      CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
#FUN-AB0025 --End--  remark
                      DISPLAY g_qryparam.multiret TO bed04
                      NEXT FIELD bed04
                OTHERWISE
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
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
 
        END CONSTRUCT
        LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    	IF INT_FLAG THEN RETURN END IF
      ELSE
	LET g_wc=" bed01='",g_argv1,"'"
	IF NOT cl_null(g_argv4) THEN
	   LET g_wc=g_wc CLIPPED," AND (bed011='",g_argv4,"' )"
	END IF
	IF NOT cl_null(g_argv21) THEN
	  LET g_wc=g_wc CLIPPED," AND (bed012='",g_argv21,"' )"
	END IF
	IF NOT cl_null(g_argv3) THEN
	   LET g_wc=g_wc CLIPPED," AND bed02='",g_argv3,"'"
	END IF
	IF NOT cl_null(g_argv4) THEN
	   LET g_wc=g_wc CLIPPED," AND bed011='",g_argv4,"'"
	END IF
    END IF
 
   #LET g_sql="SELECT DISTINCT bed01,bed011,bed012,bed02",  #MOD-8B0114 mark
    LET g_sql="SELECT DISTINCT bed01,bed011,bed012,bed02",        #MOD-8B0114
              " FROM bed_file ",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY bed01,bed011,bed012,bed02"
    PREPARE i104_prepare FROM g_sql      #預備一下
    IF STATUS THEN CALL cl_err('prep:',STATUS,1) END IF
    DECLARE i104_bcs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i104_prepare
   #-----------No.TQC-770112 modify
   #LET g_sql="SELECT COUNT(DISTINCT bed01) ",
   #          "  FROM bed_file WHERE ", g_wc CLIPPED
    LET g_sql="SELECT DISTINCT bed01,bed011,bed012,bed02 ",
              "  FROM bed_file WHERE ", g_wc CLIPPED
   #-----------No.TQC-770112 end
    PREPARE i104_precount FROM g_sql
    DECLARE i104_count CURSOR FOR i104_precount
END FUNCTION
 
FUNCTION i104_menu()
 
   WHILE TRUE
      CALL i104_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i104_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i104_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i104_r()
            END IF
#        WHEN "reproduce"
#           IF cl_chk_act_auth() THEN
#              CALL i104_copy()
#           END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i104_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"                  #MOD-470051
            IF cl_chk_act_auth() THEN
               IF g_bed01 IS NOT NULL THEN
                  LET g_doc.column1 = "bed01"
                  LET g_doc.value1  = g_bed01
                  LET g_doc.column2 = "bed011"
                  LET g_doc.value2  = g_bed011
                  LET g_doc.column3 = "bed012"
                  LET g_doc.value3  = g_bed012
                  LET g_doc.column4 = "bed02"
                  LET g_doc.value4  = g_bed02
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bed),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
 
#Add  輸入
FUNCTION i104_a()
 DEFINE  l_bmp03      LIKE bmp_file.bmp03
 DEFINE  l_bmp10      LIKE bmp_file.bmp10
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    MESSAGE ""
    CLEAR FORM
    CALL g_bed.clear()
    INITIALIZE g_bed01 LIKE bed_file.bed01
    INITIALIZE g_bed011 LIKE bed_file.bed011
    INITIALIZE g_bed012 LIKE bed_file.bed012
    INITIALIZE g_bed02 LIKE bed_file.bed02
    IF NOT cl_null(g_argv1) THEN LET g_bed01=g_argv1
    DISPLAY g_bed01 TO bed01 END IF
    IF NOT cl_null(g_argv4) THEN LET g_bed011=g_argv4
    DISPLAY g_bed011 TO bed011 END IF
    IF NOT cl_null(g_argv21) THEN LET g_bed012=g_argv21
    DISPLAY g_bed012 TO bed012 END IF
    IF NOT cl_null(g_argv3) THEN LET g_bed02=g_argv3
    DISPLAY g_bed02 TO bed02 END IF
    IF NOT cl_null(g_argv3) THEN
       SELECT UNIQUE bmp03,bmp10 INTO l_bmp03,l_bmp10 FROM bmp_file #FUN-560027 add UNIQUE
        WHERE bmp01=g_bed01 AND bmp011=g_bed011
          AND bmp02=g_bed012
       IF NOT cl_null(l_bmp03) THEN
          DISPLAY l_bmp03 TO FORMONLY.bmp03
          DISPLAY l_bmp10 TO FORMONLY.bmp10
       END IF
    END IF
    LET g_bed01_t = NULL
    LET g_bed011_t = NULL
    LET g_bed012_t = NULL
    LET g_bed02_t = NULL
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
        #NO.590002 START----------
        IF cl_null(g_bed02) THEN   #MOD-BC0119 add
           LET g_bed02 = '1'
        END IF                     #MOD-BC0119 add
        #NO.590002 END------------
        CALL i104_i("a")                   #輸入單頭
	IF INT_FLAG THEN LET INT_FLAG=0 CALL cl_err('',9001,0)EXIT WHILE END IF
        CALL g_bed.clear()
	LET g_rec_b = 0
        DISPLAY g_rec_b TO FORMONLY.cn2
        CALL i104_b()                   #輸入單身
        LET g_bed01_t = g_bed01            #保留舊值
        LET g_bed011_t = g_bed011            #保留舊值
        LET g_bed012_t = g_bed012            #保留舊值
        LET g_bed02_t = g_bed02            #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i104_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_bed01 IS NULL OR g_bed011 IS NULL OR g_bed012 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bed01_t = g_bed01
    LET g_bed011_t = g_bed011
    LET g_bed012_t = g_bed012
    LET g_bed02_t = g_bed02
    WHILE TRUE
        CALL i104_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_bed01=g_bed01_t
            LET g_bed011=g_bed011_t
            LET g_bed012=g_bed012_t
            LET g_bed02=g_bed02_t
            DISPLAY g_bed01 TO bed01      #單頭
            DISPLAY g_bed011 TO bed011      #單頭
            DISPLAY g_bed012 TO bed012      #單頭
            DISPLAY g_bed02 TO bed02      #單頭
 
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_bed01 != g_bed01_t OR g_bed011 != g_bed011_t OR
           g_bed012 != g_bed012_t OR
           g_bed02 != g_bed02_t                         THEN #更改單頭值
            UPDATE bed_file SET bed01 = g_bed01,  #更新DB
		                bed011 = g_bed011,
		                bed012 = g_bed012,
		                bed02 = g_bed02
                WHERE bed01 = g_bed01_t          #COLAUTH?
	          AND bed011 = g_bed011_t
	          AND bed012 = g_bed012_t
	          AND bed02 = g_bed02_t
            IF SQLCA.sqlcode THEN
	        LET g_msg = g_bed01 CLIPPED,' + ', g_bed011 CLIPPED,
                                             ' + ', g_bed012 CLIPPED
            #   CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.TQC-660046
                CALL cl_err3("upd","bed_file",g_msg,"",SQLCA.sqlcode,"","",1)   #No.TQC-660046
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION i104_i(p_cmd)
DEFINE
    p_cmd          LIKE type_file.chr1,       #a:輸入 u:更改        #No.FUN-680096 VARCHAR(1)
    l_bed04        LIKE bed_file.bed04,
    l_bmp03        LIKE bmp_file.bmp03,
    l_bmp10        LIKE bmp_file.bmp10,
    l_ima02        LIKE ima_file.ima02,
    l_ima08        LIKE ima_file.ima08,
    l_ima021       LIKE ima_file.ima021,
    l_i            LIKE type_file.num10       #No.FUN-680096  INTEGER
 
    LET g_ss='Y'
    CALL cl_set_head_visible("","YES")        #No.FUN-6B0033
    DISPLAY BY NAME g_bed01,g_bed011,g_bed012,g_bed02
    INPUT g_bed01, g_bed011, g_bed012,g_bed02 WITHOUT DEFAULTS
     FROM bed01,bed011,bed012,bed02
 
	BEFORE FIELD bed01  # 是否可以修改 key
	    IF g_chkey = 'N' AND p_cmd = 'u' THEN RETURN END IF
 
        AFTER FIELD bed01            #
            IF NOT cl_null(g_bed01) THEN
#FUN-AB0025 -------------mark start----------------
#               #FUN-AA0059 ---------------------------add start---------------------
#               IF NOT s_chk_item_no(g_bed01,'') THEN
#                  CALL cl_err('',g_errno,1)
#                  LET g_bed01 = g_bed01_t
#                  DISPLAY g_bed01 TO bed01
#                  NEXT FIELD bed01
#               END IF 
#               #FUN-AA0059 --------------------------add end----------------------------
#FUN-AB0025 -----------mark end-------------------
                IF g_bed01 != g_bed01_t OR g_bed01_t IS NULL THEN
                    CALL i104_bed01('a')
                    IF NOT cl_null(g_errno) THEN
	            IF g_errno='mfg9116' THEN
                       IF NOT cl_confirm(g_errno)
                          THEN NEXT FIELD bed01
                       END IF
	            ELSE
                       CALL cl_err(g_bed01,g_errno,0)
                       LET g_bed01 = g_bed01_t
                       DISPLAY g_bed01 TO bed01
                       NEXT FIELD bed01
	            END IF
                    END IF
                END IF
            END IF
         #MOD-530356
        AFTER FIELD bed011   #版次
            IF NOT cl_null(g_bed011) THEN
               SELECT count(*) INTO l_i FROM bmo_file
               WHERE bmo01=g_bed01 AND bmo011=g_bed011
               IF SQLCA.sqlcode OR l_i<=0 THEN
                  CALL cl_err('','abm-803',0)
                  NEXT FIELD bed011
               END IF
            END IF
        AFTER FIELD bed012           #項次
	    IF NOT cl_null(g_bed012) THEN
                #檢查是否存在E-BOM中
                SELECT UNIQUE bmp03,bmp10 INTO l_bmp03,l_bmp10 FROM bmp_file #FUN-560027 add UNIQUE
                 WHERE bmp01=g_bed01 AND bmp011=g_bed011
                   AND bmp02=g_bed012
                IF STATUS OR cl_null(l_bmp03) THEN
                #   CALL cl_err('','asf-820',0)  #No.TQC-660046
                    CALL cl_err3("sel","bmp_file",g_bed01,g_bed011,"asf-820","","",1)  #No.TQC-660046
                    NEXT FIELD bed012
                ELSE
                   SELECT ima02,ima021,ima08 INTO l_ima02,l_ima021,l_ima08 FROM ima_file WHERE ima01=l_bmp03
                   IF SQLCA.sqlcode THEN
                       SELECT bmq02,bmq021,bmq08 INTO l_ima02,l_ima021,l_ima08 FROM bmq_file WHERE bmq01=l_bmp03
                   END IF
                   DISPLAY l_bmp03 TO FORMONLY.bmp03
                   DISPLAY l_bmp10 TO FORMONLY.bmp10
                   DISPLAY l_ima02 TO FORMONLY.ima02_2
                   DISPLAY l_ima021 TO FORMONLY.ima021_2
                   DISPLAY l_ima08 TO FORMONLY.ima08_2
                END IF
            END IF
 
        AFTER FIELD bed02            #
	    IF NOT cl_null(g_bed02) THEN
	        IF g_bed02 NOT MATCHES '[12]' THEN
                    NEXT FIELD bed02
                END IF
                SELECT count(*) INTO g_cnt FROM bed_file
                    WHERE bed01 = g_bed01
                      AND bed011 = g_bed011
                      AND bed012 = g_bed012
                      AND bed02 = g_bed02
                IF g_cnt > 0 THEN   #資料重複
	            LET g_msg = g_bed01 CLIPPED,' + ', g_bed011 CLIPPED
	                                        ,' + ', g_bed012 CLIPPED
                    CALL cl_err(g_msg,-239,0)
                    LET g_bed01 = g_bed01_t
                    LET g_bed011 = g_bed011_t
                    LET g_bed012 = g_bed012_t
                    DISPLAY  g_bed01 TO bed01
                    DISPLAY  g_bed011 TO bed011
                    DISPLAY  g_bed012 TO bed012
                    NEXT FIELD bed01
                END IF
            END IF
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bed01)
                    #CALL q_ima(10,3,g_bed01) RETURNING g_bed01
#FUN-AB0025 --Begin--  remark
#FUN-AA0059 --Begin--
                   #  CALL cl_init_qry_var()
                   #  LET g_qryparam.form = "q_ima"
                   #  LET g_qryparam.default1 = g_bed01
                   #  CALL cl_create_qry() RETURNING g_bed01
                     CALL q_sel_ima(FALSE, "q_ima", "", g_bed01, "", "", "", "" ,"",'' )  RETURNING g_bed01
#FUN-AA0059 --End--
#FUN-AB0025 --End--  remark 
                     DISPLAY BY NAME g_bed01
                     CALL i104_bed01('d')
                     NEXT FIELD bed01
                    #no.6542
                 WHEN INFIELD(bed011) #料件主檔
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_bmo1"
                      LET g_qryparam.construct = 'N'
                      LET g_qryparam.default1 = g_bed011
                      IF NOT cl_null(g_bed01) THEN
                         LET g_qryparam.where = "bmo01 = '",g_bed01,"'"
                      END IF
                      CALL cl_create_qry() RETURNING g_bed011
#                      CALL FGL_DIALOG_SETBUFFER(g_bed011)
                       DISPLAY g_bed011 TO bed011            #No.MOD-490371
#                     NEXT FIELD bed011
                 WHEN INFIELD(bed012) #料件主檔
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_bmp01"
                      LET g_qryparam.arg1 = g_bed01
                      LET g_qryparam.arg2 = g_bed011
                      CALL cl_create_qry() RETURNING g_bed012,l_bmp03
                      DISPLAY BY NAME g_bed012
                      DISPLAY l_bmp03 TO FORMONLY.bmp03
                      NEXT FIELD bed012
                      #no.6542(end)
                OTHERWISE
            END CASE
 
        ON ACTION qry_test_item
#                    CALL q_bmq(10,3,g_bed01) RETURNING g_bed01
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_bmq"
                     LET g_qryparam.default1 = g_bed01
                     CALL cl_create_qry() RETURNING g_bed01
                     DISPLAY BY NAME g_bed01
                     CALL i104_bed01('d')
                     NEXT FIELD bed04
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON ACTION controlg       #TQC-860021
           CALL cl_cmdask()      #TQC-860021
 
        ON IDLE g_idle_seconds   #TQC-860021
           CALL cl_on_idle()     #TQC-860021
           CONTINUE INPUT        #TQC-860021
 
        ON ACTION about          #TQC-860021
           CALL cl_about()       #TQC-860021
 
        ON ACTION help           #TQC-860021
           CALL cl_show_help()   #TQC-860021 
    END INPUT
END FUNCTION
 
FUNCTION i104_bed01(p_cmd)  #
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
           l_bmq011  LIKE bmq_file.bmq011,
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima25   LIKE ima_file.ima25,
           l_ima08   LIKE ima_file.ima08,
           l_imaacti LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima25,ima08,imaacti
           INTO l_ima02,l_ima021,l_ima25,l_ima08,l_imaacti
           FROM ima_file WHERE ima01 = g_bed01
    CASE WHEN SQLCA.SQLCODE
              SELECT  bmq011,bmq02,bmq021,bmq25,bmq08,bmqacti
              INTO l_bmq011,l_ima02,l_ima021,l_ima25,l_ima08,l_imaacti
                 FROM bmq_file
                WHERE bmq01 = g_bed01
                  IF SQLCA.sqlcode THEN
                      LET g_errno = 'mfg2602'
                      LET l_ima02 = NULL
                      LET l_ima021= NULL
                      LET l_ima25 = NULL
                      LET l_ima08 = NULL
                      LET l_imaacti = NULL
                  END IF
              IF l_bmq011 IS NOT NULL AND l_bmq011 != ' '
              THEN LET g_errno = 'mfg2764'
              END IF
         WHEN l_imaacti='N' LET g_errno = '9028'
  #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
  #FUN-690022------mod-------
 
         WHEN l_ima08 NOT MATCHES '[PVZS]' LET g_errno = 'mfg9116'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
   #IF cl_null(g_errno) OR p_cmd = 'd'                         #FUN-560027
    IF cl_null(g_errno) OR p_cmd = 'd' OR g_errno = 'mfg9116'  #FUN-560027 add
      THEN DISPLAY l_ima02 TO FORMONLY.ima02
           DISPLAY l_ima021 TO FORMONLY.ima021
           DISPLAY l_ima25 TO FORMONLY.ima25_h
           DISPLAY l_ima08 TO FORMONLY.ima08_h
    END IF
END FUNCTION
 
#Query 查詢
FUNCTION i104_q()
  DEFINE l_bed01  LIKE bed_file.bed01,
         l_bed011 LIKE bed_file.bed011,
         l_bed012 LIKE bed_file.bed012,
         l_bed02  LIKE bed_file.bed02,
         l_cnt    LIKE type_file.num10     #No.FUN-680096 INTEGER
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bed01 TO NULL             #No.FUN-6A0002  
    INITIALIZE g_bed011 TO NULL            #No.FUN-6A0002 
    INITIALIZE g_bed012 TO NULL            #No.FUN-6A0002
    INITIALIZE g_bed02 TO NULL             #No.FUN-6A0002
 
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i104_cs()                    #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_bed01 TO NULL
        INITIALIZE g_bed011 TO NULL
        INITIALIZE g_bed012 TO NULL
        INITIALIZE g_bed02 TO NULL
        RETURN
    END IF
    OPEN i104_bcs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err('open cursor:',SQLCA.sqlcode,0)
        INITIALIZE g_bed01 TO NULL
        INITIALIZE g_bed011 TO NULL
        INITIALIZE g_bed012 TO NULL
        INITIALIZE g_bed02 TO NULL
    ELSE
       #------------No.TQC-770112 modify
       #OPEN i104_count
       #FETCH i104_count INTO g_row_count
        LET g_row_count = 0
        FOREACH i104_count INTO l_bed01,l_bed011,l_bed012,l_bed02
            LET g_row_count = g_row_count + 1
        END FOREACH
       #------------No.TQC-770112 end
        DISPLAY g_row_count TO FORMONLY.cnt
        #FUN-560027 add
        IF NOT cl_null(g_argv1) AND g_row_count = 0 THEN
            RETURN
        END IF
        #FUN-560027(end)
        CALL i104_fetch('F')            #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i104_fetch(p_flag)
DEFINE
    p_flag  LIKE type_file.chr1        #處理方式    #No.FUN-680096 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
     WHEN 'N' FETCH NEXT     i104_bcs INTO g_bed01,g_bed011,g_bed012,g_bed02   #MOD-8B0114 mod #
     WHEN 'P' FETCH PREVIOUS i104_bcs INTO g_bed01,g_bed011,g_bed012,g_bed02   #MOD-8B0114 mod #
     WHEN 'F' FETCH FIRST    i104_bcs INTO g_bed01,g_bed011,g_bed012,g_bed02   #MOD-8B0114 mod #
     WHEN 'L' FETCH LAST     i104_bcs INTO g_bed01,g_bed011,g_bed012,g_bed02   #MOD-8B0114 mod #
     WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                     CONTINUE PROMPT
 
                   ON ACTION about         #MOD-4C0121
                      CALL cl_about()      #MOD-4C0121
 
                   ON ACTION help          #MOD-4C0121
                      CALL cl_show_help()  #MOD-4C0121
 
                   ON ACTION controlg      #MOD-4C0121
                      CALL cl_cmdask()     #MOD-4C0121
                END PROMPT
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump i104_bcs INTO g_bed01,g_bed011,g_bed012,g_bed02   #MOD-8B0114 mod #
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_bed01,SQLCA.sqlcode,0)
       INITIALIZE g_bed01  TO NULL  #TQC-6B0105
       INITIALIZE g_bed011 TO NULL  #TQC-6B0105
       INITIALIZE g_bed012 TO NULL  #TQC-6B0105
       INITIALIZE g_bed02  TO NULL  #TQC-6B0105
    ELSE
      #------No.TQC-770112 modify
      #OPEN i104_count
      #FETCH i104_count INTO g_row_count
      #DISPLAY g_row_count TO FORMONLY.cnt
      #------No.TQC-770112 end
       CALL i104_show()
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i104_show()
   DEFINE l_bmp03 LIKE bmp_file.bmp03
   DEFINE l_bmp10 LIKE bmp_file.bmp10
   DEFINE l_ima02 LIKE ima_file.ima02
   DEFINE l_ima021 LIKE ima_file.ima021
   DEFINE l_ima08 LIKE ima_file.ima08
 
    DISPLAY g_bed01,g_bed011,g_bed012,g_bed02
         TO bed01,bed011,bed012,bed02     #單頭
    CALL i104_bed01('d')
    SELECT UNIQUE bmp03,bmp10 INTO l_bmp03,l_bmp10 FROM bmp_file #FUN-560027 add UNIQUE
     WHERE bmp01=g_bed01 AND bmp011=g_bed011
       AND bmp02=g_bed012
    DISPLAY l_bmp03 TO FORMONLY.bmp03
    DISPLAY l_bmp10 TO FORMONLY.bmp10
    SELECT ima02,ima021,ima08 INTO l_ima02,l_ima021,l_ima08 FROM ima_file
     WHERE ima01=l_bmp03
    IF SQLCA.sqlcode THEN
        SELECT bmq02,bmq021,bmq08 INTO l_ima02,l_ima021,l_ima08 FROM bmq_file WHERE bmq01=l_bmp03
    END IF
    DISPLAY l_ima08 TO FORMONLY.ima08_2
    DISPLAY l_ima02 TO FORMONLY.ima02_2
    DISPLAY l_ima021 TO FORMONLY.ima021_2
   #DISPLAY '!' TO bed02
    CALL i104_bf(g_wc)                                              #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i104_r()
  DEFINE l_bed01  LIKE bed_file.bed01,   #MOD-8B0114 add
         l_bed011 LIKE bed_file.bed011,  #MOD-8B0114 add
         l_bed012 LIKE bed_file.bed012,  #MOD-8B0114 add
         l_bed02  LIKE bed_file.bed02    #MOD-8B0114 add
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_bed01 IS NULL THEN
        CALL cl_err("",-400,0)                     #No.FUN-6A0002
        RETURN
    END IF
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL        #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bed01"       #No.FUN-9B0098 10/02/24
        LET g_doc.value1  = g_bed01       #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "bed011"      #No.FUN-9B0098 10/02/24
        LET g_doc.value2  = g_bed011      #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "bed012"      #No.FUN-9B0098 10/02/24
        LET g_doc.value3  = g_bed012      #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "bed02"       #No.FUN-9B0098 10/02/24
        LET g_doc.value4  = g_bed02       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM bed_file
         WHERE bed01=g_bed01 AND bed011=g_bed011 AND
               bed012=g_bed012 AND bed02=g_bed02
        IF SQLCA.sqlcode THEN
        #   CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0) #No.TQC-660046
            CALL cl_err3("del","bed_file",g_bed01,g_bed011,SQLCA.sqlcode,"","BODY DELETE:",1)   #No.TQC-660046
        ELSE
            CLEAR FORM
            CALL g_bed.clear()
           #str MOD-8B0114 mod
           #OPEN i104_count
           #FETCH i104_count INTO g_row_count
            LET g_row_count = 0
            FOREACH i104_count INTO l_bed01,l_bed011,l_bed012,l_bed02
                LET g_row_count = g_row_count + 1
            END FOREACH
           #end MOD-8B0114 mod
           #FUN-B50062-add-start--
           OPEN i104_count
           IF STATUS THEN
              CLOSE i104_bcs
              CLOSE i104_count
              COMMIT WORK
              RETURN
           END IF
           FETCH i104_count INTO g_row_count
           IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
              CLOSE i104_bcs
              CLOSE i104_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50062-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i104_bcs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i104_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i104_fetch('/')
            END IF
            LET g_delete='Y'
            LET g_bed01 = NULL
            LET g_bed011 = NULL
            LET g_bed012 = NULL
            LET g_bed02 = NULL
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
        END IF
    END IF
END FUNCTION
 
#單身
FUNCTION i104_b()
DEFINE
    l_ac_t          LIKE type_file.num5,       #未取消的ARRAY CNT  #No.FUN-680096 SMALLINT
    l_n             LIKE type_file.num5,       #檢查重複用   #No.FUN-680096 SMALLINT
    l_lock_sw       LIKE type_file.chr1,       #單身鎖住否   #No.FUN-680096 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,       #處理狀態     #No.FUN-680096 VARCHAR(1)
    l_bmo05         LIKE bmo_file.bmo05,
    l_allow_insert  LIKE type_file.num5,       #可新增否     #No.FUN-680096 SMALLINT
    l_allow_delete  LIKE type_file.num5        #可刪除否     #No.FUN-680096 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_bed01 IS NULL THEN
        RETURN
    END IF
    #no.6542
    SELECT bmo05 INTO l_bmo05 FROM bmo_file
     WHERE bmo01 = g_bed01 AND bmo011=g_bed011
    IF NOT cl_null(l_bmo05) THEN
      # CALL cl_err('','mfg2761',0)  #No.TQC-660046
        CALL cl_err3("sel","bmo_file",g_bed01,g_bed011,"mfg2761","","",1)  #No.TQC-660046
       RETURN
    END IF
    #no.6542(end)
 
    CALL cl_opmsg('b')
 
 
    LET g_forupd_sql =
       "SELECT bed03,bed04,'','',bed05,bed06,bed09,bed07 ",
       "FROM bed_file ",
       "  WHERE bed01  = ? ",
       "  AND bed011 = ? ",
       "  AND bed012 = ? ",
       "  AND bed02  = ? ",
       "  AND bed03  = ? ",
       "FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i104_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_bed
            WITHOUT DEFAULTS
            FROM s_bed.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            #CKP
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               #CKP
               LET p_cmd='u'
               LET g_bed_t.* = g_bed[l_ac].*      #BACKUP
                LET g_bed04_o = g_bed[l_ac].bed04  #BACKUP
                BEGIN WORK
                OPEN i104_bcl USING g_bed01,g_bed011,g_bed012,g_bed02,g_bed_t.bed03
                IF STATUS THEN
                    CALL cl_err("OPEN i104_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i104_bcl INTO g_bed[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_bed_t.bed03,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                    LET g_bed[l_ac].ima02_b=g_bed_t.ima02_b
                    LET g_bed[l_ac].ima021_b=g_bed_t.ima021_b
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #CKP
           #NEXT FIELD bed03
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               CANCEL INSERT
            END IF
            INSERT INTO bed_file
              (bed01, bed02, bed03, bed04,
               bed05, bed06, bed07, bed011,bed012, bed09)
            VALUES(g_bed01,g_bed02,
                   g_bed[l_ac].bed03,g_bed[l_ac].bed04,
                   g_bed[l_ac].bed05,NULL,g_bed[l_ac].bed07,
                   g_bed011,g_bed012,
                   g_bed[l_ac].bed09)
            IF SQLCA.sqlcode THEN
            #  CALL cl_err(g_bed[l_ac].bed03,SQLCA.sqlcode,0) #No.TQC-660046
               CALL cl_err3("ins","bed_file",g_bed01,g_bed02,SQLCA.sqlcode,"","",1)   #No.TQC-660046
               #CKP
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            #CKP
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bed[l_ac].* TO NULL      #900423
            LET g_bed[l_ac].bed05=TODAY
            LET g_bed[l_ac].bed07=1
            LET g_bed_t.* = g_bed[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bed03
 
        BEFORE FIELD bed03                        #default 序號
            IF p_cmd='a' THEN
                SELECT max(bed03)+1
                   INTO g_bed[l_ac].bed03
                   FROM bed_file
                   WHERE bed01=g_bed01 AND bed011=g_bed011 AND
                         bed012=g_bed012 AND bed02=g_bed02
                IF g_bed[l_ac].bed03 IS NULL THEN
                    LET g_bed[l_ac].bed03 = 1
                END IF
            END IF
 
        AFTER FIELD bed03                        #check 序號是否重複
            IF NOT cl_null(g_bed[l_ac].bed03) THEN
                IF g_bed[l_ac].bed03 != g_bed_t.bed03 OR
                   g_bed_t.bed03 IS NULL THEN
                    SELECT count(*) INTO l_n FROM bed_file
                        WHERE bed01  = g_bed01
                          AND bed011 = g_bed011
                          AND bed012 = g_bed012
                          AND bed02  = g_bed02
                          AND bed03  = g_bed[l_ac].bed03
                    IF l_n > 0 THEN
                        CALL cl_err(g_bed[l_ac].bed03,-239,0)
                        LET g_bed[l_ac].bed03 = g_bed_t.bed03
                        DISPLAY g_bed[l_ac].bed03 TO s_bed[l_sl].bed03
                        NEXT FIELD bed03
                    END IF
                END IF
            END IF
 
         AFTER FIELD bed04
             IF NOT cl_null(g_bed[l_ac].bed04) THEN
#FUN-AB0025 --------------mark start------------
#                #FUN-AA0059 ---------------------------------add start-------------------
#                IF NOT s_chk_item_no(g_bed[l_ac].bed04,'') THEN
#                   CALL cl_err('',g_errno,1)
#                   LET g_bed[l_ac].bed04 = g_bed_t.bed04
#                   DISPLAY g_bed[l_ac].bed04 TO s_bed[l_sl].bed04
#                   NEXT FIELD bed04
#                 END IF 
#                 #FUN-AA0059 -------------------------------add end---------------------   
#FUN-AB0025 -----------mark end------------------
                 CALL i104_bed04('a','N',l_ac) #BugNo:6542
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_bed[l_ac].bed04 = g_bed_t.bed04
                    DISPLAY g_bed[l_ac].bed04 TO s_bed[l_sl].bed04
                    NEXT FIELD bed04
                 END IF
             END IF
 
        #No.TQC-750041 --BEGIN--
       { AFTER FIELD bed05
            IF NOT cl_null(g_bed[l_ac].bed05) THEN
               IF NOT cl_null(g_bed[l_ac].bed06) THEN
                  IF g_bed[l_ac].bed05>g_bed[l_ac].bed06 THEN
                     CALL cl_err(g_bed[l_ac].bed05,'-9913',0)
                     LET g_bed[l_ac].bed05=null
                     NEXT FIELD bed05
                  END IF 
               END IF
            END IF 
        }
         AFTER FIELD bed06
            IF NOT cl_null(g_bed[l_ac].bed06)  THEN 
               IF NOT cl_null(g_bed[l_ac].bed05)  THEN
                  IF g_bed[l_ac].bed05>g_bed[l_ac].bed06  THEN
                     CALL cl_err(g_bed[l_ac].bed06,'-9913',0)
                     LET g_bed[l_ac].bed06=null
                     NEXT FIELD bed06
                  END IF
               END IF
            END IF
 
         AFTER FIELD bed07
             IF NOT cl_null(g_bed[l_ac].bed07) THEN
                IF g_bed[l_ac].bed07<0 THEN
                   CALL cl_err(g_bed[l_ac].bed07,'aec-992',0)
                   LET g_bed[l_ac].bed07=null
                   NEXT FIELD bed07
                END IF
             END IF  
        #No.TQC-750041 --END--
 
        BEFORE DELETE                            #是否取消單身
            IF g_bed_t.bed03 > 0 AND
               g_bed_t.bed03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
                DELETE FROM bed_file
                    WHERE bed01  = g_bed01 AND
                          bed011 = g_bed011 AND
                          bed012 = g_bed012 AND
                          bed02  = g_bed02 AND
                          bed03  = g_bed_t.bed03
                IF SQLCA.sqlcode THEN
             #      CALL cl_err(g_bed_t.bed03,SQLCA.sqlcode,0) #No.TQC-660046
                    CALL cl_err3("del","bed_file",g_bed01,g_bed011,SQLCA.sqlcode,"","",1)   #No.TQC-660046
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
		COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bed[l_ac].* = g_bed_t.*
               CLOSE i104_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_bed[l_ac].bed03,-263,1)
                LET g_bed[l_ac].* = g_bed_t.*
            ELSE
                UPDATE bed_file
                   SET
                       bed03=g_bed[l_ac].bed03,
                       bed04=g_bed[l_ac].bed04,
                       bed05=g_bed[l_ac].bed05,
                       bed06=g_bed[l_ac].bed06,
                       bed07=g_bed[l_ac].bed07,
                       bed09=g_bed[l_ac].bed09
                 WHERE bed01 = g_bed01
                   AND bed011= g_bed011
                   AND bed012= g_bed012
                   AND bed02 = g_bed02
                   AND bed03 = g_bed_t.bed03
                IF SQLCA.sqlcode THEN
            #       CALL cl_err(g_bed[l_ac].bed03,SQLCA.sqlcode,0) #No.TQC-660046
                    CALL cl_err3("upd","bed_file",g_bed01,g_bed011,SQLCA.sqlcode,"","",1)   #No.TQC-660046
                    LET g_bed[l_ac].* = g_bed_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
		    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_bed[l_ac].* = g_bed_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_bed.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i104_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
           #CKP
           #LET g_bed_t.* = g_bed[l_ac].*          # 900423
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i104_bcl
            COMMIT WORK
 
 
#       ON ACTION CONTROLN
#           CALL i104_b_askkey()
#           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(bed03) AND l_ac > 1 THEN
                LET g_bed[l_ac].* = g_bed[l_ac-1].*
                NEXT FIELD bed03
            END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(bed04)
#                   CALL q_ima(10,3,g_bed[l_ac].bed04)
#FUN-AB0025 --Begin--  remark 
#FUN-AA0059 --Begin--
                  #  CALL cl_init_qry_var()
                  #  LET g_qryparam.form = "q_ima"
                  #  LET g_qryparam.default1 = g_bed[l_ac].bed04
                  #  CALL cl_create_qry() RETURNING g_bed[l_ac].bed04
                    CALL q_sel_ima(FALSE, "q_ima", "", g_bed[l_ac].bed04 , "", "", "", "" ,"",'' )  RETURNING g_bed[l_ac].bed04 
#FUN-AA0059 --End--
#FUN-AB0025 --End--  remark
#                    CALL FGL_DIALOG_SETBUFFER( g_bed[l_ac].bed04 )
                    DISPLAY g_bed[l_ac].bed04 TO bed04
                    NEXT FIELD bed04
            END CASE
 
        ON ACTION qry_test_item
#                   CALL q_bmq(10,3,g_bed[l_ac].bed04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_bmq"
                    LET g_qryparam.default1 = g_bed[l_ac].bed04
                    CALL cl_create_qry() RETURNING g_bed[l_ac].bed04
#                    CALL FGL_DIALOG_SETBUFFER( g_bed[l_ac].bed04 )
                    DISPLAY g_bed[l_ac].bed04 TO bed04
                    NEXT FIELD bed04
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
 
        ON ACTION controls                       #No.FUN-6B0033
           CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
        END INPUT
 
 
    CLOSE i104_bcl
	COMMIT WORK
END FUNCTION
 
FUNCTION i104_b_askkey()
DEFINE
    l_wc      LIKE type_file.chr1000    #No.FUN-680096  VARCHAR(300)
 
    CONSTRUCT l_wc ON bed03, bed04                     #螢幕上取條件
       FROM s_bed[1].bed03,s_bed[1].bed04
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
    IF INT_FLAG THEN LET INT_FLAG = FALSE RETURN END IF
    CALL i104_bf(l_wc)
END FUNCTION
 
FUNCTION i104_bf(p_wc)              #BODY FILL UP
DEFINE
    p_wc      LIKE type_file.chr1000       #No.FUN-680096  VARCHAR(300)
 
    LET g_sql =
       "SELECT bed03, bed04, '','',bed05, bed06, bed09, bed07 ",
       " FROM bed_file",
       " WHERE bed01 = '",g_bed01,"' AND bed011 = '",g_bed011,"'",
       "   AND bed012 = '",g_bed012,"'",
       "   AND bed02 = '",g_bed02,"'",
       "   AND ",p_wc CLIPPED ,
       " ORDER BY bed03"
    PREPARE i104_prepare2 FROM g_sql      #預備一下
    DECLARE bed_cs CURSOR FOR i104_prepare2
    CALL g_bed.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH bed_cs INTO g_bed[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        CALL i104_bed04('a','Y',g_cnt)
        LET g_cnt = g_cnt + 1
        #NO.TQC-630105----add--
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        #NO.TQC-630105----end--
    END FOREACH
    #CKP
    CALL g_bed.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i104_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bed TO s_bed.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#     BEFORE ROW
#        LET l_ac = ARR_CURR()
#      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#        LET l_sl = SCR_LINE()
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first
         CALL i104_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i104_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i104_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i104_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i104_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
     
     #CHI-710035---mark---str---
     #ON ACTION reproduce
     #   LET g_action_choice="reproduce"
     #   EXIT DISPLAY
     #CHI-710035---mark---end---
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
       ON ACTION related_document                   #MOD-470051
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
#CHI-710035---mark---str---
#FUNCTION i104_copy()
#DEFINE
#    l_oldno1         LIKE bed_file.bed01,
#    l_oldno2         LIKE bed_file.bed011,
#    l_oldno21        LIKE bed_file.bed012,
#    l_oldno3         LIKE bed_file.bed02,
#    l_newno1         LIKE bed_file.bed01,
#    l_newno2         LIKE bed_file.bed011,
#    l_newno21        LIKE bed_file.bed012,
#    l_newno3         LIKE bed_file.bed02
#
#    IF s_shut(0) THEN RETURN END IF                #檢查權限
#    IF g_bed01 IS NULL THEN
#        CALL cl_err('',-400,0)
#        RETURN
#    END IF
#    CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
#    INPUT l_newno2,l_newno21  FROM bed011,bed012
#
#{       AFTER FIELD bed01
#            IF cl_null(l_newno1) THEN
#                NEXT FIELD bed01
#            END IF
#               IF l_newno1 !='*' THEN
#                  SELECT * FROM ima_file
##                  WHERE ima01 = l_newno1 AND ima08 = 'C'
#                   WHERE ima01 = l_newno1
#                   IF SQLCA.sqlcode THEN
#                      CALL cl_err(l_newno1,'mfg2727',0)
#        	          NEXT FIELD bed01
#                   END IF
#           END IF
#}
#        AFTER FIELD bed011
#            IF cl_null(l_newno2) THEN
#                NEXT FIELD bed011
#            END IF
#            SELECT * FROM ima_file
#             WHERE ima01 = l_newno2
#            IF SQLCA.sqlcode THEN
#             #  CALL cl_err(l_newno2,'mfg2729',0) #No.TQC-660046
#               CALL cl_err3("sel","ima_file",l_newno2,"","mfg2729","","",1)   #No.TQC-660046
#               NEXT FIELD bed011
#            END IF
#            SELECT count(*) INTO g_cnt FROM bed_file
#             WHERE bed01 = g_bed01
#               AND bed011 = l_newno2
#               AND bed02 = g_bed02
#            IF g_cnt > 0 THEN
#                LET g_msg = g_bed01 CLIPPED,'+',l_newno2 CLIPPED
#                CALL cl_err(g_msg,-239,0)
#                NEXT FIELD bed011
#            END IF
#        AFTER FIELD bed012
#            IF cl_null(l_newno21) THEN
#                NEXT FIELD bed012
#            END IF
#            SELECT * FROM ima_file
#             WHERE ima01 = l_newno21
#            IF SQLCA.sqlcode THEN
#      #        CALL cl_err(l_newno21,'mfg2729',0) #No.TQC-660046
#               CALL cl_err3("sel","ima_file",l_newno21,"","mfg2729","","",1)  #No.TQC-660046
#               NEXT FIELD bed012
#            END IF
#            SELECT count(*) INTO g_cnt FROM bed_file
#             WHERE bed01 = g_bed01
#               AND bed011 = l_newno02
#               AND bed012 = l_newno21
#               AND bed02 = g_bed02
#            IF g_cnt > 0 THEN
#                LET g_msg = g_bed01 CLIPPED,'+',l_newno21 CLIPPED
#                CALL cl_err(g_msg,-239,0)
#                NEXT FIELD bed011
#            END IF
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE INPUT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
# 
# 
#    END INPUT
#    IF INT_FLAG OR l_newno2 IS NULL THEN
#        LET INT_FLAG = 0
#    	CALL i104_show()
#        RETURN
#    END IF
#    IF INT_FLAG OR l_newno21 IS NULL THEN
#        LET INT_FLAG = 0
#    	CALL i104_show()
#        RETURN
#    END IF
#    DROP TABLE x
#    SELECT * FROM bed_file
#        WHERE bed01=g_bed01
#          AND bed011=g_bed011
#          AND bed012=g_bed012
#          AND bed02=g_bed02
#        INTO TEMP x
#    UPDATE x
##       SET bed01=l_newno1,    #資料鍵值
##   	    bed08=l_newno2,
##   	    bed02=l_newno3
#        SET bed011=l_newno2,
#            bed012=l_newno21
#    INSERT INTO bed_file
#        SELECT * FROM x
#    IF SQLCA.sqlcode THEN
#     #  CALL cl_err(g_bed01,SQLCA.sqlcode,0) #No.TQC-660046
#        CALL cl_err3("ins","bed_file",g_bed01,g_bed011,SQLCA.sqlcode,"","",1)    #No.TQC-660046
#    ELSE
#        LET g_msg = g_bed01 CLIPPED, ' + ', l_newno2 CLIPPED
#        MESSAGE 'ROW(',g_msg,') O.K'
##       LET l_oldno1 = g_bed01
#        LET l_oldno2 = g_bed011
#        LET l_oldno21 = g_bed012
##       LET l_oldno3 = g_bed02
##       LET g_bed01 = l_newno1
#        LET g_bed011 = l_newno2
#        LET g_bed012 = l_newno21
##       LET g_bed02 = l_newno3
#        IF g_chkey = 'Y' THEN CALL i104_u() END IF
#        CALL i104_b()
##       LET g_bed01 = l_oldno1
#        LET g_bed011 = l_oldno2
#        LET g_bed012 = l_oldno21
##       LET g_bed02 = l_oldno3
#        CALL i104_show()
#    END IF
#END FUNCTION
#CHI-710035---mark---end---
 
FUNCTION i104_bed04(p_cmd,p_bf,p_n)    #料件編號
  DEFINE p_cmd       LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
         l_ima02     LIKE ima_file.ima02,
         l_ima021    LIKE ima_file.ima021,
         l_imaacti   LIKE ima_file.imaacti,
         l_bmq02     LIKE bmq_file.bmq02,
         l_bmq021    LIKE bmq_file.bmq021,
         l_bmqacti   LIKE bmq_file.bmqacti,
         l_test      LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
         p_bf        LIKE type_file.chr1,    #No.FUN-680096 INTEGER
         p_n         LIKE type_file.num10    #No.FUN-680096 INTEGER
 
  LET g_errno = ' '
  LET l_test = 'N'
  #正式料號
  SELECT ima02,ima021,imaacti INTO l_ima02,l_ima021,l_imaacti
    FROM ima_file
   WHERE ima01 = g_bed[p_n].bed04
  #測試料號
  IF SQLCA.sqlcode = 100 THEN
      LET l_test = 'Y'
      SELECT bmq02,bmq021,bmqacti INTO l_bmq02,l_bmq021,l_bmqacti
        FROM bmq_file
       WHERE bmq01 = g_bed[p_n].bed04
  END IF
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno  = '100'
                                 LET l_ima02  = NULL
                                 LET l_ima021 = NULL
                                 LET l_imaacti= NULL
                                 LET l_bmq02  = NULL
                                 LET l_bmq021 = NULL
                                 LET l_bmqacti= NULL
       WHEN l_imaacti='N'OR l_bmqacti='N'  LET g_errno = '9028'
  #FUN-690022------mod-------
       WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
  #FUN-690022------mod-------
 
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 
  IF l_test = 'N' THEN #正試料件
      LET g_bed[p_n].ima02_b  = l_ima02
      LET g_bed[p_n].ima021_b = l_ima021
  ELSE                 #測試料件
      LET g_bed[p_n].ima02_b  = l_bmq02
      LET g_bed[p_n].ima021_b = l_bmq021
  END IF
  IF (p_cmd='d' OR cl_null(g_errno)) AND p_bf = 'N' THEN
      DISPLAY g_bed[p_n].ima02_b  TO s_bed[l_sl].ima02_b
      DISPLAY g_bed[p_n].ima021_b TO s_bed[l_sl].ima021_b
  END IF
END FUNCTION
#Patch....NO.TQC-610035 <001> #
