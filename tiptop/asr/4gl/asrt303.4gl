# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asrt303.4gl (copy from aqc403.4gl)
# Descriptions...: FQC聯產品資料維護作業
# Input parameter:
# Date & Author..: 06/04/20 By kim
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-680130 06/08/31 By zhuying 欄位形態定義為LIKE
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0166 06/11/10 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0031 06/11/16 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980008 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/28 By huangtao 修改料號的管控 
# Modify.........: No.FUN-AA0096 10/11/01 By houlia倉庫權限使用控管修改
# Modify.........: No:FUN-BB0086 12/01/05 By tanxc 增加數量欄位小數取位 
# Modify.........: No:FUN-D40030 13/04/08 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_qcs           RECORD LIKE qcs_file.*,
    g_qcs_t         RECORD LIKE qcs_file.*,
    g_srq           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
	srq03         LIKE srq_file.srq03,   
	srq05         LIKE srq_file.srq05,   
	ima02_b       LIKE ima_file.ima02,
	ima021_b      LIKE ima_file.ima021,
	bmm05         LIKE bmm_file.bmm05,
	srq12         LIKE srq_file.srq12,   
	srq06         LIKE srq_file.srq06,   
	srq13         LIKE srq_file.srq13,   
	srq09         LIKE srq_file.srq09,   
	srq10         LIKE srq_file.srq10,   
	srq11         LIKE srq_file.srq11,   
	srq08         LIKE srq_file.srq08    
		    END RECORD,
    g_srq_t         RECORD    #程式變數(Program Variables)
	srq03         LIKE srq_file.srq03,   
	srq05         LIKE srq_file.srq05,   
	ima02_b       LIKE ima_file.ima02,
	ima021_b      LIKE ima_file.ima021,
	bmm05         LIKE bmm_file.bmm05,
	srq12         LIKE srq_file.srq12,   
	srq06         LIKE srq_file.srq06,   
	srq13         LIKE srq_file.srq13,   
	srq09         LIKE srq_file.srq09,   
	srq10         LIKE srq_file.srq10,   
	srq11         LIKE srq_file.srq11,   
	srq08         LIKE srq_file.srq08    
		    END RECORD,
    g_wc,g_wc2,g_sql   STRING, 
    g_flag          LIKE type_file.chr1,        #No.FUN-680130 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,        #單身筆數        #No.FUN-680130 SMALLINT
    l_ac            LIKE type_file.num5         #目前處理的ARRAY CNT        #No.FUN-680130 SMALLINT
DEFINE p_row,p_col     LIKE type_file.num5,     #No.FUN-680130 SMALLINT
       t_img02      LIKE img_file.img02,        #倉庫
       t_img03      LIKE img_file.img03,        #儲位
       g_img19      LIKE ima_file.ima271,       #最高限量
       g_ima271     LIKE ima_file.ima271,       #最高儲存量
       g_imf05      LIKE imf_file.imf05,        #預設料件庫存量
       h_qty        LIKE ima_file.ima271
 
#主程式開始
DEFINE g_forupd_sql STRING                  #SELECT ... FOR UPDATE SQL   
DEFINE g_before_input_done   LIKE type_file.num5    #No.FUN-680130 SMALLINT
DEFINE g_cnt                 LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE g_i                   LIKE type_file.num5    #count/index for any purpose        #No.FUN-680130 SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(72)
DEFINE g_row_count           LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE g_curs_index          LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE g_jump                LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE mi_no_ask             LIKE type_file.num5    #No.FUN-680130 SMALLINT
 
MAIN
#DEFINE                                          #No.FUN-6B0014
#       l_time    LIKE type_file.chr8            #No.FUN-6B0014
 
    OPTIONS                                #改變一些系統預設值
 INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ASR")) THEN
       EXIT PROGRAM
    END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6B0014
         RETURNING g_time    #No.FUN-6B0014
 
    LET g_qcs.qcs01  = ARG_VAL(1)           
    LET g_qcs.qcs02  = ARG_VAL(2)           
    LET g_qcs.qcs05  = ARG_VAL(3)
 
    LET g_forupd_sql = "SELECT * FROM qcs_file WHERE qcs01=? AND qcs02=? AND qcs05=?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t303_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 3 LET p_col = 14
 
    OPEN WINDOW t303_w AT  p_row,p_col         #顯示畫面
	 WITH FORM "asr/42f/asrt303"
	  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    IF NOT cl_null(g_qcs.qcs01) AND
       NOT cl_null(g_qcs.qcs02) AND 
       NOT cl_null(g_qcs.qcs05) THEN
       LET g_flag = 'Y'
       CALL t303_q()
       CALL t303_b()
    ELSE
       LET g_flag = 'N'
    END IF
 
    CALL t303_menu()
 
    CLOSE WINDOW t303_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6B0014
         RETURNING g_time    #No.FUN-6B0014
 
END MAIN
 
#QBE 查詢資料
FUNCTION t303_cs()
DEFINE  lc_qbe_sn      LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
  DEFINE  l_i,l_j      LIKE type_file.num5,      #No.FUN-680130 SMALLINT
	  l_buf        LIKE type_file.chr1000    #No.FUN-680130 VARCHAR(500)
   CLEAR FORM                             #清除畫面
   CALL g_srq.clear()
 
    IF g_flag = 'N' THEN
       CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_qcs.* TO NULL    #No.FUN-750051
       CONSTRUCT g_wc ON  qcs00 ,qcs01 ,qcs05  ,qcs021,qcs04 ,qcs041, 
			  qcs22 ,qcs06 ,qcs091 ,qcs09 ,qcs13             # 螢幕上取單頭條件
		    FROM  qcs00 ,qcs01 ,qcs05  ,qcs021,qcs04 ,qcs041,
			  qcs22 ,qcs06 ,qcs091 ,qcs09 ,qcs13
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
       CALL cl_qbe_list() RETURNING lc_qbe_sn
       CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('qcsuser', 'qcsgrup') #FUN-980030
    ELSE
	 LET g_wc = "     qcs01 ='",g_qcs.qcs01,"'",
		    " AND qcs02 ='",g_qcs.qcs02,"'",
		    " AND qcs05 = ",g_qcs.qcs05
	 LET g_wc2= "     srq01 ='",g_qcs.qcs01,"'",
		    " AND srq02 ='",g_qcs.qcs02,"'",
		    " AND srq021 =",g_qcs.qcs05
    END IF
    IF INT_FLAG THEN RETURN END IF
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
	#	LET g_wc = g_wc clipped," AND qcsuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
	#	LET g_wc = g_wc clipped," AND qcsgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    IF g_flag = 'N' THEN
       CONSTRUCT g_wc2 ON srq03,srq05,srq12,srq06,srq13,srq09,
			  srq10,srq11,srq08 # 螢幕上取單身條件
		     FROM s_srq[1].srq03,s_srq[1].srq05,
			  s_srq[1].srq12,s_srq[1].srq06,s_srq[1].srq13,
			  s_srq[1].srq09,s_srq[1].srq10,s_srq[1].srq11,
			  s_srq[1].srq08
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
       CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
 
	   ON ACTION controlp
	      CASE
		 WHEN INFIELD(srq05)
		      CALL cl_init_qry_var()
		      LET g_qryparam.form = "q_bmm"
		      LET g_qryparam.state    = "c"
		      IF NOT cl_null(g_qcs.qcs021) THEN
			 LET g_qryparam.where = "bmm01 = '",g_qcs.qcs021 CLIPPED,"'"
		      END IF
		      CALL cl_create_qry() RETURNING g_qryparam.multiret
		      DISPLAY g_qryparam.multiret TO srq05
		      NEXT FIELD srq05
		 WHEN INFIELD(srq09) #倉庫 
