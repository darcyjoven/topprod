# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: abmi600_a.4gl
# Descriptions...: 分量損耗率維護作業
# Date & Author..: 07/07/16 By arman 
# Modify.........: No.FUN-810014 08/03/21 By arman 服飾版程序
# Modify.........: No.FUN-830116 08/04/15 By ve007 debug 810014
# Modify.........: No.FUN-840155 08/04/21 By arman 顯示固定屬性有誤
# Modify.........: No.FUN-840178 08/04/24 By arman 固定屬性修改 
# Modify.........: No.FUN-870127 08/07/24 By arman 服飾版
# Modify.........: No.FUN-880072 08/08/19 By jan 服飾版過單
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_bmv           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        bmv09       LIKE bmv_file.bmv09,   #項次
        bmv04       LIKE bmv_file.bmv04,   #屬性代碼
        bmv04_agc02 LIKE agc_file.agc02,   #屬性名稱
        bmv08       LIKE bmv_file.bmv08,   #固定屬性類型
        bmv07       LIKE bmv_file.bmv07,   #主件屬性代碼
        bmv07_agc02 LIKE agc_file.agc02,   #主件屬性名稱
        bmv05       LIKE bmv_file.bmv05,   #生效日期                          
        bmv06       LIKE bmv_file.bmv06    #失效日期                          
                    END RECORD,
    g_bmv_t         RECORD                 #程式變數 (舊值)
        bmv09       LIKE bmv_file.bmv09,   #項次
        bmv04       LIKE bmv_file.bmv04,   #屬性代碼                            
        bmv04_agc02 LIKE agc_file.agc02,   #屬性名稱                            
        bmv08       LIKE bmv_file.bmv08,   #固定屬性類型                                
        bmv07       LIKE bmv_file.bmv07,   #主件屬性代碼                    
        bmv07_agc02 LIKE agc_file.agc02,   #主件屬性名稱                 
        bmv05       LIKE bmv_file.bmv05,   #生效日期                         
        bmv06       LIKE bmv_file.bmv06    #失效日期
                    END RECORD,
    g_wc2,g_sql,g_sql1,g_sql2,g_sql3,g_wc1    STRING,  
    l_za05          LIKE type_file.chr1000, 
    g_flag          LIKE type_file.chr1,    
    g_rec_b         LIKE type_file.num5,    
    p_row,p_col     LIKE type_file.num5,    
    l_ac            LIKE type_file.num5     
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL        
DEFINE   g_cnt           LIKE type_file.num10            
DEFINE   g_cnt1          LIKE type_file.num10
DEFINE   g_cnt2          LIKE type_file.num10
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        
DEFINE   g_before_input_done    LIKE type_file.num5     
DEFINE g_bmv_bmv04 LIKE bmv_file.bmv04
DEFINE g_bmv_bmv05 LIKE bmv_file.bmv05
DEFINE g_bma10          LIKE bma_file.bma10
DEFINE g_bmb03          LIKE bmb_file.bmb03
DEFINE g_bmb01          LIKE bmb_file.bmb01
DEFINE g_md             LIKE type_file.chr1
DEFINE g_bma06          LIKE bma_file.bma06
 
FUNCTION i600_a_fix_sx(p_bma10,p_bmb03,p_bmb01,p_md,p_bma06)
DEFINE p_bma10          LIKE bma_file.bma10
DEFINE p_bmb03          LIKE bmb_file.bmb03
DEFINE p_bmb01          LIKE bmb_file.bmb01
DEFINE p_md             LIKE type_file.chr1
DEFINE p_bma01          LIKE bma_file.bma01
DEFINE p_bma06          LIKE bma_file.bma06
DEFINE l_m              LIKE type_file.num5
 
   WHENEVER ERROR CALL cl_err_msg_log  
 
   OPEN WINDOW i600_a_w AT p_row,p_col WITH FORM "abm/42f/abmi600_a"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)     
    call cl_ui_locale("abmi600_a")
