# Prog. Version..: '5.30.06-13.04.22(00008)'     #
#
# Pattern name...: axmi220.4gl
# Descriptions...: 客戶主檔簡易維護
# Date & Author..: 94/12/20 by Nick
#                  1.增加 D.信用資料拋轉
# Modify.........: 99/03/16 By Carol i220_b() BEFORE occ04 --> BEFORE occ05
# Modify.........: 04/07/19 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0038 04/11/15 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: NO.FUN-4C0096 05/01/06 By Carol 修改報表架構轉XML
# Modify.........: No:BUG-530301 05/03/25 By kim MOD-530301 直接輸入時未檢查區域編號是否有效
# Modify.........: No.FUN-550091 05/05/26 By Smapmin 單身新增地區欄位
# Modify.........: No.FUN-570109 05/07/15 By jackie 修正建檔程式key值是否可更改
# Modify.........: NO.MOD-590137 05/09/13 BY Yiting  統一編號輸入重覆時，未給予正確警告訊息。且未進行統一編號正確性之檢查。(需依參數設定進行檢查)
# Modify.........: NO.MOD-5A0088 05/10/07 By Rosayu 統一編號欄位若輸入錯誤的8位數字,則會warning且reject,但若輸不滿8位數字,亦會warning但卻可以存檔
# Modify.........: NO.MOD-5A0176 05/10/19 By Rosayu 在新增狀態下,客戶編號欄位應不可執行<^P>開窗查詢客戶主檔功能
# Modify.........: NO.MOD-5A0175 05/10/19 By Rosayu 在系統參數設定作業中已設定"客戶編號自動編碼"="Y",但在新增時無效
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-690057 06/09/14 By Mandy 1.多二欄位occ1004,occacti
# Modify.........: No.FUN-690057 06/09/14 By Mandy 2.使用客戶申請作業時,則此程式不可新增客戶
# Modify.........: No.FUN-690057 06/09/14 By Mandy 3.已確認'Y',則不能修改客戶簡稱
# Modify.........: No.FUN-690057 06/09/14 By Mandy 4.留置或停止交易時,不能做任何修改
# Modify.........: No.FUN-6A0094 06/11/01 By yjkhero l_time轉g_time 
# Modify.........: No.TQC-6A0091 06/11/08 By ice 修正報表格式錯誤
# Modify.........: No.MOD-6C0133 06/12/25 By claire 列印筆數不等於查詢筆數,轉ora寫法有誤
# Modify.........: No.FUN-7C0043 07/12/25 By destiny 報表改為p_query輸出 
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: No.TQC-930016 09/03/04 By chenyu 新增的時候，資料所有部門沒有賦值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.FUN-990069 09/10/12 By baofei 增加子公司可新增資料的檢查 
# Modify.........: No:TQC-980025 09/12/29 By baofei 修改call g_occ.clear() 
# Modify.........: No:TQC-A50074 10/05/19 By houlia INSERT 的字段數量與 VALUES 的數量不符合
# Modify.........: No:FUN-BB0049 11/11/15 By Carrier aza125='Y'&厂商及客户编号相同时,简称需保持相同,若为'N',则不需有此管控
#                                                    aza126='Y'&厂商客户简称修改后,需更新历史资料
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
	g_buf			LIKE type_file.chr1000,       #No.FUN-680137  VARCHAR(40)
    g_occ           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                occ01           LIKE occ_file.occ01,   #部門編號
                occ02           LIKE occ_file.occ02,   #簡稱
		occ03		LIKE occ_file.occ03,
		occ04		LIKE occ_file.occ04,
		occ05		LIKE occ_file.occ05,
		occ06		LIKE occ_file.occ06,
		occ22		LIKE occ_file.occ22,   #FUN-550091
		occ21		LIKE occ_file.occ21,
		occ20		LIKE occ_file.occ20,   #FUN-550091
		occ11		LIKE occ_file.occ11,  
		occ1004         LIKE occ_file.occ1004, #FUN-690057 add
		occacti         LIKE occ_file.occacti  #FUN-690057 add
                    END RECORD,
    g_occ_t         RECORD                 #程式變數 (舊值)
                occ01           LIKE occ_file.occ01,   #部門編號
                occ02           LIKE occ_file.occ02,   #簡稱
		occ03		LIKE occ_file.occ03,
		occ04		LIKE occ_file.occ04,
		occ05		LIKE occ_file.occ05,
		occ06		LIKE occ_file.occ06,
		occ22		LIKE occ_file.occ22,   #FUN-550091
		occ21		LIKE occ_file.occ21,
		occ20		LIKE occ_file.occ20,   #FUN-550091
		occ11		LIKE occ_file.occ11,
		occ1004         LIKE occ_file.occ1004, #FUN-690057 add
		occacti         LIKE occ_file.occacti  #FUN-690057 add
                    END RECORD,
    g_wc2,g_sql     STRING,  #No.FUN-580092 HCN  
    g_rec_b         LIKE type_file.num5,    #單身筆數            #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5,    #目前處理的ARRAY CNT #No.FUN-680137 SMALLINT
    l_row,l_col     LIKE type_file.num5,    #No.FUN-680137 SMALLINT
    l_occacti       LIKE type_file.chr1     #No.FUN-680137 VARCHAR(1)
 