#FUN-AA0096  --modify	
# 	      CALL cl_init_qry_var()
# 	      LET g_qryparam.form = "q_imfd"
# 	      LET g_qryparam.state    = "c"
  	      IF g_sma.sma42 NOT MATCHES '[3]' THEN
              LET g_qryparam.where = "imf01='",g_srq[1].srq05 CLIPPED,"'"
              END IF
# 	      CALL cl_create_qry() RETURNING g_qryparam.multiret  
              CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret 
#FUN-AA0096  --end 
	      DISPLAY g_qryparam.multiret TO srq09
	      NEXT FIELD srq09
	 WHEN INFIELD(srq10) #儲位 
#FUN-AA0096   --modify
# 	      CALL cl_init_qry_var()
# 	      LET g_qryparam.form = "q_imfe"
# 	      LET g_qryparam.state    = "c"
# 	      LET g_qryparam.arg1 = g_srq[1].srq09
# 	      CALL cl_create_qry() RETURNING g_qryparam.multiret  
              CALL q_ime_1(TRUE,TRUE,"","g_srq[1].srq09","",g_plant,"","","") RETURNING g_qryparam.multiret 
#FUN-AA0096  --end 
	      DISPLAY g_qryparam.multiret TO srq10
	      NEXT FIELD srq10
	 WHEN INFIELD(srq11) #LOTS
	      CALL cl_init_qry_var()
	      LET g_qryparam.form = "q_img"
	      LET g_qryparam.state    = "c"
	      LET g_qryparam.arg1 = g_srq[1].srq05
	      LET g_qryparam.arg2 = g_srq[1].srq09
	      LET g_qryparam.arg3 = g_srq[1].srq10
	      CALL cl_create_qry() RETURNING g_qryparam.multiret
	      DISPLAY g_qryparam.multiret TO srq11
	      NEXT FIELD srq11
	 OTHERWISE
	      EXIT CASE
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
 
       IF INT_FLAG THEN  RETURN END IF
    ELSE
       LET g_wc2 = " 1=1"
    END IF
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT  qcs01,qcs02,qcs05 FROM qcs_file,ima_file ",
		   " WHERE ", g_wc CLIPPED,     # 單頭條件
		   "   AND qcs021 = ima01 ",
		   "   AND ima903 = 'Y'",
		   "   AND qcs00 = '7' "        # 資料來源'7'ASR
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE  qcs01,qcs02,qcs05 ",
		   "  FROM qcs_file, srq_file,ima_file ",
		   " WHERE qcs01 = srq01 ",
		   "   AND qcs02 = srq02 ",
		   "   AND qcs05 = srq021 ",
		   "   AND qcs00 = '7' ",       # 資料來源'7'ASR
		   "   AND qcs021 = ima01 ",
		   "   AND ima903 = 'Y'",
		   "   AND ", g_wc  CLIPPED,
		   "   AND ", g_wc2 CLIPPED
    END IF
 
    PREPARE t303_prepare FROM g_sql
    DECLARE t303_cs                         #SCROLL CURSOR
	SCROLL CURSOR WITH HOLD FOR t303_prepare
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT qcs01,qcs02,qcs05 FROM qcs_file,ima_file ",
		   " WHERE ", g_wc CLIPPED,     # 單頭條件
		   "   AND qcs021 = ima01 ",
		   "   AND ima903 = 'Y'",
		   "   AND qcs00 = '7' "        # 資料來源'7'ASR
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT qcs01,qcs02,qcs05 ",
		   "  FROM qcs_file, srq_file,ima_file ",
		   " WHERE qcs01 = srq01 ",
		   "   AND qcs02 = srq02 ",
		   "   AND qcs05 = srq021 ",
		   "   AND qcs00 = '7' ",       # 資料來源'7'ASR
		   "   AND qcs021 = ima01 ",
		   "   AND ima903 = 'Y'",
		   "   AND ", g_wc  CLIPPED,
		   "   AND ", g_wc2 CLIPPED
    END IF
 
    LET g_sql = g_sql," INTO TEMP t303_cnt "
    DROP TABLE t303_cnt
    PREPARE t303_precount_t303_cnt FROM g_sql
    EXECUTE t303_precount_t303_cnt
 
    LET g_sql="SELECT COUNT(*) FROM t303_cnt "
 
    PREPARE t303_precount FROM g_sql
    DECLARE t303_count CURSOR FOR t303_precount
END FUNCTION
 
