# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmp812.4gl
# Descriptions...: 多角代採買採購單結案/開放作業
# Date & Author..: FUN-670007 06/10/14 BY Yiting
# Modify.........: No.FUN-710030 07/02/05 By johnray 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-820053 08/06/25 By xiaofeizhu 在結案時或者在取消結案時所有拋轉的訂單、采購單皆需一并結案或取消結案
# Modify.........: No.TQC-870039 08/07/28 By chenyu 剛進程序的時候點"單身"會出現死循環的情況
# Modify.........: No.FUN-870152 08/07/29 By xiaofeizhu 在update oeb_file的時候需要同時update　oeb70d，oeb26,oeb905
# Modify.........: No.MOD-870321 08/07/31 By (1)claire 非一單到底設定,下站PO不會被結案
#                                            (2)單身有多筆資料時, 若只結一筆, 應可以於apmp813查出該筆資料
#                                            (3)單頭的採購單不可包含銷售流程所產生的採購單
# Modify.........: No.MOD-880159 08/08/20 By claire 非一單到底設定,整張po結案,最終站so只有最後一項次被結案
# Modify.........: No.TQC-950010 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring() 
# Modify.........: No.MOD-960260 09/06/26 By Dido 取消結案時單身若多筆,同張採購單單頭會呈現多筆
# Modify.........: No.CHI-960042 09/07/08 By Dido 若已存在於收貨(正拋)或出貨(逆拋)時應不可結案
# Modify.........: No.TQC-980178 09/08/21 By sherry 勾選結案鈕后,程式自動關閉   
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/18 By TSD.sar2436  GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-9C0071 09/12/16 By huangrh  精簡程式
# Modify.........: No:TQC-A30043 10/03/09 By Carrier apmp812时开窗过滤已结案PO;apmp813时开窗过滤未结案PO
# Modify.........: No.FUN-A50102 10/07/15 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.MOD-C20011 12/02/03 By Vampire 在別站產生訂單，此訂單的單身項次都已"結案"但是單頭卻沒有做結案的動作
# Modify.........: No.MOD-C20158 12/02/24 By Vampire 調整有可能會沒有訂單的情況
# Modify.........: No.MOD-C30866 12/03/27 By Vampire Table應為pmm_file
# Modify.........: No.MOD-C40048 12/04/09 By ck2yuan 呼叫p812_sta 應傳l_no 非l_cnt
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_up    LIKE type_file.chr1000         
DEFINE g_pmm   DYNAMIC ARRAY OF RECORD        # 採購單
               pmm01    LIKE pmm_file.pmm01,  #FUN-670007
               pmm04    LIKE pmm_file.pmm04,
               pmm09    LIKE pmm_file.pmm09,
               pmc03a   LIKE pmc_file.pmc03,
               pmm50    LIKE pmm_file.pmm50,
               pmc03b   LIKE pmc_file.pmc03,
               pmm12    LIKE pmm_file.pmm12,
               gen02    LIKE gen_file.gen02,
               pmm904   LIKE pmm_file.pmm904,
               pmm18    LIKE pmm_file.pmm18,
               pmm905   LIKE pmm_file.pmm905
               END RECORD,
       g_pmn   DYNAMIC ARRAY OF RECORD
               sure     LIKE type_file.chr1000,                 # 確定否
               pmn02    LIKE pmn_file.pmn02,     # 項次
               pmn04    LIKE pmn_file.pmn04,     # 料號
               pmn16    LIKE type_file.chr1000,                # 目前狀況
               qty      LIKE type_file.num20_6,                # 未移轉數量
               pmn20    LIKE pmn_file.pmn20,
               pmn50    LIKE pmn_file.pmn50,
               pmn55    LIKE pmn_file.pmn55,
               pmn58    LIKE pmn_file.pmn58
               END RECORD,
       g_wc2,g_sql    STRING,
       g_rec_b        LIKE type_file.num5,
       g_rec_b1       LIKE type_file.num5,
       l_ac,l_ac_b    LIKE type_file.num5
DEFINE p_row,p_col    LIKE type_file.num5
DEFINE g_cnt,l_cnt    LIKE type_file.num5 
DEFINE l_cnt2,l_cnt3  LIKE type_file.num5
DEFINE l_i,l_j        LIKE type_file.num5
DEFINE l_flag         LIKE type_file.chr1000
DEFINE g_poy          RECORD LIKE poy_file.*    #流程代碼資料(單身) No.8083
DEFINE p_last         LIKE type_file.num5                #流程之最后家數
DEFINE p_last_plant   LIKE type_file.chr1000
DEFINE p_first_plant  LIKE type_file.chr1000
DEFINE l_dbs_new      LIKE type_file.chr1000    #New DataBase Name
DEFINE l_sql          STRING            # RDSQL STATEMENT 
DEFINE l_azp          RECORD LIKE azp_file.*
DEFINE g_pmm99        LIKE pmm_file.pmm99      #多角流程序號
DEFINE i              LIKE type_file.num5 
DEFINE g_argv1        LIKE type_file.chr1,
       l_update_sw    LIKE type_file.chr1
DEFINE g_poz          RECORD LIKE poz_file.*   #流程代碼資料(單頭) #CHI-960042
DEFINE l_dbs_tra      LIKE azw_file.azw05  #FUN-980092 add 
DEFINE l_dbs_plnat    LIKE azp_file.azp01  #FUN-A50102 
DEFINE l_plant_new    LIKE azp_file.azp01  #FUN-980092 add 
 
FUNCTION p812(p_argv1)
DEFINE p_argv1        LIKE type_file.chr1  
 
   LET p_row = 2 LET p_col = 3
   OPEN WINDOW p812_w AT p_row,p_col WITH FORM "apm/42f/apmp812"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   LET g_argv1 = p_argv1
 
   CREATE TEMP TABLE p812_tmp(
      pmn02   LIKE type_file.num5);
 
   DELETE FROM p812_tmp
   CALL p812_menu()
END FUNCTION
 
FUNCTION p812_menu()
   WHILE TRUE
      CALL p812_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p812_q()
            END IF
         WHEN "detail"  
            IF cl_chk_act_auth() THEN
               IF cl_null(g_rec_b1) OR g_rec_b1=0 THEN
                  CONTINUE WHILE
               END IF
               LET g_success='Y'
               WHILE TRUE
                 IF g_argv1 = '1' THEN           #結案
                     IF g_rec_b1> 0 THEN
                          CALL p812_sure()       #確定否
                          IF INT_FLAG THEN
                              LET INT_FLAG = 0
                              EXIT WHILE
                          END IF
                          IF cl_sure(0,0) THEN
                             BEGIN WORK
                             LET g_success='Y'
                             CALL cl_wait()
                             CALL p812_b3_fill()                           #FUN-820053
                             CALL p812_p() 
                             CALL p812_bp2()                               #FUN-820053  
                             #採購單頭結案碼亦要更新
                             CALL s_showmsg()		#CHI-960042
                             IF g_success = 'Y' THEN
                                CALL cl_cmmsg(1) COMMIT WORK
                             ELSE
                                CALL cl_rbmsg(1) ROLLBACK WORK
                             END IF
                             DELETE FROM p812_tmp
                             CALL p812_b2_fill()	#MOD-960260 
                             CALL p812_bp2()	        #MOD-960260
                          END IF
                     ELSE		#MOD-960260
                          EXIT WHILE    #MOD-960260
                     END IF
                 ELSE
                     IF g_rec_b1> 0 THEN
                          CALL p812_sure()       #確定否
                          IF INT_FLAG THEN
                              LET INT_FLAG = 0
                              EXIT WHILE
                          END IF
                          IF cl_sure(0,0) THEN
                             BEGIN WORK
                             LET g_success='Y'
                             CALL cl_wait()
                             CALL p812_b3_fill()                           #FUN-820053
                             CALL p812_z() 
                             CALL p812_bp2()                               #FUN-820053
                             #採購單頭結案碼亦要更新
                             CALL s_showmsg()		#CHI-960042
                             IF g_success = 'Y' THEN
                                CALL cl_cmmsg(1) COMMIT WORK
                             ELSE
                                CALL cl_rbmsg(1) ROLLBACK WORK
                             END IF
                             DELETE FROM p812_tmp
                             CALL p812_b2_fill()	#MOD-960260 
                             CALL p812_bp2()	        #MOD-960260
                          END IF
                     ELSE		#MOD-960260
                          EXIT WHILE    #MOD-960260
                     END IF
                 END IF
               END WHILE
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
 