DEFINE g_forupd_sql  STRING            #SELECT ... FOR UPDATE SQL    
DEFINE   g_cnt       LIKE type_file.num10               #No.FUN-680137 INTEGER
DEFINE   g_before_input_done    LIKE type_file.num5     #No.FUN-570109         #No.FUN-680137 SMALLINT
DEFINE   g_i         LIKE type_file.num5     #count/index for any purpose      #No.FUN-680137 SMALLINT
DEFINE   g_err       LIKE type_file.chr1     #MOD-590137                       #No.FUN-680137 VARCHAR(1)
MAIN
# DEFINE l_time        LIKE type_file.chr8                  #計算被使用時間      #No.FUN-680137 VARCHAR(8)  #NO.FUN-6A0094
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0094 
        RETURNING g_time                  #NO.FUN-6A0094         
    LET l_row = 4 LET l_col = 2
 
    OPEN WINDOW i220_w AT l_row,l_col WITH FORM "axm/42f/axmi220"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    LET g_wc2 = '1=1' CALL i220_b_fill(g_wc2)
    CALL i220_menu()
    CLOSE WINDOW i220_w                 #結束畫面
      CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0094 
        RETURNING g_time                 #NO.FUN-6A0094  
END MAIN
 
FUNCTION i220_menu()
   WHILE TRUE
      CALL i220_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i220_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i220_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i220_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #@WHEN "信用資料拋轉" #
         WHEN "carry_credit"
            IF cl_chk_act_auth() THEN
               CALL i220_d()
            END IF
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_occ),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i220_q()
   CALL i220_b_askkey()
END FUNCTION
 
FUNCTION i220_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680137 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否          #No.FUN-680137 SMALLINT
    l_err           LIKE type_file.chr1                 #NO.MOD-590137     #No.FUN-680137 VARCHAR(1)
DEFINE l_occ246     LIKE occ_file.occ246                #No.FUN-990069    
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    #LET g_forupd_sql = "SELECT occ01,occ02,occ03,occ04,occ05,occ06,occ20,occ21,occ11 FROM occ_file WHERE occ01=? FOR UPDATE"   #FUN-550091
    #LET g_forupd_sql = "SELECT occ01,occ02,occ03,occ04,occ05,occ06,occ22,occ21,occ20,occ11 FROM occ_file WHERE occ01=? FOR UPDATE"   #FUN-550091
     LET g_forupd_sql = "SELECT occ01,occ02,occ03,occ04,occ05,occ06,occ22,occ21,occ20,occ11,occ1004,occacti FROM occ_file WHERE occ01=? FOR UPDATE"   #FUN-550091 #FUN-690057 add occ1004,occacti
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i220_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
        #FUN-690057--add
        IF g_aza.aza61 = 'Y' THEN #使用客戶申請作業時,則此程式不可新增客戶
            LET l_allow_insert = FALSE
        END IF
        #FUN-690057--add--end
 
        INPUT ARRAY g_occ WITHOUT DEFAULTS FROM s_occ.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
                LET g_occ_t.* = g_occ[l_ac].*  #BACKUP #FUN-690057 移至CALL i220_set_no_entry(p_cmd)之前
                CALL i220_set_entry(p_cmd)    #FUN-690057 add
                CALL i220_set_no_entry(p_cmd) #MOD-530301
#FUN-990069---begin                                                                                                                 
                SELECT occ246 INTO l_occ246 FROM occ_file WHERE occ01 = g_occ[l_ac].occ01
                IF NOT s_dc_ud_flag('4',l_occ246,g_plant,'u') THEN                                                             
                   CALL cl_err(l_occ246,'aoo-045',0)                                                                           
                   CALL cl_set_comp_entry("occ03,occ04,occ05,occ06,occ22,occ21,occ20,occ11",FALSE)                                                                          
                END IF                                                                                                                  