FUNCTION t303_menu()
   WHILE TRUE
      CALL t303_bp("G")
      CASE g_action_choice
	 WHEN "query"
	    IF cl_chk_act_auth() THEN
	       CALL t303_q()
	    END IF
	 WHEN "detail"
	    IF cl_chk_act_auth() THEN
	       CALL t303_b()
	    ELSE
	       LET g_action_choice = NULL
	    END IF
	 WHEN "help"
	    CALL cl_show_help()
	 WHEN "exit"
	    EXIT WHILE
	 WHEN "controlg"
	    CALL cl_cmdask()
	 WHEN "exporttoexcel" #FUN-4B0003
	    IF cl_chk_act_auth() THEN
	      CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_srq),'','')
	    END IF
         #No.FUN-6A0166-------adk--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_qcs.qcs01 IS NOT NULL THEN
                LET g_doc.column1 = "qcs01"
                LET g_doc.column2 = "qcs02"
                LET g_doc.value1 = g_qcs.qcs01
                LET g_doc.value2 = g_qcs.qcs02
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0166-------adk--------end----
 
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION t303_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_qcs.* TO NULL               #No.FUN-6A0166 
    CALL cl_opmsg('q')
    MESSAGE ""
 
    CLEAR FORM
    CALL g_srq.clear()
    DISPLAY '   ' TO FORMONLY.cnt
 
    CALL t303_cs()
    IF INT_FLAG THEN
	LET INT_FLAG = 0
	INITIALIZE g_qcs.* TO NULL
	RETURN
    END IF
 
    OPEN t303_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_qcs.* TO NULL
    ELSE
       OPEN t303_count
       FETCH t303_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL t303_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION t303_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680130 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680130 INTEGER
 
    CASE p_flag
	WHEN 'N' FETCH NEXT     t303_cs INTO g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05
	WHEN 'P' FETCH PREVIOUS t303_cs INTO g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05
	WHEN 'F' FETCH FIRST    t303_cs INTO g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05
	WHEN 'L' FETCH LAST     t303_cs INTO g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05
	WHEN '/'
	    IF (NOT mi_no_ask) THEN
		CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
		LET INT_FLAG = 0  ######add for prompt bug
		PROMPT g_msg CLIPPED,': ' FOR g_jump
		   ON IDLE g_idle_seconds
		      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
	    FETCH ABSOLUTE g_jump t303_cs INTO g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05
	    LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
	LET g_msg=g_qcs.qcs01 CLIPPED
	CALL cl_err(g_msg,SQLCA.sqlcode,0)
	INITIALIZE g_qcs.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_qcs.* FROM qcs_file WHERE qcs01=g_qcs.qcs01 AND qcs02=g_qcs.qcs02 AND qcs05=g_qcs.qcs05
 
    IF SQLCA.sqlcode THEN
	LET g_msg=g_qcs.qcs01 CLIPPED
#       CALL cl_err(g_msg,SQLCA.sqlcode,1)   #No.FUN-660138
	CALL cl_err3("sel","qcs_file",g_qcs.qcs01,g_qcs.qcs02,SQLCA.sqlcode,"",g_msg,1)  #No.FUN-660138
	INITIALIZE g_qcs.* TO NULL
    ELSE
       LET g_data_owner = g_qcs.qcsuser
       LET g_data_group = g_qcs.qcsgrup
       CALL t303_show()                      # 重新顯示
    END IF
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t303_show()
DEFINE l_gen02 LIKE gen_file.gen02 #FUN-630105
    LET g_qcs_t.* = g_qcs.*                #保存單頭舊值
    DISPLAY BY NAME g_qcs.qcs00 ,g_qcs.qcs01 ,g_qcs.qcs05 ,
		    g_qcs.qcs021,g_qcs.qcs04 ,g_qcs.qcs041, 
		    g_qcs.qcs22 ,g_qcs.qcs06 ,g_qcs.qcs091,
		    g_qcs.qcs09 ,g_qcs.qcs13
    CALL t303_qcs09()
    CALL t303_qcs021()
 
    LET l_gen02=NULL
    IF NOT cl_null(g_qcs.qcs13) THEN
       SELECT gen02 INTO l_gen02 FROM gen_file
	  WHERE gen01=g_qcs.qcs13
    END IF
    DISPLAY l_gen02 TO FORMONLY.gen02
    CALL t303_b_fill(g_wc2)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION t303_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680130 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用        #No.FUN-680130 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680130 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態          #No.FUN-680130 VARCHAR(1)
    l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入  #No.FUN-680130 VARCHAR(1)
    sn1,sn2         LIKE type_file.num5,    #No.FUN-680130 SMALLINT
    l_code          LIKE type_file.num10,   #No.FUN-680130 INTEGER
    l_ima35         LIKE ima_file.ima35,
    l_ima36         LIKE ima_file.ima36,
    l_allow_insert  LIKE type_file.num5,    #可新增否  #No.FUN-680130 SMALLINT
    l_allow_delete  LIKE type_file.num5     #可刪除否  #No.FUN-680130 SMALLINT
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF cl_null(g_qcs.qcs01) OR cl_null(g_qcs.qcs02) OR 
       cl_null(g_qcs.qcs05) THEN
       RETURN
    END IF
    IF g_qcs.qcs14 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
 
    IF g_sma.sma104 = 'N' THEN
	#不使用聯產品!
	CALL cl_err('','aqc-412',0)
	RETURN
    END IF
 
    IF g_sma.sma105 != '1' THEN
	#認定聯產品的時機點不為FQC!
	CALL cl_err('','aqc-413',0)
	RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT srq03,srq05,'','','',srq12,srq06,srq13,",
		       "srq09,srq10,srq11,srq08 FROM srq_file ",
		       " WHERE srq01= ? AND srq02= ? AND srq021= ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t303_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_srq WITHOUT DEFAULTS FROM s_srq.*
	  ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
		    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
		    APPEND ROW=l_allow_insert)
 
	BEFORE INPUT
	    IF g_rec_b != 0 THEN
	       CALL fgl_set_arr_curr(l_ac)
	    END IF
	BEFORE ROW
	    LET p_cmd = ''
	    LET l_ac = ARR_CURR()
	    LET l_lock_sw = 'N'            #DEFAULT
	    LET l_n  = ARR_COUNT()
 
	    BEGIN WORK
	    
	    {
	    OPEN t303_cl USING g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05
	    IF STATUS THEN
	       CALL cl_err("OPEN t303_cl:", STATUS, 1)
	       CLOSE t303_cl
	       ROLLBACK WORK
	       RETURN
	    END IF
 
	    FETCH t303_cl INTO g_qcs.*            # 鎖住將被更改或取消的資料
	    IF SQLCA.sqlcode THEN
	       CALL cl_err(g_qcs.qcs01,SQLCA.sqlcode,0)      # 資料被他人LOCK
	       CLOSE t303_cl
	       ROLLBACK WORK
	       RETURN
	    END IF
	    }
	    
	    IF g_rec_b >= l_ac THEN
		LET p_cmd='u'
		LET g_srq_t.* = g_srq[l_ac].*  #BACKUP
		OPEN t303_bcl USING g_qcs.qcs01,  g_qcs.qcs02, g_qcs.qcs05
		IF STATUS THEN
		   CALL cl_err("OPEN t303_bcl:", STATUS, 1)
		   LET l_lock_sw = "Y"
		ELSE
		   FETCH t303_bcl INTO g_srq[l_ac].*
		   IF SQLCA.sqlcode THEN
		      CALL cl_err(g_srq_t.srq03,SQLCA.sqlcode,1)
		      LET l_lock_sw = "Y"
		   ELSE
		      CALL t303_set_srq05(g_srq[l_ac].srq05) 
				RETURNING g_srq[l_ac].ima02_b,
					  g_srq[l_ac].ima021_b,
					  g_srq[l_ac].bmm05
		      DISPLAY BY NAME g_srq[l_ac].ima02_b,
				      g_srq[l_ac].ima021_b,
				      g_srq[l_ac].bmm05
		   END IF
		END IF
		CALL cl_show_fld_cont()     #FUN-550037(smin)
	    END IF
 
	BEFORE INSERT
	    LET l_n = ARR_COUNT()
	    LET p_cmd='a'
	    INITIALIZE g_srq[l_ac].* TO NULL      #900423
	    LET g_srq_t.* = g_srq[l_ac].*         #新輸入資料
	    CALL cl_show_fld_cont()     #FUN-550037(smin)
	    NEXT FIELD srq03
 
	AFTER INSERT
	    IF INT_FLAG THEN
	       CALL cl_err('',9001,0)
	       LET INT_FLAG = 0
	       CANCEL INSERT
	    END IF
	    INSERT INTO srq_file(srq01,srq02,srq021,srq03,srq04,srq05,srq06,
				 srq08,srq09,srq10,srq11,srq12,srq13,
                                 srqplant,srqlegal) #FUN-980008 add
	    VALUES (g_qcs.qcs01,g_qcs.qcs02,g_qcs.qcs05,g_srq[l_ac].srq03,
		    g_qcs.qcs04,g_srq[l_ac].srq05,g_srq[l_ac].srq06,
		    g_srq[l_ac].srq08,g_srq[l_ac].srq09,g_srq[l_ac].srq10,
		    g_srq[l_ac].srq11,g_srq[l_ac].srq12,g_srq[l_ac].srq13,
                                 g_plant,g_legal) #FUN-980008 add
	    IF SQLCA.sqlcode THEN