FUNCTION p812_q()
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_pmm.clear()
    DISPLAY '   ' TO FORMONLY.cn3
    DISPLAY '   ' TO FORMONLY.cn2
    CALL p812_b_askkey() 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
END FUNCTION
 
FUNCTION p812_b_askkey()
 
   CLEAR FORM
   CALL g_pmm.clear()
 
   CONSTRUCT g_wc2 ON pmm01,pmm04,pmm09,pmm50,pmm12,
                      pmm904,pmm18,pmm905 
                 FROM s_pmm[1].pmm01,s_pmm[1].pmm04,s_pmm[1].pmm09,
                      s_pmm[1].pmm50,s_pmm[1].pmm12,s_pmm[1].pmm904,
                      s_pmm[1].pmm18,s_pmm[1].pmm905
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
           CASE
              WHEN INFIELD(pmm01)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pmm01"
                   #No.TQC-A30043  --Begin                                      
                   IF g_argv1 = '1' THEN    #结案                               
                      LET g_qryparam.where = " pmn16 NOT IN ('6','7','8') "     
                   ELSE                                                         
                      LET g_qryparam.where = " pmn16 IN ('6','7','8') "         
                   END IF                                                       
                   #No.TQC-A30043  --End   
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmm01
                   NEXT FIELD pmm01
 
              WHEN INFIELD(pmm09)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pmc2"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmm09
                   NEXT FIELD pmm09
 
              WHEN INFIELD(pmm50)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pmc2"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmm50
                   NEXT FIELD pmm50
 
              WHEN INFIELD(pmm12)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmm12
                   NEXT FIELD pmm12
 
              WHEN INFIELD(pmm904)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_poz"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmm904
                   NEXT FIELD pmm904
 
              OTHERWISE EXIT CASE
           END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
   END CONSTRUCT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   #資料權限的檢查
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
 
   CALL p812_b_fill_pmm(g_wc2)
 
   LET l_ac = 1
   
END FUNCTION
 
# 採購單
FUNCTION p812_b_fill_pmm(p_wc2)
   DEFINE p_wc2 STRING
  
   IF g_argv1 = '1' THEN    #結案
       LET g_sql = "SELECT pmm01,pmm04,pmm09,'',pmm50,'', ",
                   "       pmm12,'',pmm904,pmm18,pmm905,pmm99 ",
                   "  FROM pmm_file",
                   " WHERE pmm901 = 'Y' AND pmm02= 'TAP' ",   #MOD-870321 
                   "   AND pmm25 != '6'",
                   "   AND pmm18 = 'Y' ",
                   "   AND pmm905 = 'Y'",
                   "  AND ",p_wc2 CLIPPED,
                   " ORDER BY pmm01,pmm04 "
   ELSE                    #開放
       LET g_sql = "SELECT UNIQUE pmm01,pmm04,pmm09,'',pmm50,'', ",	#MOD-960260
                   "       pmm12,'',pmm904,pmm18,pmm905,pmm99 ",
                   "  FROM pmm_file,pmn_file",  #MOD-870321 add pmn01
                   " WHERE pmm901 = 'Y' AND pmm02= 'TAP' ",   #MOD-870321 
                   "   AND pmm18 = 'Y' ",
                   "   AND pmm905 = 'Y'",
                   "   AND pmm01 = pmn01 ",
                   "   AND (pmn16 = '6' OR pmn16 = '7' OR pmn16 = '8') ",  #MOD-870321 add
                   "  AND ",p_wc2 CLIPPED,
                   " ORDER BY pmm01,pmm04 "
   END IF
   PREPARE p812_pb FROM g_sql
   DECLARE pmm_curs CURSOR FOR p812_pb
  
   CALL g_pmm.clear()
  
   LET g_rec_b = 0
   LET g_cnt = 1 
   FOREACH pmm_curs INTO g_pmm[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)
         EXIT FOREACH
      END IF
      # 廠商簡稱
      SELECT pmc03 INTO g_pmm[g_cnt].pmc03a FROM pmc_file
       WHERE pmc01 = g_pmm[g_cnt].pmm09
      # 最終供應商簡稱
      SELECT pmc03 INTO g_pmm[g_cnt].pmc03b FROM pmc_file
       WHERE pmc01 = g_pmm[g_cnt].pmm50
      # 採購員姓名
      SELECT gen02 INTO g_pmm[g_cnt].gen02 FROM gen_file
       WHERE gen01 = g_pmm[g_cnt].pmm12
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
 
   END FOREACH
   CALL g_pmm.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p812_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1000
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_pmm TO s_pmm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         IF l_ac <> 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF l_ac != 0 THEN
             CALL p812_b2_fill()
             CALL p812_bp2()
         END IF
         CALL cl_show_fld_cont()                   #No.FUN-590083 
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail    
         LET g_action_choice="detail"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION p812_bp2()
 
   DISPLAY ARRAY g_pmn TO s_pmn.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
 
      BEFORE DISPLAY
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help    
         CALL cl_show_help()
 
      ON ACTION controlg 
         CALL cl_cmdask()
 
   END DISPLAY
 
END FUNCTION
 
FUNCTION p812_b2_fill()
DEFINE
     l_pmn50       LIKE pmn_file.pmn20,
     l_pmn011      LIKE pmn_file.pmn011,
     l_pmn41       LIKE pmn_file.pmn41,
     l_pmn55       LIKE pmn_file.pmn55,
     l_pmm18       LIKE pmm_file.pmm18,
     l_pmmmksg     LIKE pmm_file.pmmmksg,
     l_wc          LIKE type_file.chr1000,         # RDSQL STATEMENT
     g_sta         LIKE type_file.chr1000
 
    CALL g_pmn.clear()