#   CALL cl_ui_init()
    LET g_md = p_md    
    LET g_bma10 = p_bma10
    LET g_bmb03 = p_bmb03
    LET g_bmb01 = p_bmb01
    LET g_bma06 = p_bma06   #NO.FUN-810014
    SELECT COUNT(*) INTO l_m FROM bmv_file WHERE bmv01= g_bmb01 AND bmv02= g_bmb03  AND bmv03 = g_bma06  #NO.FUN-840178  add bmv03
   # IF l_m >0 THEN
   #  LET g_wc2 = " bmv01 = '",g_bmb01,"'  AND bmv02 = '",g_bmb03,"' " 
   #   IF g_md IS NULL THEN
   #     CALL i600_a_b_fill(g_wc2)
   #   END IF
   # ELSE 
   #   IF g_md IS NOT NULL THEN
        CALL i600_a_menu()
   #   END IF
   # END IF
    CLOSE WINDOW i600_a_w                 #結束畫面
      LET g_rec_b = 0
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
         RETURNING g_time    
END FUNCTION
 
FUNCTION i600_a_menu()
 
   WHILE TRUE
      CALL i600_a_bp("G")
      CASE g_action_choice
#        WHEN "query" 
#           IF cl_chk_act_auth() THEN 
#              CALL i600_a_q() 
#           END IF
         WHEN "detail"  
            IF cl_chk_act_auth() THEN 
#             IF g_md = 'u' THEN         #No.FUN-830116
               CALL i600_a_b()
#             END IF                     #No.FUN-830116  
            ELSE
               LET g_action_choice = NULL
            END IF
#        WHEN "delete"
#           IF cl_chk_act_auth() THEN
#              CALL i600_del()
#           END IF
#         WHEN "output" 
#            IF cl_chk_act_auth() THEN 
#               CALL i600_a_out()
#            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"     
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bmv),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i600_a_q()
   CALL i600_a_b_askkey()
END FUNCTION
 
FUNCTION i600_a_b()
DEFINE
    l_bmv04         LIKE  bmv_file.bmv04,
    l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT        
    l_n             LIKE type_file.num5,          #檢查重複用       
    l_n1            LIKE type_file.num5,          #檢查重復用
    l_n2            LIKE type_file.num5,          #檢查重複用       
    l_n3            LIKE type_file.num5,          #檢查重複用       
    l_n4            LIKE type_file.num5,          #檢查重複用       
    l_bmv05         LIKE bmv_file.bmv05,
    l_lock_sw       LIKE type_file.chr1,          #單身鎖住否        
    p_cmd           LIKE type_file.chr1,          #處理狀態 
    l_allow_insert  LIKE type_file.chr1,          #可新增否
    l_allow_delete  LIKE type_file.chr1           #可刪除否
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF

    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
    LET g_forupd_sql = "SELECT bmv09,bmv04,' ',bmv08,bmv07,' ',bmv05,bmv06 FROM bmv_file ",
                       " WHERE bmv01=? AND bmv02=? AND bmv03 =? AND bmv04 = ?  AND bmv05 =? FOR UPDATE "   #NO.FUN-840178   add bmv03 bmv04 bmv05
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i600_a_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_bmv WITHOUT DEFAULTS FROM s_bmv.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT                                                              
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_bmv_t.* = g_bmv[l_ac].*         #新輸入資料
               LET g_before_input_done = FALSE                                                                                      
               CALL i600_a_set_entry(p_cmd)                                                                                           
