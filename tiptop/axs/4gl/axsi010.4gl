# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axsi010.4gl
# Descriptions...: 銷售分析系統單據性質維護作業
# Date & Author..: 95/03/08 By Danny
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0099 05/01/18 By kim 報表轉XML功能
# Modify.........: No.FUN-560060 05/06/17 By DAY   單據編號修改               
# Modify.........: No.FUN-560150 05/06/21 By ice 編碼方法增加4.依年月日,
#                                                輸入的單別按整體定義的參數位數輸入
# Modify.........: No.FUN-570110 05/07/14 By wujie 修正建檔程式key值是否可更改
# Modify.........: NO.TQC-5A0098 05/10/26 By Niocla 單據性質取位修改
# Modify.........: No.FUN-660155 06/06/22 By Czl cl_err --> cl_err3
# Modify.........: No.TQC-660133 06/07/03 By rainy s_xxxslip(),s_smu(),s_smv()中的參數 g_sys 改寫死系統別(ex:AAP)中的參數 g_sys 改寫死系統別(ex:AAP)
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.TQC-670042 06/07/13 By Claire 權限修正
# Modify.........: No.FUN-680130 06/08/30 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No.FUN-6A0095 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-740015 07/04/03 By TSD.liquor 報表改寫由Crystal Report產出
# Modify.........: No.TQC-780054 07/08/17 By zhoufeng 修改INSERT INTO temptable語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A10109 10/02/09 By TSD.lucasyeh單據編碼優化
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-B50039 11/07/08 By xianghui 增加自訂欄位
# Modify.........: No.FUN-B90041 11/09/05 By minpp 程序撰写规范修改 
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

 DATABASE ds

 GLOBALS "../../config/top.global"
 
DEFINE 
    m_osy           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
	osyslip     LIKE osy_file.osyslip,  
	osydesc     LIKE osy_file.osydesc, 
	osyauno     LIKE osy_file.osyauno,
	#osydmy1    LIKE osy_file.osydmy1,   #FUN-A10109 mark by TSD.lucasyeh
	osytype     LIKE osy_file.osytype,
               #FUN-B50039-add-str--
        osyud01     LIKE osy_file.osyud01,
        osyud02     LIKE osy_file.osyud02,
        osyud03     LIKE osy_file.osyud03,
        osyud04     LIKE osy_file.osyud04,
        osyud05     LIKE osy_file.osyud05,
        osyud06     LIKE osy_file.osyud06,
        osyud07     LIKE osy_file.osyud07,
        osyud08     LIKE osy_file.osyud08,
        osyud09     LIKE osy_file.osyud09,
        osyud10     LIKE osy_file.osyud10,
        osyud11     LIKE osy_file.osyud11,
        osyud12     LIKE osy_file.osyud12,
        osyud13     LIKE osy_file.osyud13,
        osyud14     LIKE osy_file.osyud14,
        osyud15     LIKE osy_file.osyud15
            #FUN-B50039-add-end--
         END RECORD,
    g_buf           LIKE type_file.chr1000,   #No.FUN-680130  CAHR(40)
    m_osy_t         RECORD                    #程式變數 (舊值)
	osyslip     LIKE osy_file.osyslip,  
	osydesc     LIKE osy_file.osydesc, 
	osyauno     LIKE osy_file.osyauno,
	#osydmy1     LIKE osy_file.osydmy1,   #FUN-A10109 mark by TSD.lucsayeh
	osytype     LIKE osy_file.osytype,
               #FUN-B50039-add-str--
        osyud01     LIKE osy_file.osyud01,
        osyud02     LIKE osy_file.osyud02,
        osyud03     LIKE osy_file.osyud03,
        osyud04     LIKE osy_file.osyud04,
        osyud05     LIKE osy_file.osyud05,
        osyud06     LIKE osy_file.osyud06,
        osyud07     LIKE osy_file.osyud07,
        osyud08     LIKE osy_file.osyud08,
        osyud09     LIKE osy_file.osyud09,
        osyud10     LIKE osy_file.osyud10,
        osyud11     LIKE osy_file.osyud11,
        osyud12     LIKE osy_file.osyud12,
        osyud13     LIKE osy_file.osyud13,
        osyud14     LIKE osy_file.osyud14,
        osyud15     LIKE osy_file.osyud15
             #FUN-B50039-add-end--
    END RECORD,
    g_wc2,g_sql     string,                   #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,      #單身筆數        #No.FUN-680130  SMALLINT
    l_ac            LIKE type_file.num5,      #目前處理的ARRAY CNT        #No.FUN-680130  SMALLINT
    l_sl            LIKE type_file.num5       #目前處理的SCREEN LINE #No.FUN-680130  SMALLINT
 
DEFINE   g_before_input_done   LIKE type_file.num5     #No.FUN-570110     #No.FUN-680130  SMALLINT
DEFINE   p_row,p_col           LIKE type_file.num5     #No.FUN-680130  SMALLINT
DEFINE   g_forupd_sql          STRING                  #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt                 LIKE type_file.num10    #No.FUN-680130  INTEGER
DEFINE   g_i                   LIKE type_file.num5     #count/index for any purpose     #No.FUN-680130  SMALLINT
DEFINE   g_str                 STRING                  #No.FUN-740015 add

MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0095

   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
         
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
	  
   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AXS")) THEN
      EXIT PROGRAM
   END IF
 
  CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
     RETURNING g_time    #No.FUN-6A0095
    LET p_row = 3 LET p_col = 10
 
    OPEN WINDOW i010_w AT p_row,p_col WITH FORM "axs/42f/axsi010"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
	    
    CALL cl_ui_init()

   #FUN-A10109 add by TSD.lucasyeh---(S)
   CALL s_getgee(g_prog,g_lang,'osytype')
   #FUN-A10109 add by TSD.lucasyeh---(E) 
		
   LET g_wc2 = '1=1' CALL i010_b_fill(g_wc2)
   CALL i010_menu()
   CLOSE WINDOW i010_w                 #結束畫面
   CALL  cl_used(g_prog,g_time,2)     #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
      RETURNING g_time    #No.FUN-6A0095
END MAIN
 
	FUNCTION i010_menu()
 
	   WHILE TRUE
	      CALL i010_bp("G")
	      CASE g_action_choice
		 WHEN "query" 
		    IF cl_chk_act_auth() THEN
		       CALL i010_q()
		    END IF
		 WHEN "detail"
		    IF cl_chk_act_auth() THEN
		       CALL i010_b()
		    ELSE
		       LET g_action_choice = NULL
		    END IF
		 WHEN "output" 
		    IF cl_chk_act_auth() THEN
		       CALL i010_out()
		    END IF
		 WHEN "help" 
		    CALL cl_show_help()
		 WHEN "exit"
		    EXIT WHILE
		 WHEN "controlg"   
		    CALL cl_cmdask()
		 WHEN "exporttoexcel"     #FUN-4B0025
		    IF cl_chk_act_auth() THEN
		      CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(m_osy),'','')
		    END IF
 
	      END CASE
	   END WHILE
	END FUNCTION
 
 
	FUNCTION i010_q()
	   CALL i010_b_askkey()
	END FUNCTION
 
	FUNCTION i010_b()
	DEFINE
	    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT  #No.FUN-680130  SMALLINT
	    l_n             LIKE type_file.num5,   #檢查重複用         #No.FUN-680130  SMALLINT
	    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否         #No.FUN-680130  VARCHAR(1)
	    p_cmd           LIKE type_file.chr1,   #處理狀態           #No.FUN-680130  VARCHAR(1)
	    l_allow_insert  LIKE type_file.chr1,   #可新增否           #No.FUN-680130  VARCHAR(01)              
	    l_allow_delete  LIKE type_file.chr1    #可刪除否           #No.FUN-680130  VARCHAR(01)               
	DEFINE l_i          LIKE type_file.num5                        #No.FUN-680130  SMALLINT
 
	   LET g_action_choice = ""
 
	   IF s_shut(0) THEN RETURN END IF
 
	   LET l_allow_insert = cl_detail_input_auth('insert')
	   LET l_allow_delete = cl_detail_input_auth('delete')
 
	    IF s_shut(0) THEN RETURN END IF
 
	    CALL cl_opmsg('b')

     #FUN-A10109 mod by TSD.lucasyeh---(S) 
     #    LET g_forupd_sql = " SELECT osyslip,osydesc,osyauno,osydmy1,osytype ",
	    LET g_forupd_sql = " SELECT osyslip,osydesc,osyauno,osytype,",
     #FUN-A10109 mod by TSD.lucasyeh---(E) 
                               "       osyud01,osyud02,osyud03,osyud04,osyud05,",     #FUN-B50039
                               "       osyud06,osyud07,osyud08,osyud09,osyud10,",     #FUN-B50039
                               "       osyud11,osyud12,osyud13,osyud14,osyud15 ",     #FUN-B50039
		               " FROM osy_file  WHERE osyslip=? ",
			       " FOR UPDATE " 
 
     LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
	    DECLARE i010_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
		INPUT ARRAY m_osy WITHOUT DEFAULTS FROM s_osy.*
		 ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
			    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
		BEFORE INPUT
		    IF g_rec_b != 0 THEN
		       CALL fgl_set_arr_curr(l_ac)
		    END IF 
		    #NO.FUN-560150 --start--
		    CALL cl_set_doctype_format("osyslip")
		    #NO.FUN-560150 --end--
 
		BEFORE ROW
		    LET p_cmd = ''
		    LET l_ac = ARR_CURR()
		    LET l_lock_sw = 'N'            #DEFAULT
		    LET l_n  = ARR_COUNT()
 
		    IF g_rec_b>=l_ac THEN
			BEGIN WORK
			LET m_osy_t.* = m_osy[l_ac].*  #BACKUP
			LET p_cmd='u'
	#No.FUN-570110--begin                                                           
			LET g_before_input_done = FALSE                                 
			CALL i010_set_entry_b(p_cmd)                                    
			CALL i010_set_no_entry_b(p_cmd)                                 
			LET g_before_input_done = TRUE                                  
	#No.FUN-570110--end       
 
			OPEN i010_bcl USING m_osy_t.osyslip 
			IF STATUS THEN
			   CALL cl_err("OPEN i010_bcl:", STATUS, 1)
			   LET l_lock_sw = "Y"
			END IF
			FETCH i010_bcl INTO m_osy[l_ac].* 
			IF SQLCA.sqlcode THEN
			    CALL cl_err(m_osy_t.osyslip,SQLCA.sqlcode,1)
			    LET l_lock_sw = "Y"
			END IF
			CALL cl_show_fld_cont()     #FUN-550037(smin)
		    END IF
 
		BEFORE INSERT
		    LET l_n = ARR_COUNT()
		    LET p_cmd='a'
	#No.FUN-570110--begin                                                           
		    LET g_before_input_done = FALSE                                     
		    CALL i010_set_entry_b(p_cmd)                                        
		    CALL i010_set_no_entry_b(p_cmd)                                     
		    LET g_before_input_done = TRUE                                      
	#No.FUN-570110--end     
		    INITIALIZE m_osy[l_ac].* TO NULL      #900423
		    LET m_osy_t.* = m_osy[l_ac].*         #新輸入資料
		    DISPLAY m_osy[l_ac].* TO s_osy[l_sl].* 
		    CALL cl_show_fld_cont()     #FUN-550037(smin)
		    NEXT FIELD osyslip
 
	      AFTER INSERT
		 IF INT_FLAG THEN                 #900423
		    CALL cl_err('',9001,0)
		    LET INT_FLAG = 0
		    CLOSE i010_bcl
		    CANCEL INSERT
		 END IF
             #FUN-A10109 mod by TSD.lucsayeh---(S)
		# INSERT INTO osy_file(osyslip,osydesc,osyauno,osydmy1,osytype)
		#	       VALUES(m_osy[l_ac].osyslip,m_osy[l_ac].osydesc,
		#		      m_osy[l_ac].osyauno,m_osy[l_ac].osydmy1,
		#		      m_osy[l_ac].osytype)
		 INSERT INTO osy_file(osyslip,osydesc,osyauno,osytype,
                                      osyud01,osyud02,osyud03,osyud04,osyud05,       #FUN-B50039
                                      osyud06,osyud07,osyud08,osyud09,osyud10,       #FUN-B50039
                                      osyud11,osyud12,osyud13,osyud14,osyud15)       #FUN-B50039
			       VALUES(m_osy[l_ac].osyslip,m_osy[l_ac].osydesc,
				      m_osy[l_ac].osyauno,m_osy[l_ac].osytype,
                                      #FUN-B50039-add-str--
                                      m_osy[l_ac].osyud01,m_osy[l_ac].osyud02,
                                      m_osy[l_ac].osyud03,m_osy[l_ac].osyud04,
                                      m_osy[l_ac].osyud05,m_osy[l_ac].osyud06,
                                      m_osy[l_ac].osyud07,m_osy[l_ac].osyud08,
                                      m_osy[l_ac].osyud09,m_osy[l_ac].osyud10,
                                      m_osy[l_ac].osyud11,m_osy[l_ac].osyud12,
                                      m_osy[l_ac].osyud13,m_osy[l_ac].osyud14,
                                      m_osy[l_ac].osyud15)
                                      #FUN-B50039-add-end--
             #FUN-A10109 mod by TSD.lucsayeh---(E)
		 IF SQLCA.sqlcode THEN
	#           CALL cl_err(m_osy[l_ac].osyslip,SQLCA.sqlcode,0)   #No.FUN-660155
		    CALL cl_err3("ins","osy_file",m_osy[l_ac].osyslip,"",SQLCA.sqlcode,"","",1)  #No.FUN-660155
		    CANCEL INSERT
		 ELSE

                    #FUN-A10109  ===S===
                    CALL s_access_doc('a',m_osy[l_ac].osyauno,m_osy[l_ac].osytype,
                                      m_osy[l_ac].osyslip,'AXS','Y')
                    #FUN-A10109  ===E===

		    MESSAGE 'INSERT O.K'
		    LET g_rec_b=g_rec_b+1
		    DISPLAY g_rec_b TO FORMONLY.cn2  
		 END IF
 
		AFTER FIELD osyslip                        #check 編號是否重複
		   IF m_osy[l_ac].osyslip != m_osy_t.osyslip OR
		   (NOT cl_null(m_osy[l_ac].osyslip) AND cl_null(m_osy_t.osyslip)) THEN
			SELECT count(*) INTO l_n FROM osy_file
			    WHERE osyslip = m_osy[l_ac].osyslip
			IF l_n > 0 THEN
			    CALL cl_err('',-239,0)
			    LET m_osy[l_ac].osyslip = m_osy_t.osyslip
			    NEXT FIELD osyslip
			END IF
			#NO.FUN-560150 --start--
			FOR l_i = 1 TO g_doc_len
			   IF cl_null(m_osy[l_ac].osyslip[l_i,l_i]) THEN
			      CALL cl_err('','sub-146',0)
			      LET m_osy[l_ac].osyslip = m_osy_t.osyslip
			      NEXT FIELD osyslip
			   END IF
			END FOR
			#NO.FUN-560150 --end--
		    END IF
		    IF m_osy[l_ac].osyslip != m_osy_t.osyslip THEN  #NO:6842
		       UPDATE smv_file  SET smv01=m_osy[l_ac].osyslip
			WHERE smv01=m_osy_t.osyslip   #NO:單別
			  #AND smv03=g_sys             #NO:系統別  #TQC-670008 remark
			  AND upper(smv03)='AXS'       #NO:系統別  #TQC-670008
		       IF SQLCA.sqlcode THEN
	#                  CALL cl_err('UPDATE smv_file',SQLCA.sqlcode,0)   #No.FUN-660155
			   CALL cl_err3("upd","smv_file",m_osy_t.osyslip,"",SQLCA.sqlcode,"","UPDATE smv_file",1)  #No.FUN-660155
		       END IF
		       UPDATE smu_file  SET smu01=m_osy[l_ac].osyslip
			WHERE smu01=m_osy_t.osyslip   #NO:單別
			  #AND smu03=g_sys             #NO:系統別  #TQC-670008 remark
			  AND upper(smu03)='AXS'       #NO:系統別  #TQC-670008
		       IF SQLCA.sqlcode THEN
	#                  CALL cl_err('UPDATE smu_file',SQLCA.sqlcode,0)   #No.FUN-660155
			   CALL cl_err3("upd","smu_file",m_osy_t.osyslip,"",SQLCA.sqlcode,"","UPDATE smu_file",1)  #No.FUN-660155
		       END IF
		    END IF
 
		AFTER FIELD osyauno 
		   IF m_osy[l_ac].osyauno NOT MATCHES '[YN]' THEN
		      NEXT FIELD osyauno
		   END IF
 
	#No.FUN-560060-begin
	#       AFTER FIELD osydmy1 
	#          IF m_osy[l_ac].osydmy1 NOT MATCHES '[12]' THEN
	#             NEXT FIELD osydmy1
	#          END IF
	#No.FUN-560060-end

        #FUN-A10109 add by TSD.lucasyeh---(S)
                AFTER FIELD osytype
                   IF NOT cl_null(m_osy[l_ac].osytype) THEN
                      IF m_osy[l_ac].osytype != m_osy_t.osytype OR
                         cl_null(m_osy[l_ac].osytype)           THEN
                         CALL i010_chk_osytype(p_cmd,l_ac)
                         IF NOT cl_null(g_errno) THEN
                            CALL cl_err('',g_errno,1)
                            NEXT FIELD CURRENT
                         END IF

                      END IF
                   END IF
        #FUN-A10109 add by TSD.lucasyeh---(E)
 

                #FUN-B50039-add-str--
                AFTER FIELD osyud01
                   IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
                AFTER FIELD osyud02
                   IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
                AFTER FIELD osyud03
                   IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
                AFTER FIELD osyud04
                   IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
                AFTER FIELD osyud05
                   IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
                AFTER FIELD osyud06
                   IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
                AFTER FIELD osyud07
                   IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
                AFTER FIELD osyud08
                   IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
                AFTER FIELD osyud09
                   IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
                AFTER FIELD osyud10
                   IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
                AFTER FIELD osyud11
                   IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
                AFTER FIELD osyud12
                   IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
                AFTER FIELD osyud13
                   IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
                AFTER FIELD osyud14
                   IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
                AFTER FIELD osyud15
                   IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
                #FUN-B50039-add-end--


		BEFORE DELETE                            #是否取消單身
		    IF m_osy_t.osyslip IS NOT NULL THEN
			IF NOT cl_delete() THEN
			   ROLLBACK WORK
			   CANCEL DELETE
			END IF
			IF l_lock_sw = "Y" THEN 
			   CALL cl_err("", -263, 1) 
			   CANCEL DELETE 
			END IF 
 
			DELETE FROM osy_file WHERE osyslip = m_osy_t.osyslip
			IF SQLCA.sqlcode THEN
	#                   CALL cl_err(m_osy_t.osyslip,SQLCA.sqlcode,0)   #No.FUN-660155
			    CALL cl_err3("del","osy_file",m_osy_t.osyslip,"",SQLCA.sqlcode,"","",1)  #No.FUN-660155
			    ROLLBACK WORK
			    CANCEL DELETE
			END IF

                        #FUN-A10109  ===S===
                        CALL s_access_doc('r','','',m_osy_t.osyslip,'AXS','')
                        #FUN-A10109  ===E===

			#DELETE FROM smv_file WHERE smv01 = m_osy_t.osyslip AND smv03=g_sys  #NO:6842     #TQC-670008 remark
			DELETE FROM smv_file WHERE smv01 = m_osy_t.osyslip AND upper(smv03)='AXS'         #TQC-670008
			IF SQLCA.sqlcode THEN
	#                   CALL cl_err('smv_file',SQLCA.sqlcode,0)   #No.FUN-660155
			    CALL cl_err3("del","smv_file",m_osy_t.osyslip,g_sys,SQLCA.sqlcode,"","smv_file",1)  #No.FUN-660155
			    ROLLBACK WORK
			    CANCEL DELETE
			END IF
			#DELETE FROM smu_file WHERE smu01 = m_osy_t.osyslip AND smu03=g_sys        #TQC-670008 remark
			DELETE FROM smu_file WHERE smu01 = m_osy_t.osyslip AND upper(smu03)='AXS'  #TQC-670008
			IF SQLCA.sqlcode THEN
	#                   CALL cl_err('smu_file',SQLCA.sqlcode,0)   #No.FUN-660155
			    CALL cl_err3("del","smu_file",m_osy_t.osyslip,g_sys,SQLCA.sqlcode,"","smu_file",1)  #No.FUN-660155
			    ROLLBACK WORK
			    CANCEL DELETE
			END IF
			LET g_rec_b=g_rec_b-1
			DISPLAY g_rec_b TO FORMONLY.cn2  
			MESSAGE "Delete OK"
			CLOSE i010_bcl
			COMMIT WORK
		    END IF
 
	      ON ROW CHANGE
		 IF INT_FLAG THEN                 #900423
		    CALL cl_err('',9001,0)
		    LET INT_FLAG = 0
		    LET m_osy[l_ac].* = m_osy_t.*
		    CLOSE i010_bcl
		    ROLLBACK WORK
		    EXIT INPUT
		 END IF
		 IF l_lock_sw = 'Y' THEN
		     CALL cl_err(m_osy[l_ac].osyslip,-263,1)
		     LET m_osy[l_ac].* = m_osy_t.*
		 ELSE
		     UPDATE osy_file
			SET osyslip = m_osy[l_ac].osyslip,
			    osydesc = m_osy[l_ac].osydesc,
			    osyauno = m_osy[l_ac].osyauno,
			    #osydmy1 = m_osy[l_ac].osydmy1,  #FUN-A10109 mark by TSD.lucasyeh
			    osytype = m_osy[l_ac].osytype,
                            #FUN-B50039-add-str--
                            osyud01 = m_osy[l_ac].osyud01,
                            osyud02 = m_osy[l_ac].osyud02,
                            osyud03 = m_osy[l_ac].osyud03,
                            osyud04 = m_osy[l_ac].osyud04,
                            osyud05 = m_osy[l_ac].osyud05,
                            osyud06 = m_osy[l_ac].osyud06,
                            osyud07 = m_osy[l_ac].osyud07,
                            osyud08 = m_osy[l_ac].osyud08,
                            osyud09 = m_osy[l_ac].osyud09,
                            osyud10 = m_osy[l_ac].osyud10,
                            osyud11 = m_osy[l_ac].osyud11,
                            osyud12 = m_osy[l_ac].osyud12,
                            osyud13 = m_osy[l_ac].osyud13,
                            osyud14 = m_osy[l_ac].osyud14,
                            osyud15 = m_osy[l_ac].osyud15
                            #FUN-B50039-add-end--
			    WHERE CURRENT OF i010_bcl
 
		     IF SQLCA.sqlcode THEN
	#               CALL cl_err(m_osy[l_ac].osyslip,SQLCA.sqlcode,0)   #No.FUN-660155
			CALL cl_err3("upd","osy_file",m_osy[l_ac].osyslip,"",SQLCA.sqlcode,"","",1)  #No.FUN-660155
			LET m_osy[l_ac].* = m_osy_t.*
		     ELSE

                        #FUN-A10109  ===S===
                        CALL s_access_doc('r','','',m_osy_t.osyslip,'AXS','')
                        CALL s_access_doc('a',m_osy[l_ac].osyauno,m_osy[l_ac].osytype,
                                          m_osy[l_ac].osyslip,'AXS','Y')
                        #FUN-A10109 ===E===

			MESSAGE 'UPDATE O.K'
			CLOSE i010_bcl
			COMMIT WORK
		     END IF
		 END IF
 
		AFTER ROW
		    LET l_ac = ARR_CURR()
		    IF INT_FLAG THEN                 #900423
		       CALL cl_err('',9001,0)
		       LET INT_FLAG = 0
		       IF p_cmd = 'u' THEN
			  LET m_osy[l_ac].* = m_osy_t.*
                       #FUN-D30034--add--begin--
                       ELSE
                          CALL m_osy.deleteElement(l_ac)
                          IF g_rec_b != 0 THEN
                             LET g_action_choice = "detail"
                             LET l_ac = l_ac_t
                          END IF
                       #FUN-D30034--add--end----
		       END IF
		       CLOSE i010_bcl
		       ROLLBACK WORK
		       EXIT INPUT
		    END IF
		    LET l_ac_t = l_ac
		    CLOSE i010_bcl
		    COMMIT WORK
 
		ON ACTION user_auth #NO:6842
			    #LET m_osy[l_ac].osyslip=fgl_dialog_getbuffer()  #TQC-670042 modify
			     LET g_action_choice='user_auth' #TQC-670042 add
			     IF NOT cl_null(m_osy[l_ac].osyslip) THEN
				IF cl_chk_act_auth() THEN
				  #CALL s_smu(m_osy[l_ac].osyslip,g_sys)  #TQC-660133 remark 
				   CALL s_smu(m_osy[l_ac].osyslip,"AXS")  #TQC-660133
				END IF
			     ELSE
				CALL cl_err('','anm-217',0)
			     END IF
 
		ON ACTION dept_auth #NO:6842
			    #LET m_osy[l_ac].osyslip=fgl_dialog_getbuffer()  #TQC-670042 modify 
			     LET g_action_choice='dept_auth' #TQC-670042 add
			     IF NOT cl_null(m_osy[l_ac].osyslip) THEN
				IF cl_chk_act_auth() THEN
				  #CALL s_smv(m_osy[l_ac].osyslip,g_sys)  #TQC-660133 remark 
				   CALL s_smv(m_osy[l_ac].osyslip,"AXS")  #TQC-660133
				END IF
			     ELSE
				CALL cl_err('','anm-217',0)
			     END IF
 
	#       ON ACTION CONTROLN
	#           CALL i010_b_askkey()
	#           LET l_exit_sw = "n"
	#           EXIT INPUT
 
		ON ACTION CONTROLO                        #沿用所有欄位
		    IF INFIELD(osyslip) AND l_ac > 1 THEN
			LET m_osy[l_ac].* = m_osy[l_ac-1].*
			DISPLAY m_osy[l_ac].* TO s_osy[l_sl].* 
			NEXT FIELD osyslip
		    END IF
 
		ON ACTION CONTROLR
		    CALL cl_show_req_fields()
 
		ON ACTION CONTROLG
		    CALL cl_cmdask()
 
		ON ACTION CONTROLF
		 CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
		 CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

              #FUN-A10109 add by TSD.lucasyeh---(S)
                ON ACTION CONTROLP
                   CASE
                      WHEN INFIELD(osytype)
                         CALL cl_init_qry_var()
                         LET g_qryparam.form = "q_gee01"
                         LET g_qryparam.where = " gee01 = 'AXS' AND",
                                                " gee04 = 'axsi010'"
                         LET g_qryparam.default1 = m_osy[l_ac].osytype
                         CALL cl_create_qry() RETURNING m_osy[l_ac].osytype
                         DISPLAY BY NAME m_osy[l_ac].osytype
                         NEXT FIELD osytype
                   END CASE
              #FUN-A10109 add by TSD.lucasyeh---(E)
 
		   ON IDLE g_idle_seconds
		      CALL cl_on_idle()
		      CONTINUE INPUT
	 
	      ON ACTION about         #MOD-4C0121
		 CALL cl_about()      #MOD-4C0121
	 
	      ON ACTION help          #MOD-4C0121
		 CALL cl_show_help()  #MOD-4C0121
	 
		
		END INPUT
 
	    CLOSE i010_bcl
	    COMMIT WORK
	END FUNCTION
 
	FUNCTION i010_b_askkey()
	    CLEAR FORM
	    CALL m_osy.clear()
        #FUN-A10109 mod by TSD.lucasyeh---(S)
	#    CONSTRUCT g_wc2 ON osyslip,osydesc,osyauno,osydmy1,osytype
        #		    FROM s_osy[1].osyslip,s_osy[1].osydesc,s_osy[1].osyauno,
	#                      	s_osy[1].osydmy1,s_osy[1].osytype
	    CONSTRUCT g_wc2 ON osyslip,osydesc,osyauno,osytype,
                           #FUN-B50039-add-str--
                            osyud01,osyud02,osyud03,osyud04,
                            osyud05,osyud06,osyud07,osyud08,
                            osyud09,osyud10,osyud11,osyud12,
                            osyud13,osyud14,osyud15
                            #FUN-B50039-add-end--
		    FROM s_osy[1].osyslip,s_osy[1].osydesc,s_osy[1].osyauno,
			 s_osy[1].osytype,
             #FUN-B50039-add-str--
             s_osy[1].osyud01,s_osy[1].osyud02,s_osy[1].osyud03,s_osy[1].osyud04,
             s_osy[1].osyud05,s_osy[1].osyud06,s_osy[1].osyud07,s_osy[1].osyud08,
             s_osy[1].osyud09,s_osy[1].osyud10,s_osy[1].osyud11,s_osy[1].osyud12,
             s_osy[1].osyud13,s_osy[1].osyud14,s_osy[1].osyud15
             #FUN-B50039-add-end--
             #FUN-A10109 mod by TSD.lucasyeh---(E)
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
	#No.TQC-710076 -- begin --
	#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
	   IF INT_FLAG THEN
	      LET INT_FLAG = 0
	      LET g_wc2 = NULL
	      RETURN
	   END IF
	#No.TQC-710076 -- end --
	    CALL i010_b_fill(g_wc2)
	END FUNCTION
 
	FUNCTION i010_b_fill(p_wc2)              #BODY FILL UP
	DEFINE
	    p_wc2   LIKE type_file.chr1000       #No.FUN-680130  VARCHAR(200)
 
	    LET g_sql =
            #FUN-A10109 mod by TSD.lucasyeh---(S)
	#	"SELECT osyslip,osydesc,osyauno,osydmy1,osytype,''",
	#"SELECT osyslip,osydesc,osyauno,osytype,'',",          #FUN-B50039  
                "SELECT osyslip,osydesc,osyauno,osytype,",             #FUN-B50039
                "       osyud01,osyud02,osyud03,osyud04,osyud05,",     #FUN-B50039
                "       osyud06,osyud07,osyud08,osyud09,osyud10,",     #FUN-B50039
                "       osyud11,osyud12,osyud13,osyud14,osyud15 ",     #FUN-B50039
            #FUN-A10109 mod by TSD.lucasyeh---(E)
		" FROM osy_file",
		" WHERE ", p_wc2 CLIPPED,                #單身
		" ORDER BY osytype,osyslip"
	    PREPARE i010_pb FROM g_sql
	    DECLARE osy_curs CURSOR FOR i010_pb
 
	    FOR g_cnt = 1 TO m_osy.getLength()           #單身 ARRAY 乾洗
	       INITIALIZE m_osy[g_cnt].* TO NULL
	    END FOR
	    LET g_cnt = 1
	    MESSAGE "Searching!" 
	    FOREACH osy_curs INTO m_osy[g_cnt].*   #單身 ARRAY 填充
		IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
		LET g_cnt = g_cnt + 1
		IF g_cnt > g_max_rec THEN
		   CALL cl_err( '', 9035, 0 )
		   EXIT FOREACH
		END IF
	    END FOREACH
	    CALL m_osy.deleteElement(g_cnt)
	    MESSAGE ""
	    LET g_rec_b = g_cnt-1
	    DISPLAY g_rec_b TO FORMONLY.cn2  
	    LET g_cnt = 0
 
	END FUNCTION
 
	FUNCTION i010_bp(p_ud)
	   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680130  VARCHAR(1)
 
	   IF p_ud <> "G" OR g_action_choice = "detail" THEN
	      RETURN
	   END IF
 
	   LET g_action_choice = " "
 
	   CALL cl_set_act_visible("accept,cancel", FALSE)
	   DISPLAY ARRAY m_osy TO s_osy.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
	      ON ACTION accept
		 LET g_action_choice="detail"
		 LET l_ac = ARR_CURR()
		 EXIT DISPLAY
 
	      ON ACTION cancel
		     LET INT_FLAG=FALSE 		#MOD-570244	mars
		 LET g_action_choice="exit"
		 EXIT DISPLAY
 
	      ##########################################################################
	      # Special 4ad ACTION
	      ##########################################################################
	      ON ACTION controlg
		 LET g_action_choice="controlg"
		 EXIT DISPLAY
 
	      ON IDLE g_idle_seconds
		 CALL cl_on_idle()
		 CONTINUE DISPLAY
	 
	      ON ACTION about         #MOD-4C0121
		 CALL cl_about()      #MOD-4C0121
	 
	   
	      ON ACTION exporttoexcel       #FUN-4B0025
		 LET g_action_choice = 'exporttoexcel'
		 EXIT DISPLAY
 
	      # No.FUN-530067 --start--
	      AFTER DISPLAY
		 CONTINUE DISPLAY
	      # No.FUN-530067 ---end---
 
 
	   END DISPLAY
	   CALL cl_set_act_visible("accept,cancel", TRUE)
	END FUNCTION
 
	FUNCTION i010_out()
	    DEFINE
		l_osy           RECORD LIKE osy_file.*,
		l_i             LIKE type_file.num5,   #No.FUN-680130  SMALLINT
		l_name          LIKE type_file.chr20,  # External(Disk) file name  #No.FUN-680130  VARCHAR(20)                
		l_za05          LIKE za_file.za05,     # No.FUN-680130  VARCHAR(40)
		l_sql           LIKE type_file.chr1000, # FUN-740015 add
		l_table         STRING                  # FUN-740015 add
            DEFINE sr RECORD
                        osyslip LIKE osy_file.osyslip,
                        osydesc LIKE osy_file.osydesc,
                        osyauno LIKE osy_file.osyauno,
            #            osydmy1 LIKE osy_file.osydmy1,   #FUN-A101009 mark by TSD.lucasyeh
                        osytype LIKE osy_file.osytype
                      END RECORD  
	    IF g_wc2 IS NULL THEN 
	   #   CALL cl_err('',-400,0) 
	       CALL cl_err('','9057',0)
	    RETURN END IF
	    CALL cl_wait()
	    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
	    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   # FUN-740015 add
	   #str FUN-740015 add
	   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> 2007/04/04 TSD.liquor  *** ##
	   LET g_sql  = "osyslip.osy_file.osyslip,",      #單別
			"osydesc.osy_file.osydesc,",      #單據名稱
			"osyauno.osy_file.osyauno,",      #自動編號否
	#		"osydmy1.osy_file.osydmy1,",      #編號方式 #FUN-A10109 mark by TSD.lucasyeh
			"osytype.osy_file.osytype"       #單據性質
 
	   LET l_table = cl_prt_temptable('axsi010',g_sql) CLIPPED   # 產生Temp Table
	   IF l_table = -1 THEN 
              CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
              EXIT PROGRAM 
           END IF                  # Temp Table產生
	#  LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,           #No.TQC-780054
           LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED, #No.TQC-780054
	               " VALUES(?, ?, ?, ?)"  #FUN-A10109 mark ',?' by TSD.lucasyeh
           PREPARE insert_prep FROM g_sql
             IF STATUS THEN
                CALL cl_err('insert_prep:',status,1) 
                CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
                EXIT PROGRAM
             END IF
        #FUN-A10109 mod by TSD.lucasyeh---(S)
        #   LET l_sql = "SELECT osyslip,osydesc,osyauno,osydmy1,osytype", 
           LET l_sql = "SELECT osyslip,osydesc,osyauno,osytype", 
        #FUN-A10109 mod by TSD.lucasyeh---(E)
                       "  FROM osy_file",
                       "    WHERE ",g_wc2," ORDER BY osytype,osyslip"   
           PREPARE i010_prepare1 FROM l_sql
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('prepare:',SQLCA.sqlcode,1) 
              CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
              EXIT PROGRAM
           END IF
           DECLARE i010_cs1 CURSOR FOR i010_prepare1
	   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-720005 *** ##
	   CALL cl_del_data(l_table)
           FOREACH i010_cs1 INTO sr.*

           #FUN-A10109 mod by TSD.lucasyeh---(S)
           #  DISPLAY sr.osyslip,' ',sr.osydesc,' ',sr.osyauno,' ',sr.osydmy1,' ',sr.osytype
             DISPLAY sr.osyslip,' ',sr.osydesc,' ',sr.osyauno,' ',sr.osytype
           #FUN-A10109 mod by TSD.lucasyeh---(E)

             EXECUTE insert_prep USING 
           #FUN-A10109 mod by TSD.lucasyeh---(S)
           #    sr.osyslip,sr.osydesc,sr.osyauno,sr.osydmy1,sr.osytype          
               sr.osyslip,sr.osydesc,sr.osyauno,sr.osytype          
           #FUN-A10109 mod by TSD.lucasyeh---(E)
           END FOREACH
	   LET g_pdate = g_today 
	   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-740015 **** ##
	   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
	   #是否列印選擇條件
	   IF g_zz05 = 'Y' THEN
           #FUN-A10109 mod by TSD.lucasyeh---(S)
	   #   CALL cl_wcchp(g_wc2,'osyslip,osydesc,osyauno,osydmy1,osytype') 
	      CALL cl_wcchp(g_wc2,'osyslip,osydesc,osyauno,osytype') 
           #FUN-A10109 mod by TSD.lucasyeh---(E)
		   RETURNING g_wc2
	      LET g_str = g_wc2
	   END IF
	   CALL cl_prt_cs3('axsi010','axsi010',l_sql,g_str)   
	   #------------------------------ CR (1) ------------------------------#
	   #end FUN-740015 add
 
	END FUNCTION
	#No.FUN-570110--begin
	FUNCTION i010_set_entry_b(p_cmd)
	  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680130  VARCHAR(01)
 
	   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
	     CALL cl_set_comp_entry("osyslip",TRUE)
	   END IF
	END FUNCTION
 
	FUNCTION i010_set_no_entry_b(p_cmd)
	  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680130  VARCHAR(01)
 
	   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
	     CALL cl_set_comp_entry("osyslip",FALSE)
	   END IF
	END FUNCTION
	#No.FUN-570110--end
 
#FUN-A10109 add by TSD.lucasyeh---(S)
#單別型態
FUNCTION i010_chk_osytype(p_cmd,p_ac)
DEFINE p_cmd                     LIKE type_file.chr1,
       p_ac                      LIKE type_file.num5
DEFINE l_gee01                   LIKE gee_file.gee01,
       l_gee02                   LIKE gee_file.gee02,
       l_geeacti                 LIKE gee_file.geeacti

   SELECT geeacti INTO l_geeacti FROM gee_file
    WHERE gee01 = 'AXS'  AND gee02 = m_osy[p_ac].osytype
      AND gee03 = g_lang AND gee04 = 'axsi010'

   CASE
      WHEN l_geeacti = 'N'
         LET g_errno = 'aap991'
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE

END FUNCTION
#FUN-A10109 add by TSD.lucasyeh---(E)
#FUN-B90041