#超短交量=pmn50-pmn20-pmn55
   IF g_argv1 = '1' THEN    #結案
       LET l_sql = " SELECT 'N',pmn02,pmn04,pmn16,",
                   " (pmn50-pmn20-pmn55),",
                   "  pmn20,pmn50,pmn55,pmn58, ",
                   "  pmn011,pmn41,pmm18,pmmmksg ",
                   "  FROM pmn_file,pmm_file",
                   " WHERE pmn51 <= 0 AND pmn011 !='SUB' AND pmn01=pmm01",
                   "  AND pmn01 = '",g_pmm[l_ac].pmm01,"' AND pmn16 !='9' ",
                   "  AND pmn16 NOT IN ('6','7','8','9') ",
                   "  ORDER BY pmn02 "
   ELSE                      #開放
       LET l_sql = " SELECT 'N',pmn02,pmn04,pmn16,",
                   " (pmn50-pmn20-pmn55),",
                   "  pmn20,pmn50,pmn55,pmn58, ",
                   "  pmn011,pmn41,pmm18,pmmmksg ",
                   "  FROM pmn_file,pmm_file",
                   " WHERE pmn51 <= 0 AND pmn011 !='SUB' AND pmn01=pmm01",
                   "  AND pmn01 = '",g_pmm[l_ac].pmm01,"' AND pmn16 !='9' ",
                   "  AND pmn16 IN ('6','7','8') ",
                   "  ORDER BY pmn02 "
   END IF 
   LET l_sql = l_sql clipped,l_wc clipped
 
   PREPARE p812_prepare FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('cannot perpare ',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
 
   DECLARE p812_cur CURSOR FOR p812_prepare
   IF SQLCA.sqlcode THEN
      CALL cl_err('cannot declare ',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
 
   LET l_ac_b = 1
   LET g_rec_b1 = 0
 
   FOREACH p812_cur INTO g_pmn[l_ac_b].*,l_pmn011,l_pmn41,l_pmm18,l_pmmmksg
      IF SQLCA.sqlcode THEN
         CALL cl_err('cannot foreach ',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      CALL s_pmmsta('pmm',g_pmn[l_ac_b].pmn16,l_pmm18,l_pmmmksg)
           RETURNING g_pmn[l_ac_b].pmn16
      LET l_ac_b = l_ac_b + 1
 
      IF l_ac_b > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_pmn.deleteElement(l_ac_b)
 
   LET g_rec_b1 = l_ac_b - 1
   DISPLAY g_rec_b1 TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION p812_b3_fill()                                                                                                             
DEFINE                                                                                                                              
       l_pmn50         LIKE pmn_file.pmn20,                                                                                         
       l_pmn011        LIKE pmn_file.pmn011,                                                                                        
       l_pmn41         LIKE pmn_file.pmn41,                                                                                         
       l_pmn55         LIKE pmn_file.pmn55,                                                                                         
       l_pmm18         LIKE pmm_file.pmm18,                                                                                         
       l_pmmmksg       LIKE pmm_file.pmmmksg,                                                                                       
       l_wc            LIKE type_file.chr1000,         # RDSQL STATEMENT                                                            
       g_sta           LIKE type_file.chr1000                                                                                       
DEFINE g_pmn_t DYNAMIC ARRAY OF RECORD                                                                                              
               sure    LIKE type_file.chr1000,                                                                                      
               pmn02   LIKE pmn_file.pmn02,                                                                                         
               pmn04   LIKE pmn_file.pmn04,                                                                                         
               pmn16   LIKE type_file.chr1000,                                                                                      
               qty     LIKE type_file.num20_6,                                                                                      
               pmn20   LIKE pmn_file.pmn20,                                                                                         
               pmn50   LIKE pmn_file.pmn50,                                                                                         
               pmn55   LIKE pmn_file.pmn55,                                                                                         
               pmn58   LIKE pmn_file.pmn58                                                                                          
               END RECORD
                                                                                                                                    
   FOR l_ac_b=1 TO g_rec_b1                                                                                                         
      IF g_argv1 = '1' THEN                                                                                                         
        IF g_pmn[l_ac_b].sure = 'Y' THEN                                                                                            
          LET g_pmn_t[l_ac_b].sure = 'Y'                                                                                            
          LET g_pmn_t[l_ac_b].pmn16 = '8'                                                                                           
        ELSE                                                                                                                        
          LET g_pmn_t[l_ac_b].sure = 'N'                                                                                            
          LET g_pmn_t[l_ac_b].pmn16 = '2'                                                                                           
        END IF                                                                                                                      
      ELSE                                                                                                                          
        IF g_pmn[l_ac_b].sure = 'Y' THEN                                                                                            
          LET g_pmn_t[l_ac_b].sure = 'Y'                                                                                            
          LET g_pmn_t[l_ac_b].pmn16 = '2'                                                                                           
        ELSE                                                                                                                        
          LET g_pmn_t[l_ac_b].sure = 'N'                                                                                            
          LET g_pmn_t[l_ac_b].pmn16 = '8'                                                                                           
        END IF                                                                                                                      
      END IF                                                                                                                        
   END FOR                                                                                                                          
                                                                                                                                    
   CALL g_pmn.clear()
                                                                                                                                    
   IF g_argv1 = '1' THEN                                                                                                            
       LET l_sql = " SELECT '',pmn02,pmn04,'',",                                                                                    
                   " (pmn50-pmn20-pmn55),",                                                                                         
                   "  pmn20,pmn50,pmn55,pmn58, ",                                                                                   
                   "  pmn011,pmn41,pmm18,pmmmksg ",                                                                                 
                   "  FROM pmn_file,pmm_file",                                                                                      
                   " WHERE pmn51 <= 0 AND pmn011 !='SUB' AND pmn01=pmm01",       
                   "  AND pmn01 = '",g_pmm[l_ac].pmm01,"' AND pmn16 !='9' ",                                                        
                   "  AND pmn16 NOT IN ('6','7','8','9') ",                                                   
                   "  ORDER BY pmn02 "                                                                                              
   ELSE                                                                                                                             
       LET l_sql = " SELECT '',pmn02,pmn04,'',",                                                                                    
                   " (pmn50-pmn20-pmn55),",                                                                                         
                   "  pmn20,pmn50,pmn55,pmn58, ",                                                                                   
                   "  pmn011,pmn41,pmm18,pmmmksg ",                                                                                 
                   "  FROM pmn_file,pmm_file",                                                                                      
                   " WHERE pmn51 <= 0 AND pmn011 !='SUB' AND pmn01=pmm01",                                                          
                   "  AND pmn01 = '",g_pmm[l_ac].pmm01,"' AND pmn16 !='9' ",                                                        
                   "  AND pmn16 IN ('6','7','8') ",                                                                                  
                   "  ORDER BY pmn02 "                                                                                              
   END IF                                                                                                                           
   LET l_sql = l_sql clipped,l_wc clipped
                                                                                                                                    
   PREPARE p812_prepare1 FROM l_sql                                                                                                 
   IF SQLCA.sqlcode THEN                                                                                                            
      CALL cl_err('cannot perpare ',SQLCA.sqlcode,1)                                                                                
      LET g_success = 'N'                                                                                                           
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   DECLARE p812_cur1 CURSOR FOR p812_prepare1                                                                                       
   IF SQLCA.sqlcode THEN                                                                                                            
      CALL cl_err('cannot declare ',SQLCA.sqlcode,1)                                                                                
      LET g_success = 'N'                                                                                                           
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   LET l_ac_b = 1                                                                                                                   
   LET g_rec_b1 = 0                                                                                                                 
                                                                                                                                    
   FOREACH p812_cur1 INTO g_pmn[l_ac_b].*,l_pmn011,l_pmn41,l_pmm18,l_pmmmksg                                                        
      IF SQLCA.sqlcode THEN                                                                                                         
         CALL cl_err('cannot foreach ',SQLCA.sqlcode,1)                                                                             
         LET g_success = 'N'
         EXIT FOREACH                                                                                                               
      END IF                                                                                                                        
                                                                                                                                    
      LET g_pmn[l_ac_b].sure = g_pmn_t[l_ac_b].sure                                                                                 
      LET g_pmn[l_ac_b].pmn16 = g_pmn_t[l_ac_b].pmn16                                                                               
                                                                                                                                    
      CALL s_pmmsta('pmm',g_pmn[l_ac_b].pmn16,l_pmm18,l_pmmmksg)                                                                    
           RETURNING g_pmn[l_ac_b].pmn16                                                                                            
      LET l_ac_b = l_ac_b + 1                                                                                                       
                                                                                                                                    
      IF l_ac_b > g_max_rec THEN                                                                                                    
         CALL cl_err( '', 9035, 0 )                                                                                                 
         EXIT FOREACH                                                                                                               
      END IF                                                                                                                        
   END FOREACH                                                                                                                      
   CALL g_pmn.deleteElement(l_ac_b)                                                                                                 
                                                                                                                                    
   LET g_rec_b1 = l_ac_b - 1                                                                                                        
   DISPLAY g_rec_b1 TO FORMONLY.cn2                                                                                                 
                                                                                                                                    
END FUNCTION                                                                                                                        
 
FUNCTION p812_sure()
    DEFINE l_cnt,l_i        LIKE type_file.num5
    DEFINE l_ac_b           LIKE type_file.num5,
           l_allow_insert   LIKE type_file.num5,              #可新增否
           l_allow_delete   LIKE type_file.num5
    DEFINE l_c              LIKE type_file.num5
 
    IF cl_null(g_pmm[l_ac].pmm01) THEN
       CALL cl_err('',-400,0)
       LET g_success='N' 
       RETURN
    END IF 
 
    LET l_allow_insert = FALSE
    LET l_allow_delete = FALSE
 
    LET l_ac_b = 1
    INPUT ARRAY g_pmn WITHOUT DEFAULTS FROM s_pmn.*
       ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
          IF g_rec_b1 != 0 THEN
             CALL fgl_set_arr_curr(l_ac_b)
          END IF
 
       BEFORE ROW
          LET l_ac_b = ARR_CURR()
 
       AFTER FIELD sure
          IF NOT cl_null(g_pmn[l_ac_b].sure) THEN
             IF g_pmn[l_ac_b].sure NOT MATCHES "[YN]" THEN
                NEXT FIELD sure
             END IF
          END IF
 
       ON ACTION select_all
          FOR l_i = 1 TO g_rec_b1     #將所有的設為選擇
              LET g_pmn[l_i].sure="Y"
          END FOR
          LET l_cnt = g_rec_b1
          DISPLAY g_rec_b1 TO FORMONLY.cn3
 
       ON ACTION cancel_all
          FOR l_i = 1 TO g_rec_b1      #將所有的設為取消
              LET g_pmn[l_i].sure="N"
          END FOR
          LET l_cnt = 0
          DISPLAY 0 TO FORMONLY.cn3
 
       AFTER ROW
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
       AFTER INPUT
          LET l_cnt = 0
          FOR l_i =1 TO g_rec_b1
             IF g_pmn[l_i].sure = 'Y' AND
                NOT cl_null(g_pmn[l_i].pmn02)  THEN
                LET l_cnt = l_cnt + 1
                SELECT COUNT(*) INTO l_c FROM p812_tmp
                 WHERE pmn02 = g_pmn[l_i].pmn02
                IF l_c = 0 THEN
                    INSERT INTO p812_tmp VALUES(g_pmn[l_i].pmn02)
                END IF
             END IF
          END FOR
          DISPLAY l_cnt TO FORMONLY.cn3
 
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END INPUT
 
END FUNCTION
 
FUNCTION p812_hu(l_pmm99,l_cnt1)
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_cnt1    LIKE type_file.num5
   DEFINE l_pmm99   LIKE pmm_file.pmm99
   DEFINE l_i       LIKE type_file.num5
   DEFINE l_pmm01   LIKE pmm_file.pmm01
   DEFINE l_pmn16_cnt LIKE type_file.num5
 
      LET l_pmn16_cnt = 0
     #LET l_sql = "SELECT pmm01 FROM ",l_dbs_tra CLIPPED,"pmm_file ", #FUN-980092 add    #FUN-A50102 mark
      LET l_sql = "SELECT pmm01 FROM ",cl_get_target_table(l_plant_new,'pmm_file'),      #FUN-A50102
                  " WHERE pmm99 = '",l_pmm99,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
      PREPARE p812_99_p FROM l_sql 
      IF SQLCA.SQLCODE THEN
         CALL cl_err('p812_99',SQLCA.SQLCODE,1)
      END IF
      DECLARE p812_99_c CURSOR FOR p812_99_p
      OPEN p812_99_c
      FETCH p812_99_c INTO l_pmm01   #採購單號
 
      LET l_cnt = 0
      #-----該張採購單單身筆數----
     #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs_tra CLIPPED," pmn_file ",  #FUN-980092 add    #FUN-A50102 mark
      LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'pmn_file'),        #FUN-A50102
                  " WHERE pmn01 = '",l_pmm01,"'" 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
      PREPARE p812_cnt_p FROM l_sql 
      IF SQLCA.SQLCODE THEN
         CALL cl_err('p812_cnt',SQLCA.SQLCODE,1)
      END IF
      DECLARE p812_cnt_c CURSOR FOR p812_cnt_p
      OPEN p812_cnt_c
      FETCH p812_cnt_c INTO l_cnt
 
      #該張採購單身己結案筆數
      #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs_new CLIPPED," pmn_file ", #FUN-980092 mark
     #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs_tra CLIPPED," pmn_file ",  #FUN-980092 add   #FUN-A50102 mark
      LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'pmn_file'),       #FUN-A50102    
                  " WHERE pmn01 = '",l_pmm01,"'", 
                  "   AND pmn16 IN ('6','7','8')"
                  
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
      PREPARE p812_cnt_p1 FROM l_sql 
      IF SQLCA.SQLCODE THEN
         CALL cl_err('p812_cnt',SQLCA.SQLCODE,1)
      END IF
      DECLARE p812_cnt_c1 CURSOR FOR p812_cnt_p1
      OPEN p812_cnt_c1
      FETCH p812_cnt_c1 INTO l_pmn16_cnt
 
      IF l_cnt = l_cnt1 OR l_pmn16_cnt = l_cnt THEN
          #LET l_sql= "UPDATE ",l_dbs_new CLIPPED,"pmm_file ",  #FUN-980092 mark
         #LET l_sql= "UPDATE ",l_dbs_tra CLIPPED,"pmm_file ",   #FUN-980092 add    #FUN-A50102 mark
          LET l_sql= "UPDATE ",cl_get_target_table(l_plant_new,'pmm_file'),        #FUN-A50102
                     "   SET pmm25 = '6',pmm27 = '",g_today,"'",
                     " WHERE pmm01 = '",l_pmm01,"'" 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
          PREPARE upd_pmn25 FROM l_sql
          EXECUTE upd_pmn25
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             LET g_success='N'
             CALL cl_err3("upd","pmm_file",g_pmm[l_ac].pmm01,"",SQLCA.sqlcode,"","(p812_hu)",1)  #No.FUN-660129
          END IF
      END IF
END FUNCTION
 
FUNCTION p812_p()
DEFINE
     l_pmn20       LIKE pmn_file.pmn20,
     l_pmn09       LIKE pmn_file.pmn09,
     l_pmn50       LIKE pmn_file.pmn20,
     l_pmn011      LIKE pmn_file.pmn011,
     l_pmn41       LIKE pmn_file.pmn41,
     l_pmn55       LIKE pmn_file.pmn55,
     l_wc          LIKE type_file.chr1000,         # RDSQL STATEMENT
     l_sql         STRING,         # RDSQL STATEMENT
     l_cnt         LIKE type_file.num5,
     g_sta         LIKE type_file.chr1000,
     l_pmn         RECORD LIKE pmn_file.*,
     l_pmm         RECORD LIKE pmm_file.*,
     l_oea         RECORD LIKE oea_file.*,         #MOD-870321  add
     l_pmm99       LIKE pmm_file.pmm99,
     l_poy04_s     LIKE poy_file.poy04,
     i,j           LIKE type_file.num5,
     l_cnt1        LIKE type_file.num5,
     l_pmn02       LIKE pmn_file.pmn02,
     l_update_sw   LIKE type_file.chr1,
     l_no          LIKE type_file.num5
DEFINE l_oeb       RECORD LIKE oeb_file.*           #FUN-870152       
DEFINE l_azp03_s   LIKE azp_file.azp03              #CHI-960042
DEFINE l_azp03_e   LIKE azp_file.azp03              #CHI-960042
DEFINE l_azp03_s_tra LIKE azw_file.azw05    #FUN-980092 add
DEFINE l_azp03_e_tra LIKE azw_file.azw05    #FUN-980092 add
DEFINE l_plant_new_s LIKE azp_file.azp01    #FUN-980092 add
DEFINE l_plant_new_e LIKE azp_file.azp01    #FUN-980092 add
 
     SELECT pmm99 INTO l_pmm99 
       FROM pmm_file
      WHERE pmm01= g_pmm[l_ac].pmm01
 
     SELECT * INTO g_poz.* FROM poz_file
      WHERE poz01=g_pmm[l_ac].pmm904 AND poz00='2'
     IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","poz_file",g_pmm[l_ac].pmm904,"","axm-318","","",1)  #No.FUN-660129
         LET g_success = 'N'
         RETURN
     END IF
 
     CALL s_mtrade_last_plant(g_pmm[l_ac].pmm904)
           RETURNING p_last,p_last_plant
     IF NOT cl_null(p_last) THEN         #有最後一站站別資料
         #找出起始站別工廠
         SELECT poy04 INTO l_poy04_s  
           FROM poy_file
          WHERE poy01 = g_pmm[l_ac].pmm904
            AND poy02 = '0'
         LET p_first_plant = l_poy04_s
         IF p_first_plant != g_plant THEN    #只能從起始站做結案動作
             CALL cl_err('','apm-012',1)
             LET g_success = 'N' 
             RETURN
         END IF
         LET l_azp03_s = s_getdbs_curr(l_poy04_s)	#CHI-960042
          LET g_plant_new = l_poy04_s                 
          LET l_plant_new_s = g_plant_new         
          CALL s_gettrandbs()                      
          LET l_azp03_s_tra = g_dbs_tra             
         LET l_azp03_e = s_getdbs_curr(p_last_plant)	#CHI-960042
          LET g_plant_new = p_last_plant         
          LET l_plant_new_e = g_plant_new         
          CALL s_gettrandbs()                      
          LET l_azp03_e_tra = g_dbs_tra              
         CALL s_showmsg_init()        #No.FUN-710030
         FOR i = 0 TO p_last    
            IF g_success="N" THEN
               LET g_totsuccess="N"
               LET g_success="Y"
            END IF
             CALL p812_azp(i)
             #----最後一站有最終供應商才需UPDATE採購單-----
             IF i <> p_last OR ( i = p_last AND NOT cl_null(g_pmm[l_ac].pmm50)) THEN   
                 LET l_cnt = 1
                 FOR l_no = 1 TO g_rec_b1
                     IF g_pmn[l_no].sure = 'Y' THEN
                        IF g_poz.poz011 = '1' THEN
                           LET l_cnt = 0
                           LET l_sql = " SELECT COUNT(*) ",
                                     # " FROM ",l_azp03_s_tra CLIPPED,"rva_file, ",l_azp03_s_tra CLIPPED,"rvb_file ",  #FUN-980092 add   #FUN-A50102 mark
                                       " FROM ",cl_get_target_table(l_poy04_s ,'rva_file'),",",                        #FUN-A50102 
                                                cl_get_target_table(l_poy04_s ,'rvb_file'),                            #FUN-A50102
                                       " WHERE rva01 = rvb01 AND rvaconf = 'N' AND rvb04 = '",g_pmm[l_ac].pmm01,"' ", 
                                       "   AND rvb03 = '",g_pmn[l_no].pmn02,"'"
                           CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                           CALL cl_parse_qry_sql(l_sql,l_plant_new_s) RETURNING l_sql #FUN-980092     
                           PREPARE p812_rva_p FROM l_sql 
                           IF SQLCA.SQLCODE THEN
                              CALL cl_err('p812_rva',SQLCA.SQLCODE,1)
                           END IF
                           DECLARE p812_rva_c CURSOR FOR p812_rva_p
                           OPEN p812_rva_c
                           FETCH p812_rva_c INTO l_cnt
                           IF l_cnt > 0 THEN
                              LET g_success = 'N'
                              IF g_bgerr THEN
                                 #CALL s_errmsg('pmn02',g_pmn[l_no].pmn02,l_azp03_s,'apm-949',1)  #FUN-980092 mark
                                  CALL s_errmsg('pmn02',g_pmn[l_no].pmn02,l_azp03_s_tra,'apm-949',1) #FUN-980092 add 
                                 CONTINUE FOR
                              ELSE
                                 CALL cl_err3("","","apm-949","",SQLCA.sqlcode,"",l_azp03_s CLIPPED,1)   
                                 RETURN
                              END IF
                           ELSE                #TQC-980178 add                                                                      
                              LET l_cnt = 1    #TQC-980178 add    
                           END IF
                        END IF 
                     #------抓出每站工廠採購單資料------#
                        #LET l_sql ="SELECT * FROM ",l_dbs_tra CLIPPED,"pmm_file",     #FUN-980092 add    #FUN-A50102 mark
                         LET l_sql ="SELECT * FROM ",cl_get_target_table(l_plant_new,'pmm_file'),         #FUN-A50102
                                    " WHERE pmm99 = '",l_pmm99,"'"    #三角流程序號
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                         PREPARE p812_pmm_p FROM l_sql
                         DECLARE pmm_c CURSOR FOR p812_pmm_p
                         OPEN pmm_c 
                         FETCH pmm_c INTO l_pmm.*
                         IF SQLCA.sqlcode<>0 THEN
                            LET g_success = 'N'
                            IF g_bgerr THEN
                               CALL s_errmsg("","",l_dbs_tra CLIPPED,"apm1007",1)  #FUN-980092 add
                               CONTINUE FOR
                            ELSE
                               CALL cl_err3("","","apm1007","",SQLCA.sqlcode,"",l_dbs_tra CLIPPED,1) #FUN-980092 add
                               RETURN
                            END IF
                         END IF 
                         #------抓出每站工廠訂單資料------#
                        #LET l_sql ="SELECT * FROM ",l_dbs_tra CLIPPED,"oea_file",  #FUN-980092 add  #FUN-A50102 mark
                         LET l_sql ="SELECT * FROM ",cl_get_target_table(l_plant_new,'oea_file'),    #FUN-A50102
                                    " WHERE oea99 = '",l_pmm99,"'"    #三角流程序號
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                         PREPARE p811_oea_p FROM l_sql
                         DECLARE oea_c CURSOR FOR p811_oea_p
                         OPEN oea_c
                         FETCH oea_c INTO l_oea.*
                        #LET l_sql ="SELECT * FROM ",l_dbs_tra CLIPPED,"pmn_file,",l_dbs_tra CLIPPED,"pmm_file",     #FUN-980092 add #FUN-A50102
                         LET l_sql ="SELECT * FROM ",cl_get_target_table(l_plant_new,'pmn_file'),",",       #FUN-A50102
                                                     cl_get_target_table(l_plant_new,'pmm_file'),           #FUN-A50102 
                                    " WHERE pmn01 = '",l_pmm.pmm01,"'",
                                    "   AND pmn02 = '",g_pmn[l_no].pmn02,"'",    #採購單項次
                                    " ORDER BY pmn02 "  
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                         PREPARE p812_pmn_p FROM l_sql
                         DECLARE pmn_c CURSOR FOR p812_pmn_p
                         OPEN pmn_c 
                         FETCH pmn_c INTO l_pmn.*
                         IF SQLCA.sqlcode<>0 THEN
                            LET g_success = 'N'
                            IF g_bgerr THEN
                               CALL s_errmsg("","",l_dbs_tra CLIPPED,"apm1007",1)  #FUN-980092 add
                               CONTINUE FOR
                            ELSE
                               CALL cl_err3("","","","","apm1007","",l_dbs_tra CLIPPED,1)  #FUN-980092 add
                               RETURN
                            END IF
                         END IF 
                        #CALL p812_sta(l_cnt) RETURNING g_sta  #MOD-C40048 mark
                         CALL p812_sta(l_no)  RETURNING g_sta  #MOD-C40048 add
                        #LET l_sql ="SELECT * FROM ",l_dbs_tra CLIPPED,"oeb_file",  #FUN-980092 add      #FUN-A50102 mark
                         LET l_sql ="SELECT * FROM ",cl_get_target_table(l_plant_new,'oeb_file'),        #FUN-A50102
                                    " WHERE oeb01 = '",l_oea.oea01,"'",    #MOD-870321
                                    "   AND oeb03 = '",l_pmn.pmn02,"'",    #採購單項次
                                    " ORDER BY oeb03 "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                         PREPARE p812_oeb_p FROM l_sql
                         DECLARE oeb_c CURSOR FOR p812_oeb_p
                         OPEN oeb_c
                         FETCH oeb_c INTO l_oeb.*
                             LET l_oeb.oeb70 = 'Y'
                             LET l_oeb.oeb70d = g_today
                             LET l_oeb.oeb26 = l_oeb.oeb12 - l_oeb.oeb24 + l_oeb.oeb25
                              IF l_oeb.oeb19 = 'Y' THEN
                                 LET l_oeb.oeb905 = 0
                             END IF    
                         IF cl_null(l_oeb.oeb26) THEN
                            let l_oeb.oeb26 = 0
                         END IF
                         IF cl_null(l_oeb.oeb905) THEN                                                                               
                            let l_oeb.oeb905 = 0                                                                                     
                         END IF                     
                         
                        #LET l_sql= "UPDATE ",l_dbs_tra CLIPPED,"oeb_file ", #FUN-980092 add       #FUN-A50102 mark
                         LET l_sql= "UPDATE ",cl_get_target_table(l_plant_new,'oeb_file'),         #FUN-A50102
                                    "   SET oeb70 = 'Y',",
                                    "       oeb70d = '",g_today,"',",             #FUN-870152
                                    "       oeb26 = ",l_oeb.oeb26,",",            #FUN-870152
                                    "       oeb905= ",l_oeb.oeb905," ",           #FUN-870152                                                                                                         
                                    " WHERE oeb01 = '",l_oea.oea01,"'",    #MOD-870321
                                    "   AND oeb03 = '",l_pmn.pmn02,"'"                                                              
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                         PREPARE upd_oeb70 FROM l_sql                                                                               
                         EXECUTE upd_oeb70                                                                                          
                         #MOD-C20011 add --start--
                         LET l_cnt = 0
                         LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'oeb_file'),
                                     " WHERE oeb01 = '",l_oea.oea01,"'",
                                     " AND oeb70 = 'N'"
                         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
                         PREPARE sel_oeb_1 FROM l_sql
                         EXECUTE sel_oeb_1 INTO l_cnt
                         IF l_cnt = 0  THEN
                            LET l_sql = "UPDATE ",cl_get_target_table(l_plant_new,'oea_file'),
                                        "   SET oea49 = '2' WHERE oea01='",l_oea.oea01,"'"
                            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                            CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
                            PREPARE upd_oea49_2 FROM l_sql
                            EXECUTE upd_oea49_2
                            #MOD-C20158 ----- mark start -----
                            #IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                            #   CALL cl_err('upd oea49:',SQLCA.SQLCODE,0)
                            #   LET g_success='N'
                            #   RETURN
                            #END IF
                            #MOD-C20158 ----- mark end -----
                         END IF
                         #MOD-C20011 add --end--
                         LET l_cnt1 = 0
                        #LET l_sql= "UPDATE ",l_dbs_tra CLIPPED,"pmn_file ",  #FUN-980092 add     #FUN-A50102 mark
                         LET l_sql= "UPDATE ",cl_get_target_table(l_plant_new,'pmn_file'),        #FUN-A50102
                                    "   SET pmn16 = '",g_sta,"'",
                                    " WHERE pmn01 = '",l_pmn.pmn01,"'", 
                                    "   AND pmn02 = '",l_pmn.pmn02,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                         PREPARE upd_pmn16 FROM l_sql
                         EXECUTE upd_pmn16
                         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                            LET g_success='N'
                            IF g_bgerr THEN
                               LET g_showmsg = l_pmn.pmn01,"/",l_pmn.pmn02
                               CALL s_errmsg("pmn01,pmn02",g_showmsg,"(p812:ckp#3)",SQLCA.sqlcode,1)
                               CONTINUE FOR
                            ELSE
                               CALL cl_err3("upd","pmn_file",g_pmm[l_ac].pmm01,g_pmn[l_cnt].pmn02,SQLCA.sqlcode,"","(p812:ckp#3)",1)
                               RETURN
                            END IF
                         ELSE
                            LET l_cnt1 = l_cnt1 + 1
                         END IF
                         SELECT pmn20,pmn50,pmn55,pmn09,pmn011,pmn41
                           INTO l_pmn20,l_pmn50,l_pmn55,l_pmn09,l_pmn011,l_pmn41
                           FROM pmn_file
                          WHERE pmn01 = l_pmm.pmm01 AND pmn02 = l_pmn.pmn02
                         IF SQLCA.sqlcode THEN
                            LET l_pmn09 = 1    LET l_pmn20 = 0
                            LET l_pmn50 = 0
                            LET l_pmn55 = 0
                         END IF
                     END IF
                 END FOR
                 #---回寫本站---
                 FOR j = 1 TO g_rec_b1
                     IF g_pmn[j].sure = 'Y' THEN
                         UPDATE pmn_file 
                            SET pmn16 = g_sta
                          WHERE pmn01 = g_pmm[l_ac].pmm01
                            AND pmn02 = g_pmn[j].pmn02
                         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                            LET g_success='N'
                            IF g_bgerr THEN
                               LET g_showmsg = l_pmn.pmn01,"/",l_pmn.pmn02
                               CALL s_errmsg("pmn01,pmn02",g_showmsg,"(p812:ckp#3)",SQLCA.sqlcode,1)
                               CONTINUE FOR
                            ELSE
                               CALL cl_err3("upd","pmn_file",l_pmn.pmn01,l_pmn.pmn02,SQLCA.sqlcode,"","(p812:ckp#3)",1)
                               RETURN
                            END IF
                         END IF
                     END IF
                 END FOR
                 CALL p812_hu(l_pmm99,l_cnt1)
             ELSE 
               FOR l_no = 1 TO g_rec_b1
                IF g_pmn[l_no].sure = 'Y' THEN             	
                  #------抓出每站工廠訂單資料------#
                 #LET l_sql ="SELECT * FROM ",l_dbs_tra CLIPPED,"oea_file",  #FUN-980092 add      #FUN-A50102 mark
                  LET l_sql ="SELECT * FROM ",cl_get_target_table(l_plant_new,'oea_file'),        #FUN-A50102
                             " WHERE oea99 = '",l_pmm99,"'"    #三角流程序號
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                  PREPARE p811_oea_p1 FROM l_sql
                  DECLARE oea_c1 CURSOR FOR p811_oea_p1
                  OPEN oea_c1
                  FETCH oea_c1 INTO l_oea.*
 
                #LET l_sql ="SELECT * FROM ",l_dbs_tra CLIPPED,"oeb_file",  #FUN-980092 add     #FUN-A50102 mark
                 LET l_sql ="SELECT * FROM ",cl_get_target_table(l_plant_new,'oeb_file'),       #FUN-A50102
                            " WHERE oeb01 = '",l_oea.oea01,"'",    #MOD-870321
                            "   AND oeb03 = '",g_pmn[l_no].pmn02,"'",  #採購單項次  #MOD-880159
                            " ORDER BY oeb03 "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                 PREPARE p812_oeb_p6 FROM l_sql
                 DECLARE oeb_c6 CURSOR FOR p812_oeb_p6
                 OPEN oeb_c6
                 FETCH oeb_c6 INTO l_oeb.*
                     IF g_poz.poz011 = '2' THEN
                        LET l_cnt = 0
                        LET l_sql = " SELECT COUNT(*) ",
                                   #" FROM ",l_azp03_e_tra CLIPPED,"oga_file, ",l_azp03_e_tra CLIPPED,"ogb_file ", #FUN-980092 add   #FUN-A50102 mark
                                    " FROM ",cl_get_target_table(l_plant_new_e,'oga_file'),",",      #FUN-A50102 
                                             cl_get_target_table(l_plant_new_e,'ogb_file'),          #FUN-A50102
                                    " WHERE oga01 = ogb01 AND ogaconf = 'N' AND ogb31 = '",l_oea.oea01,"' ", 
                                    "   AND ogb32 = '",g_pmn[l_no].pmn02,"'"
                        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                        CALL cl_parse_qry_sql(l_sql,l_plant_new_e) RETURNING l_sql #FUN-980092
                        PREPARE p812_oga_p FROM l_sql 
                        IF SQLCA.SQLCODE THEN
                           CALL cl_err('p812_oga',SQLCA.SQLCODE,1)
                        END IF
                        DECLARE p812_oga_c CURSOR FOR p812_oga_p
                        OPEN p812_oga_c
                        FETCH p812_oga_c INTO l_cnt
                        IF l_cnt > 0 THEN
                           LET g_success = 'N'
                           IF g_bgerr THEN
                              CALL s_errmsg('oea03',g_pmn[l_no].pmn02,l_azp03_e_tra,'axm-430',1) #FUN-980092 add
                              CONTINUE FOR
                           ELSE
                              CALL cl_err3("","","axm-430","",SQLCA.sqlcode,"",l_azp03_e_tra CLIPPED,1) #FUN-980092 add
                              RETURN
                           END IF
                        END IF
                     END IF 
                     LET l_oeb.oeb70 = 'Y'
                     LET l_oeb.oeb70d = g_today
                     LET l_oeb.oeb26 = l_oeb.oeb12 - l_oeb.oeb24 + l_oeb.oeb25
                      IF l_oeb.oeb19 = 'Y' THEN
                         LET l_oeb.oeb905 = 0
                     END IF
                 IF cl_null(l_oeb.oeb26) THEN                                                                               
                    let l_oeb.oeb26 = 0                                                                                     
                 END IF                                                                                                     
                 IF cl_null(l_oeb.oeb905) THEN                                                                              
                    let l_oeb.oeb905 = 0                                                                                    
                 END IF
                                             
                  #LET l_sql= "UPDATE ",l_dbs_tra CLIPPED,"oeb_file ",  #FUN-980092 add           #FUN-A50102 mark
                   LET l_sql= "UPDATE ",cl_get_target_table(l_plant_new,'oeb_file'),              #FUN-A50102 
                              "   SET oeb70 = 'Y',",
                              "       oeb70d = '",g_today,"',",            #FUN-870152
                              "       oeb26 = ",l_oeb.oeb26,",",           #FUN-870152
                              "       oeb905= ",l_oeb.oeb905," ",          #FUN-870152                                                                                                 
                              " WHERE oeb01 = '",l_oea.oea01,"'",          #MOD-870321                                                             
                              "   AND oeb03 = '",g_pmn[l_no].pmn02,"'"  #採購單項次  #MOD-880159
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                   PREPARE upd_oeb70_1 FROM l_sql                                                                               
                   EXECUTE upd_oeb70_1  
                   #MOD-C20011 add --start--
                   LET l_cnt = 0
                   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'oeb_file'),
                               " WHERE oeb01 = '",l_oea.oea01,"'",
                               " AND oeb70 = 'N'"
                   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                   CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
                   PREPARE sel_oeb_2 FROM l_sql
                   EXECUTE sel_oeb_2 INTO l_cnt
                   IF l_cnt = 0  THEN
                      LET l_sql = "UPDATE ",cl_get_target_table(l_plant_new,'oea_file'),
                                  "   SET oea49 = '2' WHERE oea01='",l_oea.oea01,"'"
                      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                      CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
                      PREPARE upd_oea49_3 FROM l_sql
                      EXECUTE upd_oea49_3
                      #MOD-C20158 ----- mark start -----
                      #IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                      #   CALL cl_err('upd oea49:',SQLCA.SQLCODE,0)
                      #   LET g_success='N'
                      #   RETURN
                      #END IF
                      #MOD-C20158 ----- mark end -----
                   END IF
                   #MOD-C20011 add --end--
               END IF
              END FOR           	                                 
             END IF
         END FOR
         IF g_totsuccess="N" THEN
            LET g_success="N"
         END IF
 
     END IF