#              CALL i600_a_set_no_entry(p_cmd)       #by arman 080619                                                                                
               LET g_before_input_done = TRUE                                                                                       
 
            BEGIN WORK
 
               OPEN i600_a_bcl USING g_bmb01,g_bmb03,g_bma06,g_bmv_t.bmv04,g_bmv_t.bmv05 
 
               IF STATUS THEN
                  CALL cl_err("OPEN i600_a_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i600_a_bcl INTO g_bmv[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(" ",STATUS,1) 
                     LET l_lock_sw = "Y"
                  END IF
                 SELECT agc02 INTO g_bmv[l_ac].bmv04_agc02 FROM agc_file WHERE agc01 = g_bmv[l_ac].bmv04
                 SELECT agc02 INTO g_bmv[l_ac].bmv07_agc02 FROM agc_file WHERE agc01 = g_bmv[l_ac].bmv07
               END IF
               CALL cl_show_fld_cont()     
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET g_before_input_done = FALSE                                                                                      
            CALL i600_a_set_entry(p_cmd)                                                                                           
#           CALL i600_a_set_no_entry(p_cmd)      #by arman 080619                                                                                  
            LET g_before_input_done = TRUE                                                                                       
            INITIALIZE g_bmv[l_ac].* TO NULL             
            LET g_bmv_t.* = g_bmv[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     
            NEXT FIELD bmv09
 
      AFTER INSERT
         IF INT_FLAG THEN                 
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF g_bma06 IS NULL THEN
            LET g_bma06 = ' '
         END IF
          INSERT INTO bmv_file(bmv01,bmv02,bmv03,bmv04,bmv05,bmv06,bmv07,bmv08,bmv09)
          VALUES (g_bmb01,g_bmb03,g_bma06,
                  g_bmv[l_ac].bmv04,
                  g_bmv[l_ac].bmv05,g_bmv[l_ac].bmv06,
                  g_bmv[l_ac].bmv07,g_bmv[l_ac].bmv08,
                  g_bmv[l_ac].bmv09)
           IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","bmv_file",g_bmv[l_ac].bmv04,g_bmv[l_ac].bmv08,SQLCA.sqlcode,"","",1) 
               CANCEL INSERT
           ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2 
           END IF
 
        BEFORE FIELD bmv09
           IF g_bmv[l_ac].bmv09 IS NULL OR g_bmv[l_ac].bmv09 =0 THEN
                SELECT  MAX(bmv09)+1
                INTO g_bmv[l_ac].bmv09
                FROM bmv_file
                WHERE bmv01= g_bmb01
                  AND bmv02= g_bmb03   #NO.FUN-840178
                  AND bmv03= g_bma06   #NO.FUN-840178
             IF g_bmv[l_ac].bmv09 IS NULL THEN
                LET g_bmv[l_ac].bmv09 = 1
             END IF
           END IF
        AFTER FIELD bmv09
#No.FUN-870127
          IF NOT cl_null(g_bmv[l_ac].bmv09) THEN
             IF g_bmv[l_ac].bmv09!=g_bmv_t.bmv09
                OR g_bmv_t.bmv09 IS NULL THEN
                SELECT count(*) INTO l_n4 FROM bmv_file
                 WHERE bmv01= g_bmb01                                            
                   AND bmv02= g_bmb03
                   AND bmv03= g_bma06   
                   AND bmv09= g_bmv[l_ac].bmv09
                 IF l_n4>0 THEN
                  CALL cl_err('',-239,0)
                  LET g_bmv[l_ac].bmv09 =g_bmv_t.bmv09
                 END IF
             END IF
          END IF
#No.FUN-870127--END-
#         NEXT FIELD bmv04
        AFTER FIELD bmv04                                                       
          IF NOT cl_null(g_bmv[l_ac].bmv04) THEN                              
          CALL i600_a_bmv04()
               IF NOT cl_null(g_errno) THEN                                     
                  CALL cl_err('',g_errno,0)                                     
                  LET g_bmv[l_ac].bmv04=g_bmv_t.bmv04                           
                  NEXT FIELD bmv04                                              
               END IF
               SELECT COUNT(*) INTO l_n2 FROM agb_file,aga_file,ima_file
               WHERE agb01=aga01 and aga01=imaag and ima01=g_bmb03
               IF l_n2<=0 THEN   
                    NEXT FIELD bmv04
               END IF                                                         
               #FUN-870127 ---BEGIN
               IF p_cmd = 'a' THEN
               LET l_n2 = 0
               SELECT COUNT(*) INTO l_n2 FROM bmv_file WHERE  bmv01 = g_bmb01
                                                         AND  bmv02 = g_bmb03
                                                         AND  bmv03 = g_bma06
                                                         AND  bmv04 = g_bmv[l_ac].bmv04
                IF l_n2>0 THEN   
                    CALL cl_err('','abm-028',0)
                    NEXT FIELD bmv04
                END IF                                                         
               END IF
               #FUN-870127 ---end
          ELSE
                NEXT FIELD bmv04
          END IF
         #CALL i600_a_bmv04()
        AFTER FIELD bmv05
            IF NOT cl_null(g_bmv[l_ac].bmv05) THEN
              IF NOT cl_null(g_bmv[l_ac].bmv06) THEN
                  IF g_bmv[l_ac].bmv05 > g_bmv[l_ac].bmv06 THEN
                          NEXT FIELD bmv05
                  END IF
               END IF
            END IF
        AFTER FIELD bmv06
            IF NOT cl_null(g_bmv[l_ac].bmv06) THEN
                IF g_bmv[l_ac].bmv06<g_bmv[l_ac].bmv05 THEN 
                        NEXT FIELD bmv06
                END IF
            END IF
        AFTER FIELD bmv07                                                       
            IF NOT cl_null(g_bmv[l_ac].bmv07) THEN                              
            #by arman 080619
            IF g_bmv[l_ac].bmv08 ='1'  THEN
              CALL i600_a_bmv07() 
            END IF
            IF g_bmv[l_ac].bmv08 ='2'  THEN
              CALL i600_a_bmv07_2() 
            END IF
            #by arman 080619
               IF NOT cl_null(g_errno) THEN                                     
                  CALL cl_err('',g_errno,0)                                     
                  LET g_bmv[l_ac].bmv07=g_bmv_t.bmv07                           
                  NEXT FIELD bmv07                                              
               END IF
               IF g_bmv[l_ac].bmv08 ='1'  THEN
                 SELECT COUNT(*) INTO l_n3 FROM agb_file,aga_file,ima_file
                             where agb01= aga01 and aga01=imaag and ima01=g_bmb01 and agb03=g_bmv[l_ac].bmv07
               ELSE IF g_bmv[l_ac].bmv08 = '2'  THEN
                 SELECT COUNT(*) INTO l_n3 FROM agd_file,agc_file
                  where  (agd02=g_bmv[l_ac].bmv07 and agd01= agc01 and agc04='2'   and agc01=g_bmv[l_ac].bmv04)
                  or (g_bmv[l_ac].bmv07 between agc05 and agc06 and agc04='3' and agc01=g_bmv[l_ac].bmv04)
                  or (agc04='1' and agc01=g_bmv[l_ac].bmv04)
                  END IF
               END IF
               IF l_n3 <=0 THEN
                  NEXT FIELD bmv07
               END IF
            ELSE
                  NEXT FIELD bmv07
            END IF
        AFTER FIELD bmv08
            IF  cl_null(g_bmv[l_ac].bmv08) THEN
                NEXT FIELD bmv08
            END IF 
        BEFORE DELETE                            #是否取消單身
             IF g_bmv_t.bmv04 IS NOT NULL AND
                g_bmv_t.bmv08 IS NOT NULL AND
                g_bmv_t.bmv07 IS NOT NULL AND
                g_bmv_t.bmv05 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
            DELETE FROM bmv_file
                WHERE bmv01 = g_bmb01
                  AND bmv02 = g_bmb03
                  AND bmv03 = g_bma06
                  AND bmv04 = g_bmv_t.bmv04
                  AND bmv05 = g_bmv_t.bmv05 
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","bmv_file",g_bmv[l_ac].bmv04,g_bmv[l_ac].bmv08,SQLCA.sqlcode,"","",1) 
                ROLLBACK WORK
                CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2 
            MESSAGE "Delete OK" 
            CLOSE i600_a_bcl     
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_bmv[l_ac].* = g_bmv_t.*
              CLOSE i600_a_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(" ",-263,1)
              LET g_bmv[l_ac].* = g_bmv_t.*
           ELSE
              UPDATE bmv_file SET bmv09=g_bmv[l_ac].bmv09,
                                  bmv04=g_bmv[l_ac].bmv04,
                                  bmv08=g_bmv[l_ac].bmv08,
                                  bmv07=g_bmv[l_ac].bmv07,
                                  bmv05=g_bmv[l_ac].bmv05,
                                  bmv06=g_bmv[l_ac].bmv06                      
                WHERE bmv01 = g_bmb01 
                  AND bmv02 = g_bmb03                                    
                  AND bmv03 = g_bma06       #NO.FUN-840178
                  AND bmv04 = g_bmv_t.bmv04 #NO.FUN-840178
                  AND bmv05 = g_bmv_t.bmv05 #NO.FUN-840178
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","bmv_file",g_bmv[l_ac].bmv04,g_bmv[l_ac].bmv08,SQLCA.sqlcode,"","update bmv error",1) 
                   LET g_bmv[l_ac].* = g_bmv_t.*
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
               IF p_cmd='u' THEN
                  LET g_bmv[l_ac].* = g_bmv_t.*                                    
               #FUN-D40030--add--str--
               ELSE
                  CALL g_bmv.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i600_a_bcl                                                   
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                                              
            LET l_ac_t = l_ac  #FUN-D40030 
            CLOSE i600_a_bcl                                                      
            COMMIT WORK            
 
        ON ACTION CONTROLN
            CALL i600_a_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp
           CASE 
              WHEN INFIELD(bmv04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_bmv04"
                 LET g_qryparam.default1 = g_bmv[l_ac].bmv04
                 LET g_qryparam.arg1 = g_bmb03
                 CALL cl_create_qry() RETURNING g_bmv[l_ac].bmv04
                 CALL FGL_DIALOG_SETBUFFER( g_bmv[l_ac].bmv04 )
                 DISPLAY BY NAME g_bmv[l_ac].bmv04
                 NEXT FIELD bmv04
              WHEN INFIELD(bmv07)
                   CALL cl_init_qry_var()  
                   IF g_bmv[l_ac].bmv08 = "1" THEN  
                      LET g_qryparam.form = "q_bmv07" 
                      LET g_qryparam.arg1 = g_bmb01
                   ELSE 
                      IF g_bmv[l_ac].bmv08 = "2" THEN
                         LET g_qryparam.form ="q_bmv07_1"
                         LET g_qryparam.arg1 = g_bmv[l_ac].bmv04
                         
                      END IF
                   END IF    
                   
                   CALL cl_create_qry() RETURNING g_bmv[l_ac].bmv07 
                   CALL FGL_DIALOG_SETBUFFER( g_bmv[l_ac].bmv07 ) 
                   DISPLAY BY NAME g_bmv[l_ac].bmv07       
                   NEXT FIELD bmv07
               OTHERWISE EXIT CASE
           END CASE
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
        
        END INPUT
 
    CLOSE i600_a_bcl
    COMMIT WORK
#   OPTIONS
#       INSERT KEY F1,
#       DELETE KEY F2
END FUNCTION
 
FUNCTION i600_a_b_askkey()
    CLEAR FORM
    CALL g_bmv.clear()
    IF g_bma10 = 0 THEN RETURN END IF
    CONSTRUCT g_wc2 ON bmv04, bmv04_agc02, bmv08, bmv07, bmv07_agc02,
                       bmv05,bmv06
            FROM s_bmv[1].bmv04,s_bmv[1].bmv04_agc02,s_bmv[1].bmv08,
                 s_bmv[1].bmv07,s_bmv[1].bmv07_agc02,
                 s_bmv[1].bmv05,s_bmv[1].bmv06
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
    CALL i600_a_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i600_a_b_fill(p_wc2)              
DEFINE
#    p_wc2       LIKE type_file.chr1000  
    p_wc2        STRING     #NO.FUN-910082 
 
    LET g_sql =
        " SELECT bmv09,bmv04,' ',bmv08,bmv07,' ',",                          
        " bmv05,bmv06", 
        " FROM   bmv_file " ,
        " WHERE  ", p_wc2 CLIPPED,"" 
    PREPARE i600_a_pb FROM g_sql
    DECLARE bmv_curs CURSOR FOR i600_a_pb
 
    CALL g_bmv.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH bmv_curs INTO g_bmv[g_cnt].*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
          SELECT agc02 INTO g_bmv[g_cnt].bmv04_agc02 FROM agc_file WHERE agc01 = g_bmv[g_cnt].bmv04
          IF g_bmv[g_cnt].bmv08 ='1'  THEN 
              SELECT agc02 INTO g_bmv[g_cnt].bmv07_agc02 FROM agc_file WHERE agc01 = g_bmv[g_cnt].bmv07 
          END IF
          IF g_bmv[g_cnt].bmv08 ='2'  THEN 
              SELECT agd02 INTO g_bmv[g_cnt].bmv07_agc02 FROM agd_file WHERE agd01 = g_bmv[g_cnt].bmv04 AND agd02 = g_bmv[g_cnt].bmv07 
          END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_bmv.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2 
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i600_a_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
   DEFINE l_m              LIKE type_file.num5
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
 
   LET g_action_choice = " "
   CALL g_bmv.clear()
#   SELECT COUNT(*) INTO l_m FROM bmv_file WHERE bmv01= g_bmb01 AND bmv02= g_bmb03       #No.FUN-840155
    SELECT COUNT(*) INTO l_m FROM bmv_file WHERE bmv01= g_bmb01 AND bmv02= g_bmb03  AND bmv03 = g_bma06   #No.FUN-840155
    IF l_m >0 THEN
     LET g_wc2 = " bmv01 = '",g_bmb01,"'  AND bmv02 = '",g_bmb03,"'  AND bmv03 = '",g_bma06,"' "   #NO.FUN-840178  add bmv03
        CALL i600_a_b_fill(g_wc2)
    END IF
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bmv TO s_bmv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
#     IF g_md = 'u' THEN      #by arman 080619
         LET g_action_choice="detail"
         EXIT DISPLAY
#     END IF                  #by arman 080619
#     ON ACTION delete 
#        LET g_action_choice="delete"
#        EXIT DISPLAY
#      ON ACTION output
#         LET g_action_choice="output"
#         EXIT DISPLAY
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
 
FUNCTION i600_a_bmv01(p_cmd)                                            
    DEFINE l_agc02    LIKE agc_file.agc02,                                      
           l_agcacti  LIKE agc_file.agc02,                                    
           p_cmd      LIKE type_file.chr1                                                
                                                                                
     LET g_errno = ' '                                                          
     SELECT agc02,agcacti INTO l_agc02,l_agcacti                                
       FROM agc_file WHERE agc01 = g_bmv[l_ac].bmv04                            
                                                                                
     CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'                     
                             LET l_agc02 = NULL                                 
          WHEN l_agcacti='N' LET g_errno = '9028'                               
          OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'        
     END CASE                                                                   
                                                                                
      IF cl_null(g_errno) OR p_cmd = 'd' THEN                              
         LET g_bmv[l_ac].bmv04_agc02 = l_agc02                                        
      END IF
                                                                               
END FUNCTION
 
FUNCTION i600_a_bmv03(p_cmd)                                                      
    DEFINE l_agc02    LIKE agc_file.agc02,                                      
           l_agcacti  LIKE agc_file.agc02,    
           l_imz02    LIKE imz_file.imz02,
           l_imzacti  LIKE imz_file.imzacti,                                
           p_cmd      LIKE type_file.chr1    
    IF g_bmv[l_ac].bmv08 = "1" THEN                                            
     LET g_errno = ' '                                                          
     SELECT agc02,agcacti INTO l_agc02,l_agcacti                                
       FROM agc_file WHERE agc01 = g_bmv[l_ac].bmv07                            
                                                                                
     CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'                     
                             LET l_agc02 = NULL                                 
          WHEN l_agcacti='N' LET g_errno = '9028'                               
          OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'        
     END CASE                                                                   
                                                                                
      IF cl_null(g_errno) OR p_cmd = 'd' THEN                                       
         LET g_bmv[l_ac].bmv07_agc02 = l_agc02                                  
                                                                                
      END IF
     END IF
     
     IF g_bmv[l_ac].bmv08 = "2" THEN                                             
      LET g_errno = ' '                                                          
      SELECT imz02,imzacti INTO l_imz02,l_imzacti                                
        FROM imz_file WHERE imz01 = g_bmv[l_ac].bmv07                            
                                                                                
      CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'                     
                             LET l_imz02 = NULL                                 
          WHEN l_imzacti='N' LET g_errno = '9028'                               
          OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'        
      END CASE                                                                   
                                                                                
      IF cl_null(g_errno) OR p_cmd = 'd' THEN                                         
         LET g_bmv[l_ac].bmv07_agc02 = l_imz02                                  
                                                                                
      END IF                                                                    
     END IF                                                                    
                                                                                
END FUNCTION
FUNCTION i600_a_set_entry(p_cmd)                                                                                                      
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1                     
                                                                                                                                    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("bmv04,bmv08,bmv07,bmv04,bmv05",TRUE)                                                                                           
  END IF                                                                                                                            
                                                                                                                                    
END FUNCTION                                                                                                                        
#by arman 080619
#UNCTION i600_a_set_no_entry(p_cmd)                                                                                                   
# DEFINE p_cmd   LIKE type_file.chr1             
#  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
#    CALL cl_set_comp_entry("bmv04,bmv08,bmv07,bmv04,bmv05",FALSE)                                                                                          
#  END IF                                                                                                                           
#                                                                                                                                   
#ND FUNCTION                                                                                                                        
#by arman 080619 
FUNCTION i600_a_bmv04()
 DEFINE l_agc02 LIKE agc_file.agc02
 
 LET g_errno = " "
 SELECT agc02 INTO l_agc02 FROM agc_file WHERE agc01 = g_bmv[l_ac].bmv04
 CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'ask-391'
                                LET l_agc02 = NULL
      OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
 END CASE
 LET g_bmv[l_ac].bmv04_agc02 = l_agc02
 DISPLAY BY NAME g_bmv[l_ac].bmv04_agc02   
END FUNCTION
 
FUNCTION i600_a_bmv07()
 DEFINE l_agc02 LIKE agc_file.agc02
 
 LET g_errno = " "
 SELECT agc02 INTO l_agc02 FROM agc_file WHERE agc01 = g_bmv[l_ac].bmv07
 CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'ask-391'
                                LET l_agc02 = NULL
      OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
 END CASE
 LET g_bmv[l_ac].bmv07_agc02 = l_agc02
 DISPLAY BY NAME g_bmv[l_ac].bmv07_agc02   
END FUNCTION
 
FUNCTION i600_a_bmv07_2()
 DEFINE l_agd02 LIKE agd_file.agd02
 
 LET g_errno = " "
 SELECT agd02 INTO l_agd02 FROM agd_file WHERE agd01 = g_bmv[l_ac].bmv04 AND agd02 = g_bmv[l_ac].bmv07 
 CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'ask-391'
                                LET l_agd02 = NULL
      OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
 END CASE
 LET g_bmv[l_ac].bmv07_agc02 = l_agd02
 DISPLAY BY NAME g_bmv[l_ac].bmv07_agc02   
END FUNCTION
#NO.FUN-870127 ---end
#No.FUN-880072