#              CALL cl_err(g_srq[l_ac].srq03,SQLCA.sqlcode,0)   #No.FUN-660138
	       CALL cl_err3("ins","srq_file",g_qcs.qcs01,g_qcs.qcs02,SQLCA.sqlcode,"","",1)  #No.FUN-660138
	       CANCEL INSERT
	    ELSE
	       MESSAGE 'INSERT O.K'
	       LET g_rec_b=g_rec_b+1
	       DISPLAY g_rec_b TO FORMONLY.cn2
	    END IF
 
	BEFORE FIELD srq03                        #default 序號
	    IF g_srq[l_ac].srq03 IS NULL OR
	       g_srq[l_ac].srq03 = 0 THEN
		SELECT max(srq03)+1
		   INTO g_srq[l_ac].srq03
		   FROM srq_file
		   WHERE srq01 = g_qcs.qcs01
		     AND srq02 = g_qcs.qcs02
		     AND srq021= g_qcs.qcs05
		IF g_srq[l_ac].srq03 IS NULL THEN
		    LET g_srq[l_ac].srq03 = 1
		END IF
	    END IF
 
	AFTER FIELD srq03                        #check 序號是否重複
	    IF NOT cl_null(g_srq[l_ac].srq03) THEN
	       IF g_srq[l_ac].srq03 != g_srq_t.srq03 OR
		  g_srq_t.srq03 IS NULL THEN
		   SELECT count(*) INTO l_n FROM srq_file
		    WHERE srq01 = g_qcs.qcs01
		      AND srq02 = g_qcs.qcs02
		      AND srq05 = g_qcs.qcs05
		      AND srq03 = g_srq[l_ac].srq03
		   IF l_n > 0 THEN
		      CALL cl_err('',-239,0)
		      LET g_srq[l_ac].srq03 = g_srq_t.srq03
		      NEXT FIELD srq03
		   END IF
	       END IF
	    END IF
 
	AFTER FIELD srq05
	    IF NOT cl_null(g_srq[l_ac].srq05) THEN