END FUNCTION
 
FUNCTION p812_z()
DEFINE
     l_pmn20       LIKE pmn_file.pmn20,
     l_pmn09       LIKE pmn_file.pmn09,
     l_pmn50       LIKE pmn_file.pmn20,
     l_pmn011      LIKE pmn_file.pmn011,
     l_pmn41       LIKE pmn_file.pmn41,
     l_pmn55       LIKE pmn_file.pmn55,
     l_wc          LIKE type_file.chr1000,         # RDSQL STATEMENT
     l_sql         STRING,         # RDSQL STATEMENT
     l_cnt         LIKE type_file.num5,
     g_sta         LIKE type_file.chr1000,
     l_pmn         RECORD LIKE pmn_file.*,
     l_pmm         RECORD LIKE pmm_file.*,
     l_oea         RECORD LIKE oea_file.*,         #MOD-870321
     l_pmm99       LIKE pmm_file.pmm99,
     l_poy04_s     LIKE poy_file.poy04,
     i,j           LIKE type_file.num5,
     l_pmn02       LIKE pmn_file.pmn02,
     l_no          LIKE type_file.num5,
     l_update_sw   LIKE type_file.chr1
     
DEFINE l_oeb       RECORD LIKE oeb_file.*           #FUN-870152    
 
     LET l_update_sw = 'N'  #當單身有一筆開啟則單頭必需開啟
     SELECT pmm99 INTO l_pmm99 
       FROM pmm_file
      WHERE pmm01= g_pmm[l_ac].pmm01
     CALL s_mtrade_last_plant(g_pmm[l_ac].pmm904)
           RETURNING p_last,p_last_plant
     IF NOT cl_null(p_last) THEN         #有最後一站站別資料
         #找出起始站別工廠
         SELECT poy04 INTO l_poy04_s  
           FROM poy_file
          WHERE poy01 = g_pmm[l_ac].pmm904
            AND poy02 = '0'    
         LET p_first_plant = l_poy04_s
         IF p_first_plant != g_plant THEN    #只能從起始站做結案動作
            CALL cl_err('','apm-012',1)
            LET g_success = 'N'
            RETURN
         END IF
         CALL s_showmsg_init()        #No.FUN-710030
         FOR i = 0 TO p_last    
            IF g_success="N" THEN
               LET g_totsuccess="N"
               LET g_success="Y"
            END IF
             CALL p812_azp(i)
             IF i <> p_last OR ( i = p_last AND NOT cl_null(g_pmm[l_ac].pmm50)) THEN
                  #------抓出每站工廠訂單資料------#
                 #LET l_sql ="SELECT * FROM ",l_dbs_tra CLIPPED,"oea_file",  #FUN-980092 add      #FUN-A50102 mark
                  LET l_sql ="SELECT * FROM ",cl_get_target_table(l_plant_new,'oea_file'),        #FUN-A50102
                             " WHERE oea99 = '",l_pmm99,"'"    #三角流程序號
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                  PREPARE p811_oea_p2 FROM l_sql
                  DECLARE oea_c2 CURSOR FOR p811_oea_p2
                  OPEN oea_c2
                  FETCH oea_c2 INTO l_oea.*
                  #------抓出每站工廠採購單資料------#
                 #LET l_sql ="SELECT * FROM ",l_dbs_tra CLIPPED,"pmm_file",     #FUN-980092 add   #FUN-A50102 mark
                  LET l_sql ="SELECT * FROM ",cl_get_target_table(l_plant_new,'pmm_file'),        #FUN-A50102
                             " WHERE pmm99 = '",l_pmm99,"'"    #三角流程序號
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                  PREPARE p812_pmm_p1 FROM l_sql
                  DECLARE pmm_c1 CURSOR FOR p812_pmm_p1
                  OPEN pmm_c1 
                  FETCH pmm_c1 INTO l_pmm.*
                  IF SQLCA.sqlcode<>0 THEN
                     LET g_success = 'N'
                     IF g_bgerr THEN
                        CALL s_errmsg("","","sel pmm:",SQLCA.sqlcode,1)
                        CONTINUE FOR
                     ELSE
                        CALL cl_err3("","","","",SQLCA.sqlcode,"","sel pmm:",1)
                        RETURN
                     END IF
                  END IF 
                  FOR l_no = 1 TO g_rec_b1
                      IF g_pmn[l_no].sure = 'Y' THEN
                      
                       #LET l_sql ="SELECT * FROM ",l_dbs_tra CLIPPED,"oeb_file",  #FUN-980092 add    #FUN-A50102 mark
                        LET l_sql ="SELECT * FROM ",cl_get_target_table(l_plant_new,'oeb_file'),      #FUN-A50102 
                                   " WHERE oeb01 = '",l_oea.oea01,"'",             #MOD-870321                                                     
                                   "   AND oeb03 = '",g_pmn[l_no].pmn02,"'",    #採購單項次
                                   " ORDER BY oeb03 "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                        PREPARE p812_oeb_p2 FROM l_sql
                        DECLARE oeb_c2 CURSOR FOR p812_oeb_p2
                        OPEN oeb_c2
                        FETCH oeb_c2 INTO l_oeb.*
                            LET l_oeb.oeb70 = 'N'
                            LET l_oeb.oeb70d = NULL
                            LET l_oeb.oeb26 = 0
                             IF l_oeb.oeb19 = 'Y' THEN
                                CALL s_errmsg('','','',"axm-809",0)  
                             END IF
                         IF cl_null(l_oeb.oeb26) THEN                                                                               
                            let l_oeb.oeb26 = 0                                                                                     
                         END IF                                                                                                     
                         IF cl_null(l_oeb.oeb905) THEN                                                                              
                            let l_oeb.oeb905 = 0                                                                                    
                         END IF 
                                                  
                         #LET l_sql= "UPDATE ",l_dbs_tra CLIPPED,"oeb_file ",  #FUN-980092 add       #FUN-A50102  mark                                               
                          LET l_sql= "UPDATE ",cl_get_target_table(l_plant_new,'oeb_file'),          #FUN-A50102
                                     "   SET oeb70 = 'N',",
                                     "       oeb70d = '',",                          #FUN-870152
                                     "       oeb26 = ",l_oeb.oeb26,",",              #FUN-870152
                                     "       oeb905= ",l_oeb.oeb905," ",             #FUN-870152                                                                                                 
                                     " WHERE oeb01 = '",l_oea.oea01,"'",             #MOD-870321                                                     
                                     "   AND oeb03 = '",g_pmn[l_no].pmn02,"'"                                                             
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                          PREPARE upd_oeb70_p1 FROM l_sql                                                                           
                          EXECUTE upd_oeb70_p1                                                                                      
                          #MOD-C20011 add --start--
                          LET l_cnt = 0
                          LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'oeb_file'),
                                      " WHERE oeb01 = '",l_oea.oea01,"'",
                                      " AND oeb70 = 'N'"
                          CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                          CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
                          PREPARE sel_oeb_3 FROM l_sql
                          EXECUTE sel_oeb_3 INTO l_cnt
                          IF l_cnt > 0  THEN
                             LET l_sql = "UPDATE ",cl_get_target_table(l_plant_new,'oea_file'),
                                         "   SET oea49 = '1' WHERE oea01='",l_oea.oea01,"'"
                             CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                             CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
                             PREPARE upd_oea49_1 FROM l_sql
                             EXECUTE upd_oea49_1
                             #MOD-C20158 ----- mark start -----
                             #IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                             #   CALL cl_err('upd oea49:',SQLCA.SQLCODE,0)
                             #   LET g_success='N'
                             #   RETURN
                             #END IF
                             #MOD-C20158 ----- mark end -----
                          END IF
                          #MOD-C20011 add --end--
                         #LET l_sql= "UPDATE ",l_dbs_tra CLIPPED,"pmn_file ",  #FUN-980092 add   #FUN-A50102 mark
                          LET l_sql= "UPDATE ",cl_get_target_table(l_plant_new,'pmn_file'),      #FUN-A50102
                                     "   SET pmn16 = 2",
                                     " WHERE pmn01 = '",l_pmm.pmm01,"'", 
                                     "   AND pmn02 = '",g_pmn[l_no].pmn02,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                          PREPARE upd_pmn16_p1 FROM l_sql
                          EXECUTE upd_pmn16_p1
                          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                             LET g_success='N'
                             IF g_bgerr THEN
                                LET g_showmsg = g_pmm[l_ac].pmm01,"/",g_pmn[l_cnt].pmn02
                                CALL s_errmsg("pmn01,pmn02",g_showmsg,"(p812:ckp#3)",SQLCA.sqlcode,1)
                                CONTINUE FOR
                             ELSE
                                CALL cl_err3("upd","pmn_file",g_pmm[l_ac].pmm01,g_pmn[l_cnt].pmn02,SQLCA.sqlcode,"","(p812:ckp#3)",1)
                                RETURN
                             END IF
                          ELSE
                             LET l_update_sw = 'Y'
                          END IF
                          SELECT pmn20,pmn50,pmn55,pmn09,pmn011,pmn41
                            INTO l_pmn20,l_pmn50,l_pmn55,l_pmn09,l_pmn011,l_pmn41
                            FROM pmn_file
                           WHERE pmn01 = l_pmm.pmm01
                             AND pmn02 = g_pmn[l_no].pmn02
                          IF SQLCA.sqlcode THEN
                             LET l_pmn09 = 1    LET l_pmn20 = 0
                             LET l_pmn50 = 0
                             LET l_pmn55 = 0
                          END IF
                      END IF
                  END FOR
                  IF l_update_sw = 'Y' THEN             #當單身有一筆開啟則單頭必需開啟
                     #LET l_sql= "UPDATE ",l_dbs_tra CLIPPED,"pmm_file ", #FUN-980092 add     #FUN-A50102 mark
                     #LET l_sql= "UPDATE ",cl_get_target_table(l_plant_new,'pmn_file'),       #FUN-A50102 #MOD-C30866 mark
                      LET l_sql= "UPDATE ",cl_get_target_table(l_plant_new,'pmm_file'),       #MOD-C30866 add
                                         "   SET pmm25 = '2' ,pmm27 = '",g_today,"'",
                                         " WHERE pmm01 = '",l_pmm.pmm01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                      PREPARE upd_pmm25_p FROM l_sql
                      EXECUTE upd_pmm25_p
                      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                         LET g_success='N'
                         IF g_bgerr THEN
                            CALL s_errmsg("pmm01",l_pmm.pmm01,"cannot update pmm_file",SQLCA.sqlcode,1)
                         ELSE
                            CALL cl_err3("upd","pmm_file",l_pmm.pmm01,"",SQLCA.sqlcode,"","cannot update pmm_file",1)
                         END IF
                      END IF
                  END IF
             ELSE 
               FOR l_no = 1 TO g_rec_b1
                IF g_pmn[l_no].sure = 'Y' THEN              	
                # LET l_sql ="SELECT * FROM ",l_dbs_tra CLIPPED,"oea_file",  #FUN-980092 add    #FUN-A50102 mark
                  LET l_sql ="SELECT * FROM ",cl_get_target_table(l_plant_new,'oea_file'),      #FUN-A50102
                             " WHERE oea99 = '",l_pmm99,"'"    #三角流程序號
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                  PREPARE p811_oea_p4 FROM l_sql
                  DECLARE oea_c4 CURSOR FOR p811_oea_p4
                  OPEN oea_c4
                  FETCH oea_c4 INTO l_oea.*
                               	
                 #LET l_sql ="SELECT * FROM ",l_dbs_tra CLIPPED,"oeb_file",  #FUN-980092 add   #FUN-A50102  mark
                  LET l_sql ="SELECT * FROM ",cl_get_target_table(l_plant_new,'oeb_file'),     #FUN-A50102
                             " WHERE oeb01 = '",l_oea.oea01,"'",             #MOD-870321                                                     
                             "   AND oeb03 = '",g_pmn[l_no].pmn02,"'",    #採購單項次
                             " ORDER BY oeb03 "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                  PREPARE p812_oeb_p8 FROM l_sql
                  DECLARE oeb_c8 CURSOR FOR p812_oeb_p8
                  OPEN oeb_c8
                  FETCH oeb_c8 INTO l_oeb.*
                      LET l_oeb.oeb70 = 'N'
                      LET l_oeb.oeb70d = NULL
                      LET l_oeb.oeb26 = 0
                       IF l_oeb.oeb19 = 'Y' THEN
                          CALL s_errmsg('','','',"axm-809",0)  
                       END IF
                  IF cl_null(l_oeb.oeb26) THEN                                                                               
                     let l_oeb.oeb26 = 0                                                                                     
                  END IF                                                                                                     
                  IF cl_null(l_oeb.oeb905) THEN                                                                              
                     let l_oeb.oeb905 = 0                                                                                    
                  END IF 
                                           
                 #LET l_sql= "UPDATE ",l_dbs_tra CLIPPED,"oeb_file ",  #FUN-980092 add       #FUN-A50102 mark
                  LET l_sql= "UPDATE ",cl_get_target_table(l_plant_new,'oeb_file'),          #FUN-A50102
                             "   SET oeb70 = 'N',",
                             "       oeb70d = '',",                          #FUN-870152
                             "       oeb26 = ",l_oeb.oeb26,",",              #FUN-870152
                             "       oeb905= ",l_oeb.oeb905," ",             #FUN-870152                                                                          
                             " WHERE oeb01 = '",l_oea.oea01,"'",             #MOD-870321                                                     
                             "   AND oeb03 = '",g_pmn[l_no].pmn02,"'"                                                              
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                  PREPARE upd_oeb70_p2 FROM l_sql                                                                               
                  EXECUTE upd_oeb70_p2
                  #MOD-C20011 add --start--
                  LET l_cnt = 0
                  LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'oeb_file'),
                              " WHERE oeb01 = '",l_oea.oea01,"'",
                              " AND oeb70 = 'N'"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
                  PREPARE sel_oeb_4 FROM l_sql
                  EXECUTE sel_oeb_4 INTO l_cnt
                  IF l_cnt > 0  THEN
                     LET l_sql = "UPDATE ",cl_get_target_table(l_plant_new,'oea_file'),
                                 "   SET oea49 = '1' WHERE oea01='",l_oea.oea01,"'"
                     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
                     PREPARE upd_oea49_4 FROM l_sql
                     EXECUTE upd_oea49_4
                     #MOD-C20158 ----- mark start -----
                     #IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     #   CALL cl_err('upd oea49:',SQLCA.SQLCODE,0)
                     #   LET g_success='N'
                     #   RETURN
                     #END IF
                     #MOD-C20158 ----- mark end-----
                  END IF
                  #MOD-C20011 add --end--
                END IF
              END FOR                                                                                             
             #No.FUN-820053--Add--End--#
             END IF
         END FOR
         IF g_totsuccess="N" THEN
            LET g_success="N"
         END IF
 
     END IF