#FUN-990069---end                                                                                             
               #LET g_occ_t.* = g_occ[l_ac].*  #BACKUP #FUN-690057 mark
               BEGIN WORK
 
               OPEN i220_bcl USING g_occ_t.occ01
               IF STATUS THEN
                  CALL cl_err("OPEN i220_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i220_bcl INTO g_occ[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_occ_t.occ01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  #FUN-690057------add--------------
                  #留置或停止交易時,不能做任何修改
                  IF g_occ[l_ac].occacti='H' THEN
                      NEXT FIELD occacti #如此的寫法是為了可以跳到下一列
                  END IF
                  #FUN-690057------add-----------end
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
	    LET l_occacti = 'Y'
            INSERT INTO occ_file(occ01,occ02,occ03,occ04,occ05,
				 #occ06,occ20,occ21,occ11,   #FUN-550091
				 occ06,occ22,occ21,occ20,occ11,   #FUN-550091
                                 occ1004,#FUN-690057 add
				 occacti,occuser,occdate,occgrup,occoriu,occorig)  #No.TQC-930016 add occgrup
            VALUES(g_occ[l_ac].occ01,g_occ[l_ac].occ02,
		   g_occ[l_ac].occ03,g_occ[l_ac].occ04,
		   g_occ[l_ac].occ05,g_occ[l_ac].occ06,
		   g_occ[l_ac].occ22,g_occ[l_ac].occ21,
		   #g_occ[l_ac].occ11,   #FUN-550091
		   g_occ[l_ac].occ20,g_occ[l_ac].occ11,   #FUN-550091
		  #l_occacti,g_user,g_today, g_user, g_grup) #FUN-690057      #No.FUN-980030 10/01/04  insert columns oriu, orig #TQC-A50074 add g_user,g_grup
		   '0','P',g_user,g_today,g_grup,g_user,g_grup)   #FUN-690057    #No.TQC-930016 add occgrup
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_occ[l_ac].occ01,SQLCA.sqlcode,0)   #No.FUN-660167
                CALL cl_err3("ins","occ_file",g_occ[l_ac].occ01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                CANCEL INSERT
            ELSE
               #No.FUN-BB0049  --Begin
               CALL s_showmsg_init()
               CALL s_upd_abbr(g_occ[l_ac].occ01,g_occ[l_ac].occ02,g_plant,'2','Y','a')
               IF g_success = 'N' THEN
                  CALL s_showmsg()
                  ROLLBACK WORK
               END IF
               #No.FUN-BB0049  --End
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
             CALL i220_set_entry(p_cmd)  #MOD-530301
            INITIALIZE g_occ[l_ac].* TO NULL      #900423
            LET l_occacti = 'Y'       #Body default
            LET g_occ_t.* = g_occ[l_ac].*         #新輸入資料
            #FUN-690057--add--
            LET g_occ[l_ac].occ1004='0' #0:開立
            LET g_occ[l_ac].occacti='P' #P:Processing
            #FUN-690057--add--end
#FUN-990069---begin                                                                                                                 
            SELECT occ246 INTO l_occ246 FROM occ_file WHERE occ01 = g_occ[l_ac].occ01
            IF NOT s_dc_ud_flag('4',l_occ246,g_plant,'a') THEN                                                             
               CALL cl_err(g_occ[l_ac].occ01,'aoo-078',0)                                                                           
               CANCEL INSERT
            END IF                                                                                                                  
#FUN-990069---end                                                                                             
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD occ01            #FUN-690057 
 
        #MOD-5A0175 add
        BEFORE FIELD occ01
            IF p_cmd='a' THEN
               IF g_aza.aza29 = 'Y' THEN
                  CALL s_auno(g_occ[l_ac].occ01,'2','') RETURNING g_occ[l_ac].occ01,g_occ[l_ac].occ02  #No.FUN-850100
               END IF
            END IF
        #MOD-5A0175 end
 
        AFTER FIELD occ01                        #check 編號是否重複
            IF g_occ[l_ac].occ01 IS NOT NULL THEN
            IF g_occ[l_ac].occ01 != g_occ_t.occ01 OR
               (g_occ[l_ac].occ01 IS NOT NULL AND g_occ_t.occ01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM occ_file
                    WHERE occ01 = g_occ[l_ac].occ01
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_occ[l_ac].occ01 = g_occ_t.occ01
                    NEXT FIELD occ01
                END IF
                #No.FUN-BB0049  --Begin
                CALL i220_set_occ02(p_cmd)
                #No.FUN-BB0049  --End  
            END IF
            END IF
 
       AFTER FIELD occ03
	    IF NOT cl_null(g_occ[l_ac].occ03) THEN
	    LET g_buf = NULL
	    SELECT oca02 INTO g_buf FROM oca_file WHERE oca01=g_occ[l_ac].occ03
	    IF STATUS THEN
#              CALL cl_err('sel oca',STATUS,0)   #No.FUN-660167
               CALL cl_err3("sel","oca_file",g_occ[l_ac].occ03,"",STATUS,"","sel oca",1)  #No.FUN-660167
               NEXT FIELD occ03 
            END IF
            MESSAGE g_buf CLIPPED
            END IF
 
       AFTER FIELD occ04
             IF NOT cl_null(g_occ[l_ac].occ04) THEN
             LET g_buf = NULL
             SELECT gen02 INTO g_buf FROM gen_file WHERE gen01=g_occ[l_ac].occ04
             IF STATUS THEN
#               CALL cl_err('sel gen',STATUS,0)  #No.FUN-660167
                CALL cl_err3("sel","gen_file",g_occ[l_ac].occ04,"",STATUS,"","sel gen",1)  #No.FUN-660167
                NEXT FIELD occ04
             END IF
             MESSAGE g_buf CLIPPED
             END IF
 
       BEFORE FIELD occ05
            IF NOT cl_null(g_occ[l_ac].occ04) THEN
               LET g_buf = NULL
               SELECT gen02 INTO g_buf FROM gen_file
                      WHERE gen01=g_occ[l_ac].occ04
               IF STATUS THEN
#                 CALL cl_err('sel gen',STATUS,0)   #No.FUN-660167
                  CALL cl_err3("sel","gen_file",g_occ[l_ac].occ04,"",STATUS,"","sel gen",1)  #No.FUN-660167
                  NEXT FIELD occ04 
               END IF
               MESSAGE g_buf CLIPPED
             ELSE
               LET g_buf = NULL
               MESSAGE g_buf CLIPPED
             END IF
 
       AFTER FIELD occ05
          IF NOT cl_null(g_occ[l_ac].occ05) THEN
          IF g_occ[l_ac].occ05 NOT MATCHES '[12]'
          THEN
              LET g_occ[l_ac].occ05 = g_occ_t.occ05
              #------MOD-5A0095 START----------
              DISPLAY BY NAME g_occ[l_ac].occ06
              #------MOD-5A0095 END------------
	  END IF
	  END IF
 
       BEFORE FIELD occ06
          LET g_buf = NULL
          MESSAGE g_buf CLIPPED
 
       AFTER FIELD occ06
	  IF g_occ[l_ac].occ06 IS NOT NULL THEN
	     IF g_occ[l_ac].occ06 NOT MATCHES '[1-3]' THEN
                LET g_occ[l_ac].occ06 = g_occ_t.occ06
                #------MOD-5A0095 START----------
                DISPLAY BY NAME g_occ[l_ac].occ06
                #------MOD-5A0095 END------------
                NEXT FIELD occ06
             END IF
          END IF
 
       BEFORE FIELD occ11
             LET g_buf = NULL
             MESSAGE g_buf CLIPPED
 
       AFTER FIELD occ11
            IF NOT cl_null(g_occ[l_ac].occ11) THEN
                #NO.MOD-590137
                SELECT count(*) INTO l_n FROM occ_file
                 WHERE occ11 = g_occ[l_ac].occ11 AND occ01 != g_occ[l_ac].occ01
                IF l_n > 0 THEN
                   CALL cl_err('','axm-028',1) #MOD-490356
                   NEXT FIELD occ11 #MOD-5A0088 add
                END IF
                #MOD-590137              #MOD-590137 MARK
                IF g_aza.aza21 = 'Y' THEN #AND cl_numchk(g_occ[l_ac].occ11,8) THEN
                   ##MOD-590137
                   CALL i220_occ11(g_occ[l_ac].occ11)
                   #MOD-590137
                   #MOD-5A0088 add
                   IF g_err = '1' THEN
                      CALL cl_err('chkban:','mfg7015',1)
                      NEXT FIELD occ11
                   END IF
                   #MOD-5A0088 end
                   IF NOT s_chkban(g_occ[l_ac].occ11) THEN
                      CALL cl_err('chkban-occ11:','aoo-080',1)
                      NEXT FIELD occ11
                   END IF
                END IF
            END IF
 
       AFTER FIELD occ20
            IF NOT cl_null(g_occ[l_ac].occ20) THEN
            LET g_buf = NULL
            SELECT gea02 INTO g_buf FROM gea_file WHERE gea01=g_occ[l_ac].occ20
            AND geaacti='Y'
            IF STATUS THEN
#               CALL cl_err('',STATUS,0)   #No.FUN-660167
                CALL cl_err3("sel","gea_file",g_occ[l_ac].occ20,"",STATUS,"","",1)  #No.FUN-660167
                NEXT FIELD occ20 #MOD-530301 
            END IF
#           MESSAGE g_buf CLIPPED
            END IF
 
       AFTER FIELD occ21
            IF NOT cl_null(g_occ[l_ac].occ21) THEN
            LET g_buf = NULL
            SELECT geb02 INTO g_buf FROM geb_file
                   WHERE geb01=g_occ[l_ac].occ21
                   AND gebacti='Y'
            IF STATUS THEN
#               CALL cl_err('',STATUS,0)   #No.FUN-660167
                CALL cl_err3("sel","geb_file",g_occ[l_ac].occ21,"",STATUS,"","",1)  #No.FUN-660167
                NEXT FIELD occ21 #MOD-530301 
            END IF
#           MESSAGE g_buf CLIPPED
            END IF
#FUN-550091
       AFTER FIELD occ22
            IF NOT cl_null(g_occ[l_ac].occ22) THEN
               CALL i220_occ22('a')
               IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_occ[l_ac].occ22,g_errno,0)
                   LET g_occ[l_ac].occ22 = g_occ_t.occ22
                   DISPLAY BY NAME g_occ[l_ac].occ22
                   DISPLAY ' ' TO occ21
                   DISPLAY ' ' TO occ20
                   DISPLAY ' ' TO geb02
                   DISPLAY ' ' TO gea02
                   NEXT FIELD occ22
               END IF
            END IF
#END FUN-550091
        BEFORE DELETE                            #是否取消單身
            IF g_occ_t.occ01 IS NOT NULL THEN
#FUN-990069---begin                                                                                                                 
                SELECT occ246 INTO l_occ246 FROM occ_file WHERE occ01 = g_occ[l_ac].occ01
                IF NOT s_dc_ud_flag('4',l_occ246,g_plant,'r') THEN                                                             
                   CALL cl_err(g_occ[l_ac].occ01,'aoo-044',0)                                                                           
                   CANCEL DELETE
                END IF                                                                                                                  
#FUN-990069---end                                                                                             
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                DELETE FROM occ_file WHERE occ01 = g_occ_t.occ01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_occ_t.occ01,SQLCA.sqlcode,0)   #No.FUN-660167
                   CALL cl_err3("del","occ_file",g_occ_t.occ01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                MESSAGE "Delete OK"
                CLOSE i220_bcl
                COMMIT WORK
             END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_occ[l_ac].* = g_occ_t.*
               CLOSE i220_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_occ[l_ac].occ01,-263,1)
               LET g_occ[l_ac].* = g_occ_t.*
            ELSE
               UPDATE occ_file SET
                      occ01=g_occ[l_ac].occ01,occ02=g_occ[l_ac].occ02,
                      occ03=g_occ[l_ac].occ03,occ04=g_occ[l_ac].occ04,
                      occ05=g_occ[l_ac].occ05,occ06=g_occ[l_ac].occ06,
                      occ22=g_occ[l_ac].occ22,occ21=g_occ[l_ac].occ21,   #FUN-550091
                      #occ11=g_occ[l_ac].occ11,occmodu=g_user,occdate=g_today   #FUN-550091
                      occ20=g_occ[l_ac].occ20,occ11=g_occ[l_ac].occ11,   #FUN-550091
                      occmodu=g_user,occdate=g_today   #FUN-550091
                WHERE occ01 = g_occ_t.occ01
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_occ[l_ac].occ01,SQLCA.sqlcode,0)   #No.FUN-660167
                  CALL cl_err3("upd","occ_file",g_occ_t.occ01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET g_occ[l_ac].* = g_occ_t.*
               ELSE
                  #No.FUN-BB0049  --Begin
                  IF NOT (g_occ[l_ac].occ01 MATCHES 'MISC*' OR g_occ[l_ac].occ01 MATCHES 'EMPL*' ) THEN
                     IF g_occ[l_ac].occ02 <> g_occ_t.occ02 THEN 
                        CALL s_showmsg_init()
                        CALL s_upd_abbr(g_occ[l_ac].occ01,g_occ[l_ac].occ02,g_plant,'2','Y','u')
                        IF g_success = 'N' THEN
                           CALL s_showmsg()
                           ROLLBACK WORK
                        END IF
                     END IF
                  END IF
                  #No.FUN-BB0049  --End
                  MESSAGE 'UPDATE O.K'
                  CLOSE i220_bcl
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_occ[l_ac].* = g_occ_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_occ.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i220_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034 add
            CLOSE i220_bcl
            COMMIT WORK
 
            ON ACTION controlp
               CASE
                  #WHEN INFIELD(occ01) #MOD-5A0176 mark
                  WHEN INFIELD(occ01) AND p_cmd = 'u' #MOD-5A0176  add
#                    CALL q_occ(10,3,g_occ[l_ac].occ01)
#                         RETURNING g_occ[l_ac].occ01
#                    CALL FGL_DIALOG_SETBUFFER( g_occ[l_ac].occ01 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_occ"
                     LET g_qryparam.default1 = g_occ[l_ac].occ01
                     CALL cl_create_qry() RETURNING g_occ[l_ac].occ01
#                     CALL FGL_DIALOG_SETBUFFER( g_occ[l_ac].occ01 )
                      DISPLAY BY NAME g_occ[l_ac].occ01      #No.MOD-490371
                     NEXT FIELD occ01
                  WHEN INFIELD(occ03)
#                    CALL q_oca(07,3,g_occ[l_ac].occ03)
#                         RETURNING g_occ[l_ac].occ03
#                    CALL FGL_DIALOG_SETBUFFER( g_occ[l_ac].occ03 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_oca"
                     LET g_qryparam.default1 = g_occ[l_ac].occ03
                     CALL cl_create_qry() RETURNING g_occ[l_ac].occ03
#                     CALL FGL_DIALOG_SETBUFFER( g_occ[l_ac].occ03 )
                      DISPLAY BY NAME g_occ[l_ac].occ03      #No.MOD-490371
                     NEXT FIELD occ03
                  WHEN INFIELD(occ04)
#                    CALL q_gen(10,3,g_occ[l_ac].occ04)
#                         RETURNING g_occ[l_ac].occ04
#                    CALL FGL_DIALOG_SETBUFFER( g_occ[l_ac].occ04 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gen"
                     LET g_qryparam.default1 = g_occ[l_ac].occ04
                     CALL cl_create_qry() RETURNING g_occ[l_ac].occ04
#                     CALL FGL_DIALOG_SETBUFFER( g_occ[l_ac].occ04 )
                      DISPLAY BY NAME g_occ[l_ac].occ04      #No.MOD-490371
                     NEXT FIELD occ04
                  WHEN INFIELD(occ20)
#                    CALL q_gea(10,3,g_occ[l_ac].occ20)
#                         RETURNING g_occ[l_ac].occ20
#                    CALL FGL_DIALOG_SETBUFFER( g_occ[l_ac].occ20 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gea"
                     LET g_qryparam.default1 = g_occ[l_ac].occ20
                     CALL cl_create_qry() RETURNING g_occ[l_ac].occ20
#                     CALL FGL_DIALOG_SETBUFFER( g_occ[l_ac].occ20 )
                      DISPLAY BY NAME g_occ[l_ac].occ20      #No.MOD-490371
                     NEXT FIELD occ20
                  WHEN INFIELD(occ21)
#                    CALL q_geb(10,3,g_occ[l_ac].occ21)
#                         RETURNING g_occ[l_ac].occ21
#                    CALL FGL_DIALOG_SETBUFFER( g_occ[l_ac].occ21 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_geb"
                     LET g_qryparam.default1 = g_occ[l_ac].occ21
                     CALL cl_create_qry() RETURNING g_occ[l_ac].occ21
#                     CALL FGL_DIALOG_SETBUFFER( g_occ[l_ac].occ21 )
                      DISPLAY BY NAME g_occ[l_ac].occ21      #No.MOD-490371
                     NEXT FIELD occ21
#FUN-550091
                  WHEN INFIELD(occ22)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_geo"
                     LET g_qryparam.default1 = g_occ[l_ac].occ22
                     CALL cl_create_qry() RETURNING g_occ[l_ac].occ22
                     DISPLAY BY NAME g_occ[l_ac].occ22
                     NEXT FIELD occ22
#FUN-550091
                  END CASE
 
        ON ACTION CONTROLN
            CALL i220_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(occ01) AND l_ac > 1 THEN
                LET g_occ[l_ac].* = g_occ[l_ac-1].*
                LET g_occ[l_ac].occ1004='0' #FUN-690057 add
                LET g_occ[l_ac].occacti='P' #FUN-690057 add
                NEXT FIELD occ01
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
 
 
        END INPUT
 
    CLOSE i220_bcl
    COMMIT WORK
END FUNCTION
 
#MOD-590137
FUNCTION i220_occ11(p_ban_code)
DEFINE p_ban_code             LIKE type_file.chr8          #No.FUN-680137 VARCHAR(8)
DEFINE i                      LIKE type_file.num5          #No.FUN-680137 SMALLINT
  LET g_err = NULL
  FOR i=1 TO 8
    IF p_ban_code[i] IS NULL OR p_ban_code[i] NOT MATCHES '[1234567890]' THEN
       LET g_err= '1'
    END IF
  END FOR
  #IF g_err = '1' THEN CALL cl_err('chkban:','mfg7015',1) END IF #MOD-5A0088 mark
END FUNCTION
#MOD-590137
 
#FUN-550091
FUNCTION i220_occ22(p_cmd)  #地區代號
   DEFINE   p_cmd       LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
            l_geo03     LIKE geb_file.geb03,            #國別代號
            l_geb02     LIKE gea_file.gea02,            #國別名稱
            l_geo02     LIKE geb_file.geb02,            #地區代號
            l_geoacti   LIKE geb_file.gebacti,          #有效碼
            l_gea02     LIKE gea_file.gea02             #區域名稱
 
   LET g_errno = ' '
   SELECT geo03,geoacti,geo02
     INTO l_geo03,l_geoacti,l_geo02
     FROM geo_file
    WHERE geo01 = g_occ[l_ac].occ22
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3011'
                                  LET l_geo03   = NULL
                                  LET l_geoacti = NULL
        WHEN l_geoacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF p_cmd = 'a' THEN
      LET g_occ[l_ac].occ21 = l_geo03
 
      DISPLAY BY NAME g_occ[l_ac].occ21
      SELECT geb02 INTO l_geb02 FROM geb_file WHERE geb01 = g_occ[l_ac].occ21
      DISPLAY l_geo02 TO geo02
      DISPLAY l_geb02 TO geb02
      SELECT gea01,gea02 INTO g_occ[l_ac].occ20,l_gea02 FROM gea_file,geb_file
             WHERE gea01 = geb03 AND geb01 = l_geo03
      DISPLAY BY NAME g_occ[l_ac].occ20
      DISPLAY l_gea02 TO gea02
   END IF
END FUNCTION
#END FUN-550091
 
FUNCTION i220_b_askkey()
    CLEAR FORM
    CALL g_occ.clear()
    #CONSTRUCT g_wc2 ON occ01,occ02,occ03,occ04,occ05,occ06,occ20,occ21,occ11   #FUN-550091
    #CONSTRUCT g_wc2 ON occ01,occ02,occ03,occ04,occ05,occ06,occ22,occ21,occ20,occ11   #FUN-550091
     CONSTRUCT g_wc2 ON occ01,occ02,occ03,occ04,occ05,occ06,occ22,occ21,occ20,occ11,occ1004,occacti   #FUN-550091 #FUN-690057 add occ1004,occacti
            FROM s_occ[1].occ01,s_occ[1].occ02,s_occ[1].occ03,s_occ[1].occ04,
 		 s_occ[1].occ05,s_occ[1].occ06,s_occ[1].occ22,s_occ[1].occ21,   #FUN-550091
		 #s_occ[1].occ11   #FUN-550091
		 s_occ[1].occ20,s_occ[1].occ11,s_occ[1].occ1004,s_occ[1].occacti   #FUN-550091 #FUN-690057 add occ1004,occacti
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
            ON ACTION controlp
               CASE
                  WHEN INFIELD(occ01)
#                    CALL q_occ(10,3,g_occ[1].occ01)
#                         RETURNING g_occ[1].occ01
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_occ"
                     LET g_qryparam.default1 = g_occ[1].occ01
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO occ01          #No.MOD-490371
                     NEXT FIELD occ01
                  WHEN INFIELD(occ03)
#                    CALL q_oca(07,3,g_occ[1].occ03)
#                         RETURNING g_occ[1].occ03
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_oca"
                     LET g_qryparam.default1 = g_occ[1].occ03
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO occ03          #No.MOD-490371
                     NEXT FIELD occ03
                  WHEN INFIELD(occ04)
#                    CALL q_gen(10,3,g_occ[1].occ04)
#                         RETURNING g_occ[1].occ04
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_gen"
                     LET g_qryparam.default1 = g_occ[1].occ04
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO occ04      #No.MOD-490371
                     NEXT FIELD occ04
                  WHEN INFIELD(occ20)
#                    CALL q_gea(10,3,g_occ[1].occ20)
#                         RETURNING g_occ[1].occ20
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_gea"
                     LET g_qryparam.default1 = g_occ[1].occ20
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO occ20       #No.MOD-490371
                     NEXT FIELD occ20
                  WHEN INFIELD(occ21)
#                    CALL q_geb(10,3,g_occ[1].occ21)
#                         RETURNING g_occ[1].occ21
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_geb"
                     LET g_qryparam.default1 = g_occ[1].occ21
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO occ21      #No.MOD-490371
                     NEXT FIELD occ21
#FUN-550091
                  WHEN INFIELD(occ22)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_geo"
                     LET g_qryparam.default1 = g_occ[1].occ22
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO occ22
                     NEXT FIELD occ22
#END FUN-550091
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('occuser', 'occgrup') #FUN-980030
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i220_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i220_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
    LET g_sql =
        #"SELECT occ01,occ02,occ03,occ04,occ05,occ06,occ20,occ21,occ11 ",   #FUN-550091
        #"SELECT occ01,occ02,occ03,occ04,occ05,occ06,occ22,occ21,occ20,occ11 ",   #FUN-550091
         "SELECT occ01,occ02,occ03,occ04,occ05,occ06,occ22,occ21,occ20,occ11,occ1004,occacti ",   #FUN-550091 #FUN-690057 add occ1004,occacti
        " FROM occ_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i220_pb FROM g_sql
    DECLARE occ_curs CURSOR FOR i220_pb
 
    CALL g_occ.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH occ_curs INTO g_occ[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
    END FOREACH
    CALL g_occ.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i220_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_occ TO s_occ.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
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
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 信用資料拋轉
      ON ACTION carry_credit
         LET g_action_choice="carry_credit"
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
 
 
   ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-7C0043--start-- 
 FUNCTION i220_out()
    DEFINE
        sr   RECORD
             occacti     LIKE occ_file.occacti,
             occ01       LIKE occ_file.occ01,
             occ02       LIKE occ_file.occ02,
             oca02       LIKE oca_file.oca02,
             occ04       LIKE occ_file.occ04,
             gen02       LIKE gen_file.gen02,
             gea02       LIKE gea_file.gea02,
             geb02       LIKE geb_file.geb02,
             geo02       LIKE geo_file.geo02   #FUN-550091
        END RECORD,
        l_i             LIKE type_file.num5,   #No.FUN-680137 SMALLINT
        l_name          LIKE type_file.chr20,  # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
        l_za05          LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(40)
    DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-7C0043                                                                 
 
    IF g_wc2 IS NULL THEN                                                                                                           
       CALL cl_err('','9057',0) RETURN END IF                                                                                       
    LET l_cmd = 'p_query "axmi220" "',g_wc2 CLIPPED,'"'                                                                             
    CALL cl_cmdrun(l_cmd)                                                                                                           
    RETURN
#   IF g_wc2 IS NULL THEN
#      CALL cl_err('','9057',0) RETURN END IF
#   CALL cl_wait()
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#  #LET g_sql=" SELECT occacti,occ01,occ02,oca02,occ04,gen02,gea02,geb02 ",   #FUN-550091
#   LET g_sql=" SELECT occacti,occ01,occ02,oca02,occ04,gen02,gea02,geb02,geo02 ",   #FUN-550091
#             " FROM occ_file, ",
#            #" OUTER oca_file,OUTER gen_file,OUTER gea_file,OUTER geb_file, ",   #FUN-550091
#             " WHERE ",g_wc2 CLIPPED
#   #MOD-6C0133 modify 
#   PREPARE i220_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i220_co                         # CURSOR
#       CURSOR FOR i220_p1
 
#   LET g_rlang = g_lang                               #FUN-4C0096 add
#   CALL cl_outnam('axmi220') RETURNING l_name         #FUN-4C0096 add
#   START REPORT i220_rep TO l_name
 
#   FOREACH i220_co INTO sr.*
#       DISPLAY "sr.occ01=",sr.occ01
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1) 
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i220_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i220_rep
 
#   CLOSE i220_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i220_rep(sr)
#   DEFINE
#       l_trailer_sw     LIKE type_file.chr1,             #No.FUN-680137 VARCHAR(1)
#       sr   RECORD
#            occacti     LIKE occ_file.occacti,
#            occ01       LIKE occ_file.occ01,
#            occ02       LIKE occ_file.occ02,
#            oca02       LIKE oca_file.oca02,
#            occ04       LIKE occ_file.occ04,
#            gen02       LIKE gen_file.gen02,
#            gea02       LIKE gea_file.gea02,
#            geb02       LIKE geb_file.geb02,
#            geo02       LIKE geo_file.geo02   #FUN-550091
#       END RECORD
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.occ01
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED   #No.TQC-6A0091
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<','/pageno'
#           PRINT g_head CLIPPED, pageno_total
#           #PRINT ''   #No.TQC-6A0091
 
#           PRINT g_dash
#           PRINT g_x[31],
#                 g_x[32],
#                 g_x[33],
#                 g_x[34],
#                 g_x[35],
#                 g_x[36],
#                 g_x[37],
#                 g_x[38],
#                 g_x[39]   #FUN-550091
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
#       ON EVERY ROW
#           IF sr.occacti = 'N'
#              THEN PRINT COLUMN g_c[31],'N';
#              ELSE PRINT COLUMN g_c[31],'  ';
#           END IF
#           PRINT COLUMN g_c[32],sr.occ01,
#                 COLUMN g_c[33],sr.occ02 CLIPPED,
#                 COLUMN g_c[34],sr.oca02 CLIPPED,
#                 COLUMN g_c[35],sr.occ04 CLIPPED,
#                 COLUMN g_c[36],sr.gen02 CLIPPED,
#                 COLUMN g_c[37],sr.gea02 CLIPPED,
#                 COLUMN g_c[38],sr.geb02 CLIPPED,
#                 COLUMN g_c[39],sr.geo02 CLIPPED   #FUN-550091
#
#       ON LAST ROW
#           PRINT g_dash[1,g_len]
#           #PRINT g_x[4] CLIPPED, COLUMN g_c[38], g_x[7] CLIPPED   #FUN-550091
#           PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED  #No.TQC-6A0091
#           LET l_trailer_sw = 'n'
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               #PRINT g_x[4] CLIPPED, COLUMN g_c[38], g_x[6] CLIPPED   #FUN-550091
#               PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED   #FUN-550091  #No.TQC-6A0091
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-7C0043--end--
#--------------#
# 信用額度拋轉 #
#--------------#
FUNCTION i220_d()
   DEFINE l_occg     RECORD LIKE occg_file.*    # 客戶GLOBAL檔
   DEFINE l_occ      RECORD LIKE occ_file.*     # 客戶主檔
 
 
   OPEN WINDOW i220_d_w AT 7,12 WITH FORM "axm/42f/axmi220d"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("axmi220d")
 
 
   CALL cl_opmsg('q')
 
   CLEAR FORM
  # CALL g_occ.clear()   #TQC-980025
   INITIALIZE l_occ.* TO NULL   #TQC-980025
 
   CONSTRUCT BY NAME g_wc2 ON occ01
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
            ON ACTION controlp
               CASE
                  WHEN INFIELD(occ01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_occ"
                     LET g_qryparam.default1 = g_occ[1].occ01
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO occ01
                     NEXT FIELD occ01
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
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW i220_d_w
      RETURN
   END IF
 
   LET g_sql = "SELECT *  FROM occ_file",
               " WHERE occ62='Y'",
               "   AND ", g_wc2 CLIPPED,
               " ORDER BY 1"
   PREPARE i220_d_prepare FROM g_sql
   DECLARE i220_d_curs CURSOR FOR i220_d_prepare
 
   LET g_success='Y'
   LET g_i=0
 
   BEGIN WORK
 
   FOREACH i220_d_curs INTO l_occ.*
      IF STATUS THEN CALL cl_err('foreach',STATUS,1)
         LET g_success='N' EXIT FOREACH
      END IF
 
      SELECT COUNT(*) INTO g_cnt FROM occg_file
       WHERE occg01=l_occ.occ01                    # 客戶編號
 
      IF cl_null(l_occ.occ63) THEN LET l_occ.occ63=0 END IF
      IF cl_null(l_occ.occ64) THEN LET l_occ.occ64=0 END IF
      IF g_cnt>0 THEN
         UPDATE occg_file SET occg03=l_occ.occ63,
                              occg04=l_occ.occ64
          WHERE occg01=l_occ.occ01
         IF SQLCA.sqlcode THEN
#           CALL cl_err('upd occg_file',SQLCA.sqlcode,1)   #No.FUN-660167
            CALL cl_err3("upd","occg_file",l_occ.occ01,"",SQLCA.sqlcode,"","upd occg_file",1)  #No.FUN-660167
	    LET g_success = 'N'
         ELSE
            LET g_i=g_i+1
            MESSAGE g_i
         END IF
      ELSE
          INSERT INTO occg_file(occg01,occg02,occg03,occg04)  #No.MOD-470041
                        VALUES(l_occ.occ01,l_occ.occ11,
                               l_occ.occ63,l_occ.occ64)
         IF SQLCA.sqlcode THEN
#           CALL cl_err('ins occg_file',SQLCA.sqlcode,1)   #No.FUN-660167
            CALL cl_err3("ins","occg_file",l_occ.occ01,"",SQLCA.sqlcode,"","ins occg_file",1)  #No.FUN-660167
	    LET g_success = 'N'
         ELSE
            LET g_i=g_i+1
            MESSAGE g_i
         END IF
      END IF
 
   END FOREACH
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   CLOSE WINDOW i220_d_w                 #結束畫面
 
END FUNCTION
 
 #MOD-530301
FUNCTION i220_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
     IF p_cmd = 'a' THEN
         CALL cl_set_comp_entry("occ01",TRUE)
     END IF
     CALL cl_set_comp_entry("occ02",TRUE) #FUN-690057
 
END FUNCTION
 
 #MOD-530301
FUNCTION i220_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
#    IF p_cmd = 'u' THEN
    IF p_cmd = 'u' AND g_chkey='N' THEN   #No.FUN-570109
       CALL cl_set_comp_entry("occ01",FALSE)
    END IF
    #FUN-690057---------add-----
    #已確認"Y",則不能修改客戶簡稱
    IF g_occ_t.occacti='Y' THEN
        CALL cl_set_comp_entry("occ02",FALSE)
    END IF
    #當參數設定使用客戶申請作業時,修改時不可更改簡稱
    IF g_aza.aza61='Y' AND p_cmd = 'u' THEN
        CALL cl_set_comp_entry("occ02",FALSE)
    END IF
    #FUN-690057---------add-end-
 
END FUNCTION
 
#Patch....NO.MOD-5A0095 <001,002> #
#No.FUN-BB0049  --Begin
FUNCTION i220_set_occ02(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  DEFINE l_cnt   LIKE type_file.num5
  DEFINE l_pmc03 LIKE pmc_file.pmc03

   IF cl_null(g_occ[l_ac].occ01) THEN RETURN END IF
   IF p_cmd <> 'a' THEN RETURN END IF
   IF g_aza.aza125 = 'N' THEN RETURN END IF 
   
   SELECT pmc03 INTO l_pmc03 FROM pmc_file
    WHERE pmc01 = g_occ[l_ac].occ01
   IF cl_null(l_pmc03) THEN RETURN END IF
   IF NOT cl_null(l_pmc03) THEN
      LET g_occ[l_ac].occ02 = l_pmc03
   END IF

END FUNCTION
#No.FUN-BB0049  --End  