#FUN-AA0059 ---------------------start----------------------------
               IF NOT s_chk_item_no(g_srq[l_ac].srq05,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_srq[l_ac].srq05= g_srq_t.srq05
                  NEXT FIELD srq05
               END IF
#FUN-AA0059 ---------------------end-------------------------------
	       IF g_srq[l_ac].srq05 != g_srq_t.srq05 OR
		  cl_null(g_srq_t.srq05) THEN
		  CALL t303_srq05()
		  IF NOT cl_null(g_errno) THEN
		      CALL cl_err(g_srq[l_ac].srq05,g_errno,0)
		      LET g_srq[l_ac].srq05 = g_srq_t.srq05
		      NEXT FIELD srq05
		  END IF
	       END IF
	       
	       IF g_srq[l_ac].srq05 != g_srq_t.srq05 OR
		  cl_null(g_srq_t.srq05) THEN
		  IF cl_null(g_srq_t.srq03) THEN
		     SELECT COUNT(*) INTO g_cnt FROM srq_file
		      WHERE srq01 = g_qcs.qcs01
			AND srq02 = g_qcs.qcs02
			AND srq021 = g_qcs.qcs05
		  ELSE
		     SELECT COUNT(*) INTO g_cnt FROM srq_file
		      WHERE srq01 = g_qcs.qcs01
			AND srq02 = g_qcs.qcs02
			AND srq021 = g_qcs.qcs05
			AND srq03<>g_srq_t.srq03
		  END IF
		   IF g_cnt >0 THEN
		       CALL cl_err(g_srq[l_ac].srq05,'abm-609',0)
		       #聯產品料件號編號重覆!
		       LET g_srq[l_ac].srq05 = g_srq_t.srq05
		       LET g_srq[l_ac].bmm05 = g_srq_t.bmm05
		       LET g_srq[l_ac].ima02_b = g_srq_t.ima02_b
		       LET g_srq[l_ac].ima021_b= g_srq_t.ima021_b
		       DISPLAY BY NAME g_srq[l_ac].srq05,
				       g_srq[l_ac].bmm05,
				       g_srq[l_ac].ima02_b,
				       g_srq[l_ac].ima021_b
		       NEXT FIELD srq05
		   END IF
	       END IF
	       SELECT ima35,ima36 INTO l_ima35,l_ima36 FROM ima_file
		WHERE ima01 = g_srq[l_ac].srq05
	       IF SQLCA.sqlcode THEN
		  LET l_ima35=NULL
		  LET l_ima36=NULL
	       END IF
	       LET g_srq[l_ac].srq09 = l_ima35
	       LET g_srq[l_ac].srq10 = l_ima36
	       DISPLAY BY NAME g_srq[l_ac].srq09,
			       g_srq[l_ac].srq10
	    END IF
 
	AFTER FIELD srq06 #數量
	    IF NOT cl_null(g_srq[l_ac].srq06) THEN
	       IF g_srq[l_ac].srq06 <= 0 THEN
		 #本欄位之值, 不可空白或小於等於零, 請重新輸入!
		  CALL cl_err(g_srq[l_ac].srq06,'aap-022',0)
		  NEXT FIELD srq06
	       END IF
               #No.FUN-BB0086--add--begin--
               LET g_srq[l_ac].srq06 = s_digqty(g_srq[l_ac].srq06,g_srq[l_ac].srq12)
               DISPLAY BY NAME g_srq[l_ac].srq06
               #No.FUN-BB0086--add--end--
	    END IF
 
	AFTER FIELD srq09  #倉庫
	    IF NOT cl_null(g_srq[l_ac].srq09) THEN
 #------>check-1
	       IF NOT s_imfchk1(g_srq[l_ac].srq05,g_srq[l_ac].srq09)
		  THEN CALL cl_err(g_srq[l_ac].srq09,'mfg9036',0)
		       NEXT FIELD srq09
	       END IF
 #------>check-2
	       CALL  s_stkchk(g_srq[l_ac].srq09,'A') RETURNING l_code
	       IF l_code = 0 THEN
		  CALL cl_err(g_srq[l_ac].srq09,'mfg4020',0)
		  NEXT FIELD srq09
	       END IF
#----->檢查倉庫是否為可用倉
	       CALL  s_swyn(g_srq[l_ac].srq09) RETURNING sn1,sn2
	       IF sn1=1 AND g_srq[l_ac].srq09!=t_img02 THEN
		  CALL cl_err(g_srq[l_ac].srq09,'mfg6080',0)
		  LET t_img02=g_srq[l_ac].srq09
		  NEXT FIELD srq09
	       ELSE
		 IF sn2=2 AND g_srq[l_ac].srq09!=t_img02 THEN
		    CALL cl_err(g_srq[l_ac].srq09,'mfg6085',0)
		    LET t_img02=g_srq[l_ac].srq09
		    NEXT FIELD srq09
		 END IF
	       END IF
	       LET sn1=0 LET sn2=0
	    END IF 
#FUN-AA0096   --add
      IF NOT s_chk_ware(g_srq[l_ac].srq09) THEN
         NEXT FIELD srq09
      END IF   
#FUN-AA0096   --end
 
	AFTER FIELD srq10  #儲位
	    IF g_srq[l_ac].srq10 IS NULL THEN LET g_srq[l_ac].srq10=' ' END IF
	    IF NOT cl_null(g_srq[l_ac].srq09) THEN
	       #BugNo:5626 控管是否為全型空白
	       IF g_srq[l_ac].srq10 = '　' THEN #全型空白
		  LET g_srq[l_ac].srq10 =' '
	       END IF
#---->需存在倉庫/儲位檔中
	       IF g_srq[l_ac].srq10 IS NOT NULL THEN
		  CALL s_hqty(g_srq[l_ac].srq05,g_srq[l_ac].srq09,g_srq[l_ac].srq10)
		       RETURNING g_cnt,g_img19,g_imf05
		  IF g_img19 IS NULL THEN LET g_img19=0 END IF
		  LET h_qty=g_img19
		  CALL  s_lwyn(g_srq[l_ac].srq09,g_srq[l_ac].srq10) RETURNING sn1,sn2
		   IF sn1=1 AND g_srq[l_ac].srq10!=t_img03
		      THEN CALL cl_err(g_srq[l_ac].srq10,'mfg6080',0)
			   LET t_img03=g_srq[l_ac].srq10
			   NEXT FIELD srq10
		   ELSE IF sn2=2 AND g_srq[l_ac].srq10!=t_img03
			   THEN CALL cl_err(g_srq[l_ac].srq10,'mfg6085',0)
			   LET t_img03=g_srq[l_ac].srq10
			   NEXT FIELD srq10
			END IF
		   END IF
		   LET sn1=0 LET sn2=0
	       END IF
 
	       IF g_srq[l_ac].srq10 IS NULL THEN LET g_srq[l_ac].srq10 = ' ' END IF
	    END IF 
 
 
	AFTER FIELD srq11  # 批號
	    IF g_srq[l_ac].srq11 IS NULL THEN LET g_srq[l_ac].srq11 = ' ' END IF
	    IF NOT cl_null(g_srq[l_ac].srq09) THEN
	       #BugNo:5626 控管是否為全型空白
	       IF g_srq[l_ac].srq11 = '　' THEN #全型空白
		   LET g_srq[l_ac].srq11 =' '
	       END IF
	      #倉庫/儲位/批號不可以都不輸入!!!
 
	       SELECT * FROM img_file
		WHERE img01=g_srq[l_ac].srq05 AND img02=g_srq[l_ac].srq09
		  AND img03=g_srq[l_ac].srq10 AND img04=g_srq[l_ac].srq11
	       IF STATUS=100 THEN
		  #這是新的料件倉庫儲位, 是否確定新增庫存明細(Y/N)?
		  IF NOT cl_confirm('mfg1401') THEN NEXT FIELD srq09 END IF
		  CALL s_add_img(g_srq[l_ac].srq05,g_srq[l_ac].srq09,
				 g_srq[l_ac].srq10,g_srq[l_ac].srq11,
				 g_qcs.qcs01,      g_srq[l_ac].srq03,
				 g_qcs.qcs04)
	       END IF
 
	       IF NOT s_actimg(g_srq[l_ac].srq05,g_srq[l_ac].srq09,
			       g_srq[l_ac].srq10,g_srq[l_ac].srq11) THEN
		  #該料件所存放之倉庫/存放位置/批號 已無效, 請輸入有效之資料
		  CALL cl_err('inactive','mfg6117',0)
		  NEXT FIELD srq09
	       END IF
	    END IF
 
	BEFORE DELETE                            #是否取消單身
	    IF g_srq_t.srq03 > 0 AND
	       g_srq_t.srq03 IS NOT NULL THEN
		IF NOT cl_delb(0,0) THEN
    INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
    LET g_doc.column1 = "qcs01"         #No.FUN-9B0098 10/02/24
    LET g_doc.column2 = "qcs02"         #No.FUN-9B0098 10/02/24
    LET g_doc.value1 = g_qcs.qcs01      #No.FUN-9B0098 10/02/24
    LET g_doc.value2 = g_qcs.qcs02      #No.FUN-9B0098 10/02/24
    CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
		   CANCEL DELETE
		END IF
 
		IF l_lock_sw = "Y" THEN
		   CALL cl_err("", -263, 1)
		   CANCEL DELETE
		END IF
 
		DELETE FROM srq_file
		 WHERE srq01 = g_qcs.qcs01
		   AND srq02 = g_qcs.qcs02
		   AND srq021= g_qcs.qcs05
		   AND srq03 = g_srq_t.srq03
		IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#                  CALL cl_err(g_srq_t.srq03,SQLCA.sqlcode,0)   #No.FUN-660138
		   CALL cl_err3("del","srq_file",g_qcs.qcs01,g_srq_t.srq03,SQLCA.sqlcode,"","",1)  #No.FUN-660138
		   ROLLBACK WORK
		   CANCEL DELETE
		END IF
		LET g_rec_b=g_rec_b-1
		DISPLAY g_rec_b TO FORMONLY.cn2
		COMMIT WORK
	    END IF
 
	ON ROW CHANGE
	    IF INT_FLAG THEN
	       CALL cl_err('',9001,0)
	       LET INT_FLAG = 0
	       LET g_srq[l_ac].* = g_srq_t.*
	       CLOSE t303_bcl
	       ROLLBACK WORK
	       EXIT INPUT
	    END IF
 
	    IF l_lock_sw = 'Y' THEN
	       CALL cl_err(g_srq[l_ac].srq03,-263,1)
	       LET g_srq[l_ac].* = g_srq_t.*
	    ELSE
	       UPDATE srq_file SET srq03=g_srq[l_ac].srq03,
				   srq05=g_srq[l_ac].srq05,
				   srq06=g_srq[l_ac].srq06,
				   srq08=g_srq[l_ac].srq08,
				   srq09=g_srq[l_ac].srq09,
				   srq10=g_srq[l_ac].srq10,
				   srq11=g_srq[l_ac].srq11,
				   srq12=g_srq[l_ac].srq12,
				   srq13=g_srq[l_ac].srq13
		WHERE srq01=g_qcs.qcs01
		  AND srq02=g_qcs.qcs02
		  AND srq021=g_qcs.qcs05
		  AND srq03=g_srq_t.srq03
	       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#                 CALL cl_err(g_srq[l_ac].srq03,SQLCA.sqlcode,0)   #No.FUN-660138
		  CALL cl_err3("upd","srq_file",g_qcs.qcs01,g_srq_t.srq03,SQLCA.sqlcode,"","",1)  #No.FUN-660138
		  LET g_srq[l_ac].* = g_srq_t.*
	       ELSE
		  MESSAGE 'UPDATE O.K'
		  COMMIT WORK
	       END IF
	    END IF
 
	AFTER ROW
	    LET l_ac = ARR_CURR()
#           LET l_ac_t = l_ac           #FUN-D40030 mark
	    IF INT_FLAG THEN
	       LET INT_FLAG = 0
	       CALL cl_err('',9001,0)
	       IF p_cmd = 'u' THEN
		  LET g_srq[l_ac].* = g_srq_t.*
               #FUN-D40030---add---str---
               ELSE
                  CALL g_srq.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030---add---end---
	       END IF
	       CLOSE t303_bcl
	       ROLLBACK WORK
	       EXIT INPUT
	    END IF
            LET l_ac_t = l_ac           #FUN-D40030 add 
	    CLOSE t303_bcl
	    COMMIT WORK
 
	AFTER INPUT
	    SELECT COUNT(*) INTO g_cnt
	      FROM srq_file,bmm_file
	     WHERE srq01 = g_qcs.qcs01
	       AND srq02 = g_qcs.qcs02
	       AND srq021= g_qcs.qcs05
	       AND bmm01 = g_qcs.qcs021
	       AND bmm03 = srq05
	       AND bmm05 <> 'Y'
	    IF g_cnt >= 1 THEN
		#存在無效的聯產品料號,請檢查(aqct303)單身資料正確否
		CALL cl_err('','aqc-422',1)
	    END IF
 
	ON ACTION controlp
	   CASE
	      WHEN INFIELD(srq05)
		   CALL cl_init_qry_var()
		   LET g_qryparam.form = "q_bmm"
		   LET g_qryparam.arg1 = g_qcs.qcs021
		   CALL cl_create_qry() RETURNING g_srq[l_ac].srq05,
						  g_srq[l_ac].srq12
		    DISPLAY BY NAME g_srq[l_ac].srq05,
				    g_srq[l_ac].srq12
		   NEXT FIELD srq05
	      WHEN INFIELD(srq09) #倉庫 
#FUN-AA0096  --modify 
# 	   CALL cl_init_qry_var()
# 	   LET g_qryparam.form = "q_imfd"
	   IF g_sma.sma42 NOT MATCHES '[3]' THEN
	      LET g_qryparam.where = "imf01='",g_srq[l_ac].srq05 CLIPPED,"'"
	   END IF
# 	   LET g_qryparam.default1 = g_srq[l_ac].srq09
# 	   CALL cl_create_qry() RETURNING g_srq[l_ac].srq09  
           CALL q_imd_1(FALSE,TRUE,g_srq[l_ac].srq09,"","","","") RETURNING g_srq[l_ac].srq09 
#FUN-AA0096  --end	 	  
           DISPLAY BY NAME g_srq[l_ac].srq09
	   NEXT FIELD srq09
      WHEN INFIELD(srq10) #儲位 
#FUN-AA0096  --modify	     
# 	   CALL cl_init_qry_var()
# 	   LET g_qryparam.form = "q_imfe"
# 	   LET g_qryparam.default1 = g_srq[l_ac].srq10
# 	   LET g_qryparam.arg1 = g_srq[l_ac].srq09
# 	   CALL cl_create_qry() RETURNING g_srq[l_ac].srq10   
           CALL q_ime_1(FALSE,TRUE,g_srq[l_ac].srq10,g_srq[l_ac].srq09,"",g_plant,"","","") RETURNING g_srq[l_ac].srq10  
#FUN-AA0096  --end		  
	   DISPLAY BY NAME g_srq[l_ac].srq10
	   NEXT FIELD srq10
      WHEN INFIELD(srq11) #LOTS
	   CALL cl_init_qry_var()
	   LET g_qryparam.form = "q_img"
	   LET g_qryparam.default1 = g_srq[l_ac].srq11
	   LET g_qryparam.arg1 = g_srq[l_ac].srq05
	   LET g_qryparam.arg2 = g_srq[l_ac].srq09
	   LET g_qryparam.arg3 = g_srq[l_ac].srq10
	   CALL cl_create_qry() RETURNING g_srq[l_ac].srq11
	   DISPLAY BY NAME g_srq[l_ac].srq11
	   NEXT FIELD srq11
      OTHERWISE
	   EXIT CASE
    END CASE
 
	ON ACTION CONTROLO                        #沿用所有欄位
    IF INFIELD(srq03) AND l_ac > 1 THEN
       LET g_srq[l_ac].* = g_srq[l_ac-1].*
       NEXT FIELD srq03
    END IF

	ON ACTION CONTROLZ
	   CALL cl_show_req_fields()
 
	ON ACTION CONTROLG
	    CALL cl_cmdask()
 
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
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END 
 
    END INPUT
 
    CLOSE t303_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION t303_b_askkey()
DEFINE l_wc2   STRING                                  
   CONSTRUCT g_wc2 ON srq03,srq05,srq12,srq06,srq13,srq09,srq10,srq11,srq08 # 螢幕上取單身條件
		 FROM s_srq[1].srq03,s_srq[1].srq05,s_srq[1].srq12,
		      s_srq[1].srq06,s_srq[1].srq13,s_srq[1].srq09,
		      s_srq[1].srq10,s_srq[1].srq11,s_srq[1].srq08
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
 
    CALL t303_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION t303_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           STRING,
    l_flag          LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
 
    LET g_sql =
	"SELECT srq03,srq05,'','','',srq12,srq06,",
	"srq13,srq09,srq10,srq11,srq08 ",
	"  FROM srq_file",
	" WHERE srq01 ='",g_qcs.qcs01,"'", #單頭-1
	"   AND srq02 ='",g_qcs.qcs02,"'", #單頭-1
	"   AND srq021=",g_qcs.qcs05,
	"   AND ",p_wc2 CLIPPED,           #單身
	" ORDER BY srq03"
    PREPARE t303_pb FROM g_sql
    DECLARE srq_cs                       #SCROLL CURSOR
	CURSOR FOR t303_pb
 
    CALL g_srq.clear()
    LET g_cnt = 1
    LET g_rec_b=0
 
    FOREACH srq_cs INTO g_srq[g_cnt].*   #單身 ARRAY 填充
	IF SQLCA.sqlcode THEN
	    CALL cl_err('foreach:',SQLCA.sqlcode,1)
	    EXIT FOREACH
	END IF
	
	CALL t303_set_srq05(g_srq[g_cnt].srq05) 
	    RETURNING g_srq[g_cnt].ima02_b,
		      g_srq[g_cnt].ima021_b,
		      g_srq[g_cnt].bmm05
	LET g_cnt = g_cnt + 1
 
	IF g_cnt > g_max_rec THEN
	   CALL cl_err( '', 9035, 0 )
	   EXIT FOREACH
	END IF
 
    END FOREACH
    CALL g_srq.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t303_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_srq TO s_srq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
	 CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
	 LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
	 LET g_action_choice="query"
	 EXIT DISPLAY
      ON ACTION first
	 CALL t303_fetch('F')
	 CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
	   IF g_rec_b != 0 THEN
	 CALL fgl_set_arr_curr(1)  ######add in 040505
	   END IF
	   ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
	 CALL t303_fetch('P')
	 CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
	   IF g_rec_b != 0 THEN
	 CALL fgl_set_arr_curr(1)  ######add in 040505
	   END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
	 CALL t303_fetch('/')
	 CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
	   IF g_rec_b != 0 THEN
	 CALL fgl_set_arr_curr(1)  ######add in 040505
	   END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
	 CALL t303_fetch('N')
	 CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
	   IF g_rec_b != 0 THEN
	 CALL fgl_set_arr_curr(1)  ######add in 040505
	   END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
	 CALL t303_fetch('L')
	 CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
	   IF g_rec_b != 0 THEN
	 CALL fgl_set_arr_curr(1)  ######add in 040505
	   END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
 
      ON ACTION related_document                #No.FUN-6A0166  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END
      # No.FUN-530067 --start--
      AFTER DISPLAY
	 CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
{
FUNCTION t303_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680130 SMALLINT
    sr              RECORD
	srq01       LIKE srq_file.srq01,   #
	srq02       LIKE srq_file.srq02,   #
	srq03       LIKE srq_file.srq03,   #
	srq04       LIKE srq_file.srq04,   #
	srq05       LIKE srq_file.srq05,   #
	srq06       LIKE srq_file.srq06,   #
	srq08       LIKE srq_file.srq08,   #
	srq09       LIKE srq_file.srq09,   #
	srq10       LIKE srq_file.srq10,   #
	srq11       LIKE srq_file.srq11,   #
	srq12       LIKE srq_file.srq12,   #
	srq13       LIKE srq_file.srq13,
	qcs01       LIKE qcs_file.qcs01,
	qcs02       LIKE qcs_file.qcs02,
	qcs04       LIKE qcs_file.qcs04,
	qcs021      LIKE qcs_file.qcs021,
	qcs22       LIKE qcs_file.qcs22,
	qcs091      LIKE qcs_file.qcs091,
	ima02       LIKE ima_file.ima02,
	ima55       LIKE ima_file.ima55
		    END RECORD,
    l_name          LIKE type_file.chr20,   #External(Disk) file name    #No.FUN-680130 VARCHAR(20)
    l_za05          LIKE za_file.za05       #No.FUN-680130 VARCHAR(20)
 
    IF g_wc IS NULL THEN
	CALL cl_err('','9057',0)
	RETURN
    END IF
    CALL cl_wait()
    CALL cl_outnam('aqct303') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT srq01,srq02,srq03,srq04,srq05,srq06,",
	      "       srq08,srq09,srq10,srq11,srq12,srq13,",
	      "       qcs01,qcs02,qcs04,qcs021,qcs22,qcs091,ima02,ima55 ",
	      "  FROM srq_file,qcs_file,ima_file ",
	      " WHERE srq01 = qcs01 ",
	      "   AND srq02 = qcs02 ",
	      "   AND qcs021 = ima01",
	      "   AND ",g_wc CLIPPED ,
	      "   AND ",g_wc2 CLIPPED,
	      " ORDER BY 1,2,3,4,5"
    PREPARE t303_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t303_co                         # CURSOR
	CURSOR FOR t303_p1
 
    START REPORT t303_rep TO l_name
 
    FOREACH t303_co INTO sr.*
	IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)                 
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT t303_rep(sr.*)
    END FOREACH
 
    FINISH REPORT t303_rep
 
    CLOSE t303_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
}
{
REPORT t303_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680130 VARCHAR(1)
    l_i             LIKE type_file.num5,          #No.FUN-680130 SMALLINT
    l_ima02         LIKE ima_file.ima02,
    l_ima021        LIKE ima_file.ima021,
    sr              RECORD
        srq01       LIKE srq_file.srq01,   #
        srq02       LIKE srq_file.srq02,   #
        srq03       LIKE srq_file.srq03,   #
        srq04       LIKE srq_file.srq04,   #
        srq05       LIKE srq_file.srq05,   #
        srq06       LIKE srq_file.srq06,   #
        srq08       LIKE srq_file.srq08,   #
        srq09       LIKE srq_file.srq09,   #
        srq10       LIKE srq_file.srq10,   #
        srq11       LIKE srq_file.srq11,   #
        srq12       LIKE srq_file.srq12,   #
        srq13       LIKE srq_file.srq13,
        qcs01       LIKE qcs_file.qcs01,
        qcs02       LIKE qcs_file.qcs02,
        qcs04       LIKE qcs_file.qcs04,
        qcs021      LIKE qcs_file.qcs021,
        qcs22       LIKE qcs_file.qcs22,
        qcs091      LIKE qcs_file.qcs091,
        ima02       LIKE ima_file.ima02,
        ima55       LIKE ima_file.ima55
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.srq01,sr.srq02,sr.srq03
 
    FORMAT
        PAGE HEADER
#No.FUN-580013--start
#           PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#           PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#           PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#           PRINT ' '
#           PRINT g_x[2] CLIPPED,g_today ,' ',TIME,
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#No.FUN-580013--end
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.srq01
#TQC-5B0106
            PRINT COLUMN  2,g_x[11] CLIPPED,sr.qcs01,
                  COLUMN 28,g_x[12] CLIPPED,sr.qcs02,
                  COLUMN 54,g_x[13] CLIPPED,sr.qcs04
#           PRINT COLUMN  2,g_x[11] CLIPPED,sr.qcs01,
#                 COLUMN 25,g_x[12] CLIPPED,sr.qcs02,
#                 COLUMN 46,g_x[13] CLIPPED,sr.qcs04
            PRINT COLUMN  2,g_x[14] CLIPPED,sr.qcs021
            PRINT COLUMN  2,g_x[17] CLIPPED,sr.ima02
#           PRINT COLUMN  2,g_x[14] CLIPPED,sr.qcs021,' ',sr.ima02
#TQC-5B0106 End
            PRINT COLUMN  4,g_x[15] CLIPPED,sr.qcs22,
                  COLUMN 28,g_x[16] CLIPPED,sr.qcs091
            PRINT g_dash2[1,g_len]
#No.FUN-580013--start
#           PRINT COLUMN  3,g_x[17] CLIPPED,
#                 COLUMN 31,g_x[18] CLIPPED
#           PRINT '  ----  --------------------  ---- --------- -------------------------------'
            PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
            PRINTX name=H2 g_x[36],g_x[37]
            PRINTX name=H3 g_x[38],g_x[39]
            PRINT g_dash1
#No.FUN-580013--end
 
 
        ON EVERY ROW
            SELECT   ima02,ima021
              INTO l_ima02,l_ima021
              FROM ima_file
             WHERE ima01 = sr.srq05
#No.FUN-580013--start
#           PRINT COLUMN  3,sr.srq03 USING '####',
#                 COLUMN  9,sr.srq05,
#                 COLUMN 31,sr.srq12,
#                 COLUMN 36,sr.srq06 USING '#######.#',
#                 COLUMN 46,sr.srq08
#           PRINT COLUMN 09,l_ima02,' ',l_ima021
            PRINTX name=D1
                  COLUMN g_c[31],sr.srq03 USING '####',
                  COLUMN g_c[32],sr.srq05 CLIPPED, #FUN-5B0014 [1,20],
                  COLUMN g_c[33],sr.srq12,
                  COLUMN g_c[34],sr.srq06 USING '##########&.#',
                  COLUMN g_c[35],sr.srq08[1,30]
            PRINTX name=D2
                  COLUMN g_c[37],l_ima02
            PRINTX name=D3
                  COLUMN g_c[39],l_ima021
#No.FUN-580013--end
 
        AFTER GROUP OF sr.srq01
              SKIP 2 LINE
              PRINT g_dash[1,g_len]
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
#NO.TQC-630166 end--
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
FUNCTION t303_srq05()    #聯產品料件號編號
  DEFINE l_ima02     LIKE ima_file.ima02,
         l_ima021    LIKE ima_file.ima021,
         l_bmm04     LIKE bmm_file.bmm04,
         l_bmm05     LIKE bmm_file.bmm05
 
  LET g_errno = ' '
       #單位,生效否
  SELECT bmm04,bmm05,ima02,ima021
    INTO l_bmm04,l_bmm05,l_ima02,l_ima021
    FROM bmm_file,ima_file
   WHERE bmm01 = g_qcs.qcs021      #主件料件編號
     AND bmm03 = ima01
     AND bmm03 = g_srq[l_ac].srq05 #聯產品料件號編號
 
  CASE WHEN SQLCA.SQLCODE = 100
                LET g_errno = 'abm-610' #無此聯產品料號!
                LET l_bmm04 = NULL
                LET l_bmm05 = NULL
                LET l_ima02 = NULL
                LET l_ima021= NULL
       WHEN l_bmm05='N' LET g_errno = '9028'
       OTHERWISE        LET g_errno = NULL
  END CASE
  LET g_srq[l_ac].srq12 = l_bmm04
  LET g_srq[l_ac].bmm05 = l_bmm05
  LET g_srq[l_ac].ima02_b = l_ima02
  LET g_srq[l_ac].ima021_b= l_ima021
  LET g_srq[l_ac].srq06 = s_digqty(g_srq[l_ac].srq06,g_srq[l_ac].srq12)   #FUN-BB0086 add
  DISPLAY BY NAME g_srq[l_ac].srq12,g_srq[l_ac].srq06,g_srq[l_ac].bmm05,  #FUN-BB0086 add srq06
                  g_srq[l_ac].ima02_b,g_srq[l_ac].ima021_b
END FUNCTION
 
FUNCTION t303_qcs09()
    DEFINE l_des1 LIKE ze_file.ze03
 
    CASE g_qcs.qcs09
         WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING l_des1
         WHEN '2' CALL cl_getmsg('aqc-033',g_lang) RETURNING l_des1
         WHEN '3' CALL cl_getmsg('aqc-006',g_lang) RETURNING l_des1
         OTHERWISE LET l_des1=NULL
    END CASE
    DISPLAY l_des1 TO FORMONLY.des1
END FUNCTION
FUNCTION t303_qcs021()
  DEFINE l_ima02  LIKE ima_file.ima02
  DEFINE l_ima021 LIKE ima_file.ima021
  
     SELECT ima02,ima021 INTO l_ima02,l_ima021
       FROM ima_file WHERE ima01 =g_qcs.qcs021
    DISPLAY l_ima02 TO FORMONLY.ima02_a
    DISPLAY l_ima021 TO FORMONLY.ima021_a
END FUNCTION
 
FUNCTION t303_set_srq05(p_srq05)
DEFINE p_srq05 LIKE srq_file.srq05,
       l_ima02 LIKE ima_file.ima02,
       l_ima021 LIKE ima_file.ima021,
       l_bmm05 LIKE bmm_file.bmm05
 
   SELECT ima02,ima021 INTO l_ima02,l_ima021
     FROM ima_file WHERE ima01 = p_srq05
   IF SQLCA.sqlcode THEN 
      LET l_ima02=NULL
      LET l_ima021=NULL
   END IF
   SELECT bmm05 INTO l_bmm05 FROM bmm_file
      WHERE bmm01 = g_qcs.qcs021
      AND bmm03 = p_srq05
   IF SQLCA.sqlcode THEN
      LET l_bmm05=NULL
   END IF
   RETURN l_ima02,l_ima021,l_bmm05
END FUNCTION
#Patch....NO.TQC-610036 <> #
