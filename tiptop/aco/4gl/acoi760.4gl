# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: acoi760.4gl
# Descriptions...: 料件/成品歸併關係表維護作業 
# Date & Author..: FUN-930151 09/04/01 BY rainy 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No:MOD-B30282 11/03/16 By Pengu 修改規併後序號後，品名規格不會更新
# Modify.........: No:MOD-B30282 11/03/16 By Pengu 修改規併後序號後，品名規格不會更新
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_cei01         LIKE cei_file.cei01,  #料件類別 
    g_ceiacti       LIKE cei_file.ceiacti,
    g_ceiuser       LIKE cei_file.ceiuser,
    g_ceigrup       LIKE cei_file.ceigrup,
    g_ceimodu       LIKE cei_file.ceimodu,
    g_ceidate       LIKE cei_file.ceidate,
    g_cei           DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
        cei02       LIKE cei_file.cei02,     #序號   
        cei03       LIKE cei_file.cei03,     #廠內料號 
        ima02          LIKE ima_file.ima02,  #品名
        ima021         LIKE ima_file.ima021, #規格
        ima901         LIKE ima_file.ima901, #料件建檔日期
        cei07       LIKE cei_file.cei07,     #企業使用單位  
        cei05       LIKE cei_file.cei05,     #幣別
        cei06       LIKE cei_file.cei06,     #歸併前單價
        cei11       LIKE cei_file.cei11,     #歸併後序號 
        cei12       LIKE cei_file.cei12,     #歸併後品名
        cei13       LIKE cei_file.cei13,     #歸併後規格
        cei04       LIKE cei_file.cei04,     #海關商品編號    
        cei14       LIKE cei_file.cei14,     #歸併後單價
        cei08       LIKE cei_file.cei08,     #申報計量單位
        cei19       LIKE cei_file.cei19,     #申報單位轉換率 
        cei09       LIKE cei_file.cei09,     #法定計量單位 
        cei10       LIKE cei_file.cei10,     #法定計量單位轉換比率 
        cei17       LIKE cei_file.cei17,     #第二法定單位
        cei18       LIKE cei_file.cei18,     #第二法定單位轉換率      
        cei20       LIKE cei_file.cei20,     #歸併後貨號
        cei15       LIKE cei_file.cei15,     #審核狀態 
        cei21       LIKE cei_file.cei21,     #備註說明  
        cei22       LIKE cei_file.cei22,     #歸併後幣別  
        ceiacti     LIKE cei_file.ceiacti    #資料有效碼
                    END RECORD,
    g_cei_t         RECORD                 
        cei02       LIKE cei_file.cei02,   
        cei03       LIKE cei_file.cei03,   
        ima02          LIKE ima_file.ima02,         
        ima021         LIKE ima_file.ima021,        
        ima901         LIKE ima_file.ima901,       
        cei07       LIKE cei_file.cei07,   
        cei05       LIKE cei_file.cei05,   
        cei06       LIKE cei_file.cei06,   
        cei11       LIKE cei_file.cei11,   
        cei12       LIKE cei_file.cei12,   
        cei13       LIKE cei_file.cei13,   
        cei04       LIKE cei_file.cei04,   
        cei14       LIKE cei_file.cei14,   
        cei08       LIKE cei_file.cei08,   
        cei19       LIKE cei_file.cei19,   
        cei09       LIKE cei_file.cei09,   
        cei10       LIKE cei_file.cei10,   
        cei17       LIKE cei_file.cei17,   
        cei18       LIKE cei_file.cei18,   
        cei20       LIKE cei_file.cei20,   
        cei15       LIKE cei_file.cei15,   
        cei21       LIKE cei_file.cei21,    
        cei22       LIKE cei_file.cei22,
        ceiacti     LIKE cei_file.ceiacti    
                    END RECORD,
    g_wc,g_sql      STRING,     
    g_factor        LIKE ima_file.ima31_fac,
    g_rec_b         LIKE type_file.num5,   
    l_ac            LIKE type_file.num5   
DEFINE g_before_input_done  LIKE type_file.num5   
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE g_cnt        LIKE type_file.num10    
DEFINE g_i          LIKE type_file.num5    
DEFINE g_ceh00   LIKE ceh_file.ceh00
 
 
MAIN
  OPTIONS                                 
      INPUT NO WRAP
  DEFER INTERRUPT                    
 
  LET g_cei01 = ARG_VAL(1)

  IF (NOT cl_user()) THEN
     EXIT PROGRAM
  END IF
  
  WHENEVER ERROR CALL cl_err_msg_log
  
  IF (NOT cl_setup("ACO")) THEN
     EXIT PROGRAM
  END IF

  CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
  IF g_cei01 NOT MATCHES '[123]' THEN 
     EXIT PROGRAM
  END IF
    
  CASE g_cei01
    WHEN "1"
      LET g_prog = 'acoi761'
      LET g_ceh00 = '1'
    WHEN "2"
      LET g_prog = 'acoi760'
      LET g_ceh00 = '2'
      WHEN "3"
      LET g_prog = 'acoi762'
      LET g_ceh00 = '3'
   END CASE
    
   OPEN WINDOW i760_w WITH FORM "aco/42f/acoi760"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   CALL i760_set_init()
   LET g_wc = '1=1' 
   CALL i760_b_fill( g_wc)
   CALL i760_menu()
 
   CLOSE WINDOW i760_w                 

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
 
FUNCTION i760_menu()
   WHILE TRUE
      CALL i760_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i760_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i760_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i760_y()
            END IF   
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL i760_z()
            END IF               
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_cei),'','')
             END IF
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION i760_q()
   CALL i760_b_askkey()