END FUNCTION
 
FUNCTION p812_azp(i)
DEFINE i LIKE type_file.num5
 
    SELECT * INTO g_poy.* FROM poy_file
     WHERE poy01 = g_pmm[l_ac].pmm904 AND poy02 = i
    IF NOT cl_null(g_poy.poy04) THEN
        SELECT * INTO l_azp.* FROM azp_file WHERE azp01 = g_poy.poy04
        LET l_dbs_new = s_dbstring(l_azp.azp03)   #TQC-950010 ADD  
     LET g_plant_new = l_azp.azp01
     LET l_plant_new = g_plant_new
     CALL s_gettrandbs()
     LET l_dbs_tra = g_dbs_tra
    END IF
END FUNCTION
               
FUNCTION p812_sta(l_ac)
   DEFINE l_sta    LIKE type_file.chr1000,
          l_ac     LIKE type_file.num5
 
   CASE
      WHEN g_pmn[l_ac].qty = 0 LET  l_sta = '6'
      WHEN g_pmn[l_ac].qty > 0 LET  l_sta = '7'
      WHEN g_pmn[l_ac].qty < 0 LET  l_sta = '8'
      OTHERWISE EXIT CASE
   END CASE
   RETURN l_sta
END FUNCTION      
#No.FUN-9C0071 ------------------- 精簡程式---------------------------