END FUNCTION
 
FUNCTION i760_b()
DEFINE
    l_ac_t          LIKE type_file.num5,               #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,               #檢查重複用    
    l_lock_sw       LIKE type_file.chr1,               #單身鎖住否       
    p_cmd           LIKE type_file.chr1,               #處理狀態  
    l_flag          LIKE type_file.chr1,        
    l_ima25         LIKE ima_file.ima25,
    l_allow_insert  LIKE type_file.num5,               
    l_allow_delete  LIKE type_file.num5               
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
   LET l_flag = 'N'
    FOR l_n=1 TO g_rec_b STEP 1
      IF g_cei[l_n].cei15='N' THEN
         LET l_flag='Y'
         EXIT FOR
      END IF 
    END FOR
    IF l_flag='N' THEN
       CALL cl_err('','aco-704',1)
       RETURN
    END IF
    LET l_allow_insert = false
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
 
 
    LET g_forupd_sql = "SELECT cei02,cei03,'','',",
                       "       '',cei07,cei05,cei06, ", 
                       "       cei11,cei12,cei13,cei04,",
                       "       cei14,cei08,cei19,cei09,cei10,",
                       "       cei17,cei18,cei20,cei15,cei21, ", 
                       "       cei22,ceiacti ", 
                       "   FROM cei_file ",
                       "    WHERE cei01=? AND cei02 = ? ",
                       "         FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i760_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   IF g_rec_b=0 THEN CALL g_cei.clear() END IF
 
   INPUT ARRAY g_cei WITHOUT DEFAULTS FROM s_cei.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec, UNBUFFERED, 
                         INSERT ROW = l_allow_insert, DELETE ROW=l_allow_delete,
                         APPEND ROW = l_allow_insert)
 
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
                LET g_cei_t.* = g_cei[l_ac].*  #BACKUP
                LET  g_before_input_done = FALSE                                                                                        
                CALL i760_set_entry(p_cmd)                                                                                              
                CALL i760_set_no_entry(p_cmd)                                                                                           
                LET  g_before_input_done = TRUE                                                                                         
                BEGIN WORK
                OPEN i760_bcl USING g_cei01,g_cei_t.cei02
                IF STATUS THEN
                   CALL cl_err("OPEN i760_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE   
                   FETCH i760_bcl INTO g_cei[l_ac].*
                   IF STATUS THEN
                      CALL cl_err('',STATUS,1) 
                      LET l_lock_sw = "Y"
                   END IF
                   SELECT ima02,ima021,ima901
                     INTO g_cei[l_ac].ima02, 
                          g_cei[l_ac].ima021,
                          g_cei[l_ac].ima901
                     FROM ima_file
                    WHERE ima01 = g_cei[l_ac].cei03 
 
                   SELECT ceg08  #計量單位
                     INTO g_cei[l_ac].cei08
                     FROM ceg_file
                    WHERE ceg01 = g_cei[l_ac].cei04
                      AND ceg00 = g_ceh00
                END IF
                CALL cl_show_fld_cont()     
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET  g_before_input_done = FALSE                                                                                        
            CALL i760_set_entry(p_cmd)                                                                                              
            CALL i760_set_no_entry(p_cmd)                                                                                           
            LET  g_before_input_done = TRUE                                                                                         
            INITIALIZE g_cei[l_ac].* TO NULL 
            LET g_cei[l_ac].cei15 = 'N'    
            LET g_cei[l_ac].ceiacti = 'Y'         
            LET g_ceiuser = g_user
            LET g_ceigrup = g_grup
            LET g_ceidate = g_today
            LET g_cei[l_ac].cei06 = 0    
            LET g_cei[l_ac].cei10 = 1    
            LET g_cei[l_ac].cei14 = 0    
            LET g_cei[l_ac].cei18 = 1    
            LET g_cei[l_ac].cei19 = 1    
            LET g_cei_t.* = g_cei[l_ac].*       
            CALL cl_show_fld_cont()     
 
      AFTER INSERT
         IF INT_FLAG THEN                
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
         END IF
 
         IF cl_null(g_cei[l_ac].cei02) THEN
            NEXT FIELD cei02
         END IF
         IF cl_null(g_cei[l_ac].cei03) THEN
            NEXT FIELD cei03
         END IF
         IF cl_null(g_cei[l_ac].cei05) THEN
            NEXT FIELD cei05
         END IF
         IF cl_null(g_cei[l_ac].cei06) THEN
            NEXT FIELD cei06
         END IF
         IF cl_null(g_cei[l_ac].cei07) THEN
            NEXT FIELD cei07
         END IF
         IF cl_null(g_cei[l_ac].cei08) THEN
            NEXT FIELD cei08
         END IF
         IF cl_null(g_cei[l_ac].cei09) THEN
            NEXT FIELD cei09
         END IF
         IF cl_null(g_cei[l_ac].cei10) THEN
            NEXT FIELD cei10
         END IF
         IF cl_null(g_cei[l_ac].cei11) THEN
            NEXT FIELD cei11
         END IF
         INSERT INTO cei_file(cei01,cei02,cei03,cei04,cei05,
                              cei06,cei07,cei08,cei09,cei10,cei11,
                              cei12,cei13,cei14,cei15,cei21, 
                              cei17,cei18,cei19,cei20,cei22, 
                              ceiacti,ceiuser,ceigrup,ceidate,ceioriu,ceiorig)
         VALUES(g_cei01,
                g_cei[l_ac].cei02,g_cei[l_ac].cei03,
                g_cei[l_ac].cei04,g_cei[l_ac].cei05,
                g_cei[l_ac].cei06,g_cei[l_ac].cei07,
                g_cei[l_ac].cei08,g_cei[l_ac].cei09,
                g_cei[l_ac].cei10,g_cei[l_ac].cei11,
                g_cei[l_ac].cei12,g_cei[l_ac].cei13,
                g_cei[l_ac].cei14,g_cei[l_ac].cei15,
                g_cei[l_ac].cei21, 
                g_cei[l_ac].cei17,g_cei[l_ac].cei18,
                g_cei[l_ac].cei19,g_cei[l_ac].cei20,
                g_cei[l_ac].cei22, 
                g_cei[l_ac].ceiacti,g_ceiuser,g_ceigrup,g_ceidate, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","cei_file",g_cei01,g_cei[l_ac].cei02,SQLCA.sqlcode,"","",1)
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b + 1
             DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
 
 
        BEFORE FIELD cei02 #序號  
            IF cl_null(g_cei[l_ac].cei02) THEN 
               LET l_n = 0
               SELECT MAX(cei02) INTO l_n
                 FROM cei_file 
                WHERE cei01 = g_cei01
               IF cl_null(l_n) THEN
                  LET g_cei[l_ac].cei02 = '1'
               ELSE
                  LET g_cei[l_ac].cei02 = l_n + 1
               END IF 
            END IF
        
        AFTER FIELD cei02
            IF NOT cl_null(g_cei[l_ac].cei02) AND (p_cmd = 'a'
               OR (p_cmd = 'u' AND g_cei[l_ac].cei02 <> g_cei_t.cei02)) THEN
               SELECT COUNT(*) INTO l_n FROM cei_file
                 WHERE cei01 = g_cei01 
                   AND cei02 = g_cei[l_ac].cei02
               IF l_n > 0 THEN
                  CALL cl_err('','aco-705',1)
                  NEXT FIELD cei02
               END IF
            END IF
        
        AFTER FIELD cei03   #廠內料號
            IF NOT cl_null(g_cei[l_ac].cei03) THEN
               #FUN-AA0059 --------------------------add start------------------ 
               IF NOT s_chk_item_no(g_cei[l_ac].cei03,'') THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD cei03
               END IF 
               #FUN-AA0059 -------------------------add end--------------------- 
               SELECT ima02,ima021,ima25,ima901
                 INTO g_cei[l_ac].ima02,g_cei[l_ac].ima021,
                      g_cei[l_ac].cei07,g_cei[l_ac].ima901
                   FROM ima_file
                   WHERE ima01 = g_cei[l_ac].cei03 
               IF SQLCA.sqlcode THEN
                  CALL cl_err('','-9912',1)
                  NEXT FIELD cei03
               END IF
            ELSE
               LET g_cei[l_ac].ima02 = ''
               LET g_cei[l_ac].ima021 = ''
               LET g_cei[l_ac].ima901 = '' 
            END IF
       
        AFTER FIELD cei04  #海關商品編號
            IF NOT cl_null(g_cei[l_ac].cei04) THEN
               SELECT ceg08  #計量單位
                 INTO g_cei[l_ac].cei08
                 FROM ceg_file
                WHERE ceg01 = g_cei[l_ac].cei04
                  AND ceg00 = g_ceh00
               IF SQLCA.sqlcode THEN
                  CALL cl_err('','aco-706',1)
                  NEXT FIELD cei04
               END IF
            END IF
     
        AFTER FIELD cei05 #幣別    
            IF NOT cl_null(g_cei[l_ac].cei05) THEN
               SELECT COUNT(*) INTO l_n FROM azi_file
                  WHERE azi01 = g_cei[l_ac].cei05
               IF l_n = 0 THEN
                  CALL cl_err('','aap-002',1)
                  NEXT FIELD cei05
               END IF
            END IF
        
        AFTER FIELD cei07  #企業使用單位     
            IF NOT cl_null(g_cei[l_ac].cei07) THEN
               SELECT COUNT(*) INTO l_n FROM gfe_file
                 WHERE gfe01 = g_cei[l_ac].cei07
               IF l_n = 0 THEN
                  CALL cl_err('','afa-319',1)
                  NEXT FIELD cei07
               END IF
            END IF
 
        AFTER FIELD cei08  #申報計量單位
            IF NOT cl_null(g_cei[l_ac].cei08) THEN
               SELECT COUNT(*) INTO l_n FROM gfe_file
                 WHERE gfe01 = g_cei[l_ac].cei08
               IF l_n = 0 THEN
                  CALL cl_err('','afa-319',1)
                  NEXT FIELD cei08
               END IF
            END IF
 
        AFTER FIELD cei09  #法定計量單位
            IF NOT cl_null(g_cei[l_ac].cei09) THEN
               SELECT COUNT(*) INTO l_n FROM gfe_file
                 WHERE gfe01 = g_cei[l_ac].cei09
               IF l_n = 0 THEN
                  CALL cl_err('','afa-319',1)
                  NEXT FIELD cei09
               END IF
               SELECT ima25 INTO l_ima25 FROM ima_file
                  WHERE ima01 = g_cei[l_ac].cei03
               CALL s_umfchk(g_cei[l_ac].cei03,g_cei[l_ac].cei09,l_ima25)
                  RETURNING l_n,g_factor
               IF l_n <> 1 THEN
                  LET g_cei[l_ac].cei10 = g_factor
               END IF 
            END IF
       
        AFTER FIELD cei10    #法定計量單位轉換比率
           IF NOT cl_null(g_cei[l_ac].cei10) THEN
              IF g_cei[l_ac].cei10 <= 0 THEN
                 CALL cl_err('','mfg9243',0)
                 LET g_cei[l_ac].cei10 = g_cei_t.cei10
                 NEXT FIELD cei10
              END IF 
           END IF 
 
        AFTER FIELD cei18   #第二法定計量單位轉換比率
           IF NOT cl_null(g_cei[l_ac].cei18) THEN
              IF g_cei[l_ac].cei18 <= 0 THEN
                 CALL cl_err('','mfg9243',0)
                 LET g_cei[l_ac].cei18 = g_cei_t.cei18
                 NEXT FIELD cei18
              END IF 
           END IF 
 
        AFTER FIELD cei19   #申報單位轉換率
           IF NOT cl_null(g_cei[l_ac].cei19) THEN
              IF g_cei[l_ac].cei19 <= 0 THEN
                 CALL cl_err('','mfg9243',0)
                 LET g_cei[l_ac].cei19 = g_cei_t.cei19
                 NEXT FIELD cei19
              END IF 
           END IF 
 
        AFTER FIELD cei17    #第二法定計量單位 
            IF NOT cl_null(g_cei[l_ac].cei17) THEN
               SELECT COUNT(*) INTO l_n FROM gfe_file
                 WHERE gfe01 = g_cei[l_ac].cei17
               IF l_n = 0 THEN
                  CALL cl_err('','afa-319',1)
                  NEXT FIELD cei17
               END IF
               SELECT ima25 INTO l_ima25 FROM ima_file
                  WHERE ima01 = g_cei[l_ac].cei03
               CALL s_umfchk(g_cei[l_ac].cei03,g_cei[l_ac].cei17,l_ima25)
                  RETURNING l_n,g_factor
               IF l_n <> 1 THEN
                  LET g_cei[l_ac].cei18 = g_factor
               END IF 
            END IF
 
        AFTER FIELD cei11  #規併後序號 
            IF NOT cl_null(g_cei[l_ac].cei11) THEN
               IF p_cmd = 'a' OR 
                  g_cei[l_ac].cei11 <> g_cei_t.cei11 THEN
                  CALL i760_cei11()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_cei[l_ac].cei11 = g_cei_t.cei11
                     NEXT FIELD cei11
                  END IF
               END IF
            END IF
            LET g_cei_t.cei11 = g_cei[l_ac].cei11    #No:MOD-B30282 add
               
 
        BEFORE DELETE                            
            IF g_cei_t.cei02 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF
                IF g_cei[l_ac].cei15 = 'Y' THEN
                   CALL cl_err('','anm-105',1)
                   CANCEL DELETE
                END IF 
                DELETE FROM cei_file 
                 WHERE cei01 = g_cei01 
                   AND cei02 = g_cei_t.cei02
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","cei_file",g_cei01,g_cei_t.cei02,SQLCA.sqlcode,"","",1) 
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b - 1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK" 
                CLOSE i760_bcl     
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_cei[l_ac].* = g_cei_t.*
              CLOSE i760_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err('',-263,1)
              LET g_cei[l_ac].* = g_cei_t.*
           ELSE
              IF g_cei[l_ac].cei15 = 'Y' THEN
                 CALL cl_err('','aap-005',1)
                 LET g_cei[l_ac].* = g_cei_t.*
              ELSE
                  UPDATE cei_file 
                     SET cei02=g_cei[l_ac].cei02,
                         cei03=g_cei[l_ac].cei03,
                         cei04=g_cei[l_ac].cei04,
                         cei05=g_cei[l_ac].cei05,
                         cei06=g_cei[l_ac].cei06,
                         cei07=g_cei[l_ac].cei07,
                         cei08=g_cei[l_ac].cei08,
                         cei09=g_cei[l_ac].cei09,
                         cei10=g_cei[l_ac].cei10,
                         cei11=g_cei[l_ac].cei11,
                         cei12=g_cei[l_ac].cei12,
                         cei13=g_cei[l_ac].cei13,
                         cei14=g_cei[l_ac].cei14,
                         cei15=g_cei[l_ac].cei15,
                         cei21=g_cei[l_ac].cei21, 
                         cei17=g_cei[l_ac].cei17,
                         cei18=g_cei[l_ac].cei18,
                         cei19=g_cei[l_ac].cei19,
                         cei20=g_cei[l_ac].cei20,
                         cei22=g_cei[l_ac].cei22, 
                         ceiacti=g_cei[l_ac].ceiacti,
                         ceimodu=g_user,
                         ceidate=g_today
                  WHERE cei01=g_cei01
                    AND cei02=g_cei_t.cei02
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("upd","cei_file",g_cei01,g_cei_t.cei02,SQLCA.sqlcode,"","",1) 
                     LET g_cei[l_ac].* = g_cei_t.*
                  ELSE
                     MESSAGE 'UPDATE O.K'
                     CLOSE i760_bcl
                     COMMIT WORK
                  END IF
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()                                               
           LET l_ac_t = l_ac                                                   
           IF INT_FLAG THEN                                            
              CALL cl_err('',9001,0)                                           
              LET INT_FLAG = 0                                                 
              IF p_cmd = 'u' THEN 
                 LET g_cei[l_ac].* = g_cei_t.*                                    
              END IF 
              CLOSE i760_bcl                                                   
              ROLLBACK WORK                                                    
              EXIT INPUT                                                       
           END IF                                                              
           CLOSE i760_bcl                                                      
           COMMIT WORK            
 
        ON ACTION CONTROLN
           CALL i760_b_askkey()
           EXIT INPUT
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        
        ON ACTION controlp                                                      
          CASE                                                                 
             WHEN INFIELD(cei03)                                               
#FUN-AA0059 --Begin--
              #  CALL cl_init_qry_var()                                         
              #  LET g_qryparam.form ="q_ima6"                                   
              #  LET g_qryparam.default1 = g_cei[l_ac].cei03                    
              #  CALL cl_create_qry() RETURNING g_cei[l_ac].cei03               
                CALL q_sel_ima(FALSE, "q_ima6", "", g_cei[l_ac].cei03, "", "", "", "" ,"",'' )  RETURNING g_cei[l_ac].cei03
#FUN-AA0059 --End--
                DISPLAY BY NAME g_cei[l_ac].cei03 
                NEXT FIELD cei03                                               
             WHEN INFIELD(cei04)                                               
                CALL cl_init_qry_var()                                         
                LET g_qryparam.form ="q_ceg01"   
                LET g_qryparam.arg1 = g_ceh00
                LET g_qryparam.default1 = g_cei[l_ac].cei04
                CALL cl_create_qry() RETURNING g_cei[l_ac].cei04               
                DISPLAY BY NAME g_cei[l_ac].cei04 
                NEXT FIELD cei04                                               
             WHEN INFIELD(cei05)                                               
                CALL cl_init_qry_var()                                         
                LET g_qryparam.form ="q_azi"                                   
                LET g_qryparam.default1 = g_cei[l_ac].cei05                    
                CALL cl_create_qry() RETURNING g_cei[l_ac].cei05               
                DISPLAY BY NAME g_cei[l_ac].cei05 
                NEXT FIELD cei05                                               
             WHEN INFIELD(cei07)                                               
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gfe"
                LET g_qryparam.default1 = g_cei[l_ac].cei07 
                CALL cl_create_qry() RETURNING g_cei[l_ac].cei07
                DISPLAY BY NAME g_cei[l_ac].cei07
                NEXT FIELD cei07
             WHEN INFIELD(cei08)                                               
                CALL cl_init_qry_var()                                         
                LET g_qryparam.form ="q_gfe"                                   
                LET g_qryparam.default1 = g_cei[l_ac].cei08                    
                CALL cl_create_qry() RETURNING g_cei[l_ac].cei08               
                DISPLAY BY NAME g_cei[l_ac].cei08 
                NEXT FIELD cei08                                               
             WHEN INFIELD(cei09)                                               
                CALL cl_init_qry_var()                                         
                LET g_qryparam.form ="q_gfe"                                   
                LET g_qryparam.default1 = g_cei[l_ac].cei09                    
                CALL cl_create_qry() RETURNING g_cei[l_ac].cei09               
                DISPLAY BY NAME g_cei[l_ac].cei09 
                NEXT FIELD cei09
             WHEN INFIELD(cei17) 
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gfe"
                LET g_qryparam.default1 = g_cei[l_ac].cei17
                CALL cl_create_qry() RETURNING g_cei[l_ac].cei17
                DISPLAY BY NAME g_cei[l_ac].cei17 
                NEXT FIELD cei17
             WHEN INFIELD(cei11)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_ceh01"
                LET g_qryparam.default1 = g_cei[l_ac].cei11 
                LET g_qryparam.arg1 = g_ceh00
                CALL cl_create_qry() RETURNING g_cei[l_ac].cei11
                DISPLAY BY NAME g_cei[l_ac].cei11
                NEXT FIELD cei11
             WHEN INFIELD(cei22)                                               
                CALL cl_init_qry_var()                                         
                LET g_qryparam.form ="q_azi"                                   
                LET g_qryparam.default1 = g_cei[l_ac].cei22                    
                CALL cl_create_qry() RETURNING g_cei[l_ac].cei22               
                DISPLAY BY NAME g_cei[l_ac].cei22 
                NEXT FIELD cei22                                               
           END CASE        
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
        ON ACTION CONTROLG
           CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
        ON ACTION about         
           CALL cl_about()      
        ON ACTION help          
           CALL cl_show_help()  
    END INPUT
 
    CLOSE i760_bcl
    COMMIT WORK
END FUNCTION
   
FUNCTION i760_b_askkey()
   CLEAR FORM
   CALL g_cei.clear()
   CALL cl_opmsg('q')
 
   CONSTRUCT g_wc ON cei02,cei03,
                     cei07,cei05,cei06,
                     cei11,cei12,cei13,
                     cei04,cei14,cei08,
                     cei19,cei09,cei10,
                     cei17,cei18,cei20,
                     cei15,cei21,cei22, 
                     ceiacti 
        FROM s_cei[1].cei02,s_cei[1].cei03,
             s_cei[1].cei07,s_cei[1].cei05,s_cei[1].cei06,
             s_cei[1].cei11,s_cei[1].cei12,s_cei[1].cei13,
             s_cei[1].cei04,s_cei[1].cei14,s_cei[1].cei08,
             s_cei[1].cei19,s_cei[1].cei09,s_cei[1].cei10,
             s_cei[1].cei17,s_cei[1].cei18,s_cei[1].cei20,
             s_cei[1].cei15,s_cei[1].cei21,s_cei[1].cei22, 
             s_cei[1].ceiacti
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON ACTION controlp                                                      
          CASE                                                                 
             WHEN INFIELD(cei03)                                               
#FUN-AA0059 --Begin--
             #   CALL cl_init_qry_var()                                         
             #   LET g_qryparam.form ="q_ima6"                                   
             #   LET g_qryparam.state = "c"                                     
             #   CALL cl_create_qry() RETURNING g_qryparam.multiret             
                CALL q_sel_ima( TRUE, "q_ima6","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                DISPLAY g_qryparam.multiret TO cei03
                NEXT FIELD cei03                                               
             WHEN INFIELD(cei04)                                               
                CALL cl_init_qry_var()                                         
                LET g_qryparam.form ="q_ceg01"
                LET g_qryparam.arg1 = g_ceh00
                LET g_qryparam.state = "c"                                     
                CALL cl_create_qry() RETURNING g_qryparam.multiret             
                DISPLAY g_qryparam.multiret TO cei04
                NEXT FIELD cei04                                               
             WHEN INFIELD(cei05)                                               
                CALL cl_init_qry_var()                                         
                LET g_qryparam.form ="q_azi"                                   
                LET g_qryparam.state = "c"                                     
                CALL cl_create_qry() RETURNING g_qryparam.multiret             
                DISPLAY g_qryparam.multiret TO cei05
                NEXT FIELD cei05                                               
             WHEN INFIELD(cei07) 
                CALL cl_init_qry_var()                                         
                LET g_qryparam.form ="q_gfe"                                   
                LET g_qryparam.state = "c"                                     
                CALL cl_create_qry() RETURNING g_qryparam.multiret             
                DISPLAY g_qryparam.multiret TO cei07
                NEXT FIELD cei07
             WHEN INFIELD(cei08)                                               
                CALL cl_init_qry_var()                                         
                LET g_qryparam.form ="q_gfe"                                   
                LET g_qryparam.state = "c"                                     
                CALL cl_create_qry() RETURNING g_qryparam.multiret             
                DISPLAY g_qryparam.multiret TO cei08
                NEXT FIELD cei08                                               
             WHEN INFIELD(cei09)
                CALL cl_init_qry_var()                                         
                LET g_qryparam.form ="q_gfe"                                   
                LET g_qryparam.state = "c"                                     
                CALL cl_create_qry() RETURNING g_qryparam.multiret             
                DISPLAY g_qryparam.multiret TO cei09
                NEXT FIELD cei09                                               
             WHEN INFIELD(cei10)                                               
                CALL cl_init_qry_var()                                         
                LET g_qryparam.form ="q_gfe"                                   
                LET g_qryparam.state = "c"                                     
                CALL cl_create_qry() RETURNING g_qryparam.multiret             
                DISPLAY g_qryparam.multiret TO cei10
                NEXT FIELD cei10                                               
             WHEN INFIELD(cei11)  
                CALL cl_init_qry_var() 
                LET g_qryparam.form ="q_ceh01" 
                LET g_qryparam.state = "c"
                LET g_qryparam.arg1 = g_ceh00
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO cei11
                NEXT FIELD cei11 
             WHEN INFIELD(cei17) 
                CALL cl_init_qry_var()                                         
                LET g_qryparam.form ="q_gfe"                                   
                LET g_qryparam.state = "c"                                     
                CALL cl_create_qry() RETURNING g_qryparam.multiret             
                DISPLAY g_qryparam.multiret TO cei17
                NEXT FIELD cei17
             WHEN INFIELD(cei22)                                               
                CALL cl_init_qry_var()                                         
                LET g_qryparam.form ="q_azi"                                   
                LET g_qryparam.state = "c"                                     
                CALL cl_create_qry() RETURNING g_qryparam.multiret             
                DISPLAY g_qryparam.multiret TO cei22
                NEXT FIELD cei22                                               
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
 
      ON ACTION qbe_select
        CALL cl_qbe_select() 
      ON ACTION qbe_save
        CALL cl_qbe_save()
   END CONSTRUCT           
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ceiuser', 'ceigrup') #FUN-980030
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
   CALL i760_b_fill(g_wc)
END FUNCTION
 
 
FUNCTION i760_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2    LIKE type_file.chr1000 
         
   LET g_sql = "SELECT cei02,cei03,'','','',cei07,", 
               "       cei05,cei06,",
               "       cei11,cei12,cei13,cei04,",
               "       cei14,cei08,cei19,cei09,cei10,",
               "       cei17,cei18,cei20,cei15,cei21, ", 
               "       cei22,ceiacti ", 
               " FROM cei_file  ",
               " WHERE cei01 = '",g_cei01,"' ",
               "   AND ", p_wc2 CLIPPED,    
               " ORDER BY 1"                        
   PREPARE i760_pb FROM g_sql
   DECLARE cei_curs CURSOR FOR i760_pb
   
   CALL g_cei.clear()   
   LET g_cnt = 1
   MESSAGE "Searching!" 
   FOREACH cei_curs INTO g_cei[g_cnt].*   
      IF SQLCA.sqlcode THEN 
         CALL cl_err('foreach:',STATUS,1) EXIT FOREACH 
      END IF
        SELECT ima02,ima021,ima901
          INTO g_cei[g_cnt].ima02,g_cei[g_cnt].ima021,
               g_cei[g_cnt].ima901
          FROM ima_file 
        WHERE ima01=g_cei[g_cnt].cei03 
      
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_cei.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
 
FUNCTION i760_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1        
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
                                                                                
   LET g_action_choice = " "         
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cei TO s_cei.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()             
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY      
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                  
 
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
         LET g_action_choice="detail"                                           
         LET l_ac = ARR_CURR()                                                  
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
 
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i760_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1        
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("cei02",TRUE)                                                                                           
  END IF                                                                                                                            
  IF p_cmd= 'u' AND (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("cei05,cei06,cei07,cei11",TRUE) 
  END IF
END FUNCTION                                                                                                                        
                                                                                                                                    
 
FUNCTION i760_set_no_entry(p_cmd)                                                                                                   
  DEFINE p_cmd   LIKE type_file.chr1        
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                               
     CALL cl_set_comp_entry("cei02",FALSE)                                                                                          
  END IF                                                                                                                            
  IF p_cmd= 'u' AND (NOT g_before_input_done) AND g_cei[l_ac].cei15<>'N' THEN
     CALL cl_set_comp_entry("cei03,cei07,cei05,cei06,cei11,cei19,cei22",FALSE)
  END IF
END FUNCTION
 
 
 
 
#===================================
#1.Check value                                                                  
#2.輸入歸併後序號後, 系統自動帶入                                               
#  歸併後品名、歸併後規格、海關商編、歸併後單價、申報計量單位、                 
#  法定計量單位、法定單位轉換率、第二法定單位、第二法定單位轉換率        
#===================================
FUNCTION i760_cei11()
   DEFINE l_n          INTEGER,
          g_n          INTEGER,
          l_ceh     RECORD LIKE ceh_file.*
          
 
   IF g_prog = 'acoi760' THEN LET g_ceh00 = '2' END IF
   IF g_prog = 'acoi761' THEN LET g_ceh00 = '1' END IF
   LET g_errno = NULL
   LET l_n = 0
   SELECT COUNT(*) INTO l_n
     FROM ceh_file
    WHERE ceh01 = g_cei[l_ac].cei11
      AND ceh00 = g_ceh00 
   CASE WHEN l_n = 0  
          LET g_errno = 'aco-707'  #無此歸併序號
        OTHERWISE          
          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) THEN
      INITIALIZE l_ceh.* TO NULL 
      SELECT * INTO l_ceh.*
        FROM ceh_file
       WHERE ceh01 = g_cei[l_ac].cei11
         AND ceh00 = g_ceh00 
      LET g_cei[l_ac].cei12 = l_ceh.ceh02   #品名   
      LET g_cei[l_ac].cei13 = l_ceh.ceh03   #規格 
      LET g_cei[l_ac].cei04 = l_ceh.ceh04   #海關商品編號    
      LET g_cei[l_ac].cei14 = l_ceh.ceh05   #單價     
      LET g_cei[l_ac].cei08 = l_ceh.ceh06   #申報計量單位   
      LET g_cei[l_ac].cei09 = l_ceh.ceh07   #法定計量單位   
      LET g_cei[l_ac].cei10 = l_ceh.ceh08   #法定計量轉換率   
      LET g_cei[l_ac].cei17 = l_ceh.ceh09   #第二法定計量單位   
      LET g_cei[l_ac].cei18 = l_ceh.ceh10   #第二法定計量轉換率     
      LET g_cei[l_ac].cei20 = l_ceh.ceh11   #歸併後貨號        
      LET g_cei[l_ac].cei22 = l_ceh.ceh12   #歸併後幣別        
   
   ELSE 
      LET g_cei[l_ac].cei12 = ''  #品名   
      LET g_cei[l_ac].cei13 = ''  #規格 
      LET g_cei[l_ac].cei04 = ''  #海關商品編號    
      LET g_cei[l_ac].cei14 = 0   #單價     
      LET g_cei[l_ac].cei08 = ''  #申報計量單位   
      LET g_cei[l_ac].cei09 = ''  #法定計量單位   
      LET g_cei[l_ac].cei10 = 0   #法定計量轉換率   
      LET g_cei[l_ac].cei17 = ''  #第二法定計量單位   
      LET g_cei[l_ac].cei18 = 0   #第二法定計量轉換率 
      LET g_cei[l_ac].cei20 = ''  #歸併後貨號        
      LET g_cei[l_ac].cei22 = ''  #歸併後幣別        
   END IF
      DISPLAY BY NAME g_cei[l_ac].cei12, g_cei[l_ac].cei13,
                      g_cei[l_ac].cei04, g_cei[l_ac].cei14,
                      g_cei[l_ac].cei08, g_cei[l_ac].cei09,
                      g_cei[l_ac].cei10, g_cei[l_ac].cei17,
                      g_cei[l_ac].cei18, g_cei[l_ac].cei20,
                      g_cei[l_ac].cei22 
END FUNCTION
 
 
FUNCTION i760_y()
 IF g_rec_b=0 THEN RETURN END IF          
 CALL i760_mod_upd_cei15("Y")
END FUNCTION
 
FUNCTION i760_z()
 IF g_rec_b=0 THEN RETURN END IF          
 CALL i760_mod_upd_cei15("Z")
END FUNCTION
 
FUNCTION i760_mod_upd_cei15(p_act)
  DEFINE p_act    LIKE type_file.chr1   #審核碼"Y":確認   "N":取消確認
  DEFINE l_wc2    STRING
  DEFINE l_rec_b  LIKE type_file.num5
  DEFINE l_cnt    LIKE type_file.num5
  DEFINE l_i      LIKE type_file.num5
  DEFINE l_cnt1   LIKE type_file.num5
  DEFINE l_cei15_old  LIKE cei_file.cei15
  DEFINE l_cei15_new  LIKE cei_file.cei15
  DEFINE l_ac2    LIKE type_file.num5,
    l_cei           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        sel         LIKE type_file.chr1,     #選擇
        cei02       LIKE cei_file.cei02,     #序號   
        cei03       LIKE cei_file.cei03,     #廠內料號 
        cei04       LIKE cei_file.cei04,     #海關商品編號    
        ima02          LIKE ima_file.ima02,  #品名
        ima021         LIKE ima_file.ima021, #規格
        cei05       LIKE cei_file.cei05,     #幣別
        cei06       LIKE cei_file.cei06,     #歸併前單價
        cei07       LIKE cei_file.cei07,     #企業使用單位  
        cei08       LIKE cei_file.cei08,     #申報計量單位
        cei09       LIKE cei_file.cei09,     #法定計量單位 
        cei10       LIKE cei_file.cei10,     #法定計量單位轉換比率 
        cei11       LIKE cei_file.cei11,     #歸併後序號 
        cei12       LIKE cei_file.cei12,     #歸併後品名
        cei13       LIKE cei_file.cei13,     #歸併後規格
        cei14       LIKE cei_file.cei14      #歸併後單價
     END RECORD
 
  IF p_act = 'Y' THEN      #確認
     LET l_cei15_old = 'N' 
     LET l_cei15_new = 'Y' 
  ELSE                     #取消確認
     LET l_cei15_old = 'Y' 
     LET l_cei15_new = 'N' 
  END IF
  LET l_wc2 = g_wc ," AND cei15 = '", l_cei15_old CLIPPED,"' AND ceiacti = 'Y'"
   
 
  LET g_sql = "SELECT 'N',cei02,cei03,cei04,'','',", 
              "       cei05,cei06,cei07,cei08,cei09,cei10,",
              "       cei11,cei12,cei13,cei14",
              " FROM cei_file  ",
              " WHERE cei01 = '",g_cei01,"' ",
              "   AND cei04 <> ' ' ",      #已有歸併後序號
              "   AND ", l_wc2 CLIPPED,    
              " ORDER BY 1"                        
  PREPARE i7602_pb FROM g_sql
  DECLARE cei_cur2 CURSOR FOR i7602_pb
  
  CALL l_cei.clear()   
  LET l_cnt = 1
  FOREACH cei_cur2 INTO l_cei[l_cnt].*   
    IF p_act = 'Z' THEN  #取消確認時要判斷是否已被引用
       LET l_cnt1 = 0
 
       SELECT COUNT(*) INTO l_cnt1 FROM ceu_file   #進口報關清單
         WHERE ceu04=l_cei[l_cnt].cei03
       IF l_cnt1 > 0 THEN CONTINUE FOREACH END IF
 
       SELECT COUNT(*) INTO l_cnt1 FROM cet_file   #出口報關清單
         WHERE cet04=l_cei[l_cnt].cei03
       IF l_cnt1 > 0 THEN CONTINUE FOREACH END IF
 
       SELECT COUNT(*) INTO l_cnt1 FROM cej_file #歸併前BOM單頭
         WHERE cej04=l_cei[l_cnt].cei03
       IF l_cnt1 > 0 THEN CONTINUE FOREACH END IF
 
       SELECT COUNT(*) INTO l_cnt1 FROM cek_file #歸併前BOM單身
         WHERE cek06=l_cei[l_cnt].cei03
       IF l_cnt1 > 0 THEN CONTINUE FOREACH END IF
 
    END IF
 
    SELECT ima02,ima021
      INTO l_cei[l_cnt].ima02, 
           l_cei[l_cnt].ima021
      FROM ima_file
     WHERE ima01 = l_cei[l_cnt].cei03 
    LET l_cnt = l_cnt + 1
  END FOREACH
  CALL l_cei.deleteElement(l_cnt)
  LET l_rec_b = l_cnt - 1
 
  IF l_rec_b > 0 THEN
    OPEN WINDOW i760_w3 AT 10,21 WITH FORM "aco/42f/acoi7602"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL  cl_ui_locale("acoi7602")
 
    DISPLAY ARRAY l_cei TO s_cei2.* ATTRIBUTE(COUNT=l_rec_b,UNBUFFERED)
      BEFORE DISPLAY
        EXIT DISPLAY
    END DISPLAY
  
    INPUT ARRAY l_cei WITHOUT DEFAULTS FROM s_cei2.*
               ATTRIBUTE (COUNT=l_rec_b,MAXCOUNT=g_max_rec, UNBUFFERED, 
                          INSERT ROW = FALSE, DELETE ROW=FALSE,
                          APPEND ROW = FALSE)
       BEFORE ROW
          LET l_ac2 = ARR_CURR()
 
          AFTER FIELD sel
              IF NOT cl_null(l_cei[l_ac2].sel) THEN
                 IF l_cei[l_ac2].sel NOT MATCHES "[YN]" THEN
                    NEXT FIELD sel
                 END IF
              END IF
 
           ON ACTION CONTROLR
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
 
           ON ACTION select_all  
              FOR l_i = 1 TO l_cei.getLength() 
                 LET l_cei[l_i].sel="Y"
              END FOR
              LET l_ac = ARR_CURR()
 
           ON ACTION select_none 
              FOR l_i = 1 TO l_cei.getLength() 
                 LET l_cei[l_i].sel="N"
              END FOR
              LET l_ac = ARR_CURR()
 
    END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG=0
       CLOSE WINDOW i760_w3
       RETURN
    END IF
 
    BEGIN WORK
    LET g_success = 'Y'
    FOR l_i = 1 TO l_cei.getLength() 
      IF l_cei[l_i].sel = 'Y' THEN
         UPDATE cei_file
            SET cei15 = l_cei15_new
          WHERE cei01=g_cei01
            AND cei02=l_cei[l_i].cei02
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","cei_file",g_cei01,l_cei[l_i].cei02,SQLCA.sqlcode,"","",1) 
            LET g_success = 'Y'
         END IF
      END IF
    END FOR
    IF g_success = 'Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
 
    CLOSE WINDOW i760_w3
    
    CALL i760_b_fill(g_wc)
  ELSE
    IF p_act = 'Y' THEN
      CALL cl_err('','aco-730',1)
    ELSE
      CALL cl_err('','aco-731',1)
    END IF
  END IF 
END FUNCTION
 
FUNCTION i760_set_init()
  CALL cl_set_comp_entry("cei02,cei03,cei07,cei08,cei19,cei22",FALSE) 
END FUNCTION
#FUN-930151
