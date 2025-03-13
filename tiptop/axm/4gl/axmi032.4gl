# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: axmi032.4gl
# Descriptions...: 單位運費維護作業
# Date & Author..: 94/12/30 By Danny
 # Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0038 04/11/15 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-570109 05/07/15 By jackie 修正建檔程式key值是否可更改  
# Modify.........: No.MOD-580212 05/09/08 By ice  修改報表列印格式
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/08/31 By bnlent 欄位型態定義，改為LIKE
#
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0079 06/11/6 By king 改正被誤定義為apm08類型的
# Modify.........: No.TQC-6B0089 06/11/16 By day 輸入不存在的運輸地點時要報錯
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.TQC-740129 07/04/18 By sherry  維護"到達地點編號"報錯信息。
                                             #.....  打印時“到達地點”欄位維護過短。
# Modify.........: No.TQC-790064 07/09/11 By dxfwo 運費輸入負數無控管
# Modify.........: No.TQC-790126 07/09/24 By destiny 修改錄入地點編號報“無此地址編號”的bug
# Modify.........: No.FUN-7C0043 07/12/19 By Sunyanchun    老報表改成p_query
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_oad           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        oad01       LIKE oad_file.oad01,  
        oac02_1     LIKE oac_file.oac02,
        oad02       LIKE oad_file.oad02, 
        oac02_2     LIKE oac_file.oac02,
        oad041      LIKE oad_file.oad041,
        oad042      LIKE oad_file.oad042,
        oad043      LIKE oad_file.oad043,
        oad051      LIKE oad_file.oad051,
        oad052      LIKE oad_file.oad052,
        oad053      LIKE oad_file.oad053
                    END RECORD,
    g_oad_t         RECORD 
        oad01       LIKE oad_file.oad01,  
        oac02_1     LIKE oac_file.oac02,
        oad02       LIKE oad_file.oad02, 
        oac02_2     LIKE oac_file.oac02,
        oad041      LIKE oad_file.oad041,
        oad042      LIKE oad_file.oad042,
        oad043      LIKE oad_file.oad043,
        oad051      LIKE oad_file.oad051,
        oad052      LIKE oad_file.oad052,
        oad053      LIKE oad_file.oad053
                    END RECORD,
    g_wc2,g_sql     string,  #No.FUN-580092 HCN           
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
DEFINE g_forupd_sql string   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_before_input_done    LIKE type_file.num5     #No.FUN-570109            #No.FUN-680137 SMALLINT
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0094
 
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
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
    LET p_row = 3 LET p_col = 3
 
    OPEN WINDOW i032_w AT p_row,p_col WITH FORM "axm/42f/axmi032"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
        
    LET g_wc2 = '1=1' CALL i032_b_fill(g_wc2)
    CALL i032_menu()
    CLOSE WINDOW i032_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 
FUNCTION i032_menu()
DEFINE l_cmd  LIKE type_file.chr1000           #No.FUN-7C0043---add---
   WHILE TRUE
      CALL i032_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i032_q() 
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i032_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i032_out() 
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oad),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i032_q()
   CALL i032_b_askkey()
END FUNCTION
 
FUNCTION i032_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680137 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680137 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT oad01,'',oad02,'',oad041,oad042,oad043,",
                       " oad051,oad052,oad053 FROM oad_file ",
                       " WHERE oad01=? AND oad02=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i032_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_oad WITHOUT DEFAULTS FROM s_oad.*
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
               LET g_oad_t.* = g_oad[l_ac].*  #BACKUP
#No.FUN-570109 --start--                                                                                                            
               LET g_before_input_done = FALSE                                                                                      
               CALL i032_set_entry_b(p_cmd)                                                                                         
               CALL i032_set_no_entry_b(p_cmd)                                                                                      
               LET g_before_input_done = TRUE                                                                                       
#No.FUN-570109 --end--      
               BEGIN WORK
 
               OPEN i032_bcl USING g_oad_t.oad01,g_oad_t.oad02
               IF STATUS THEN
                  CALL cl_err("OPEN i032_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i032_bcl INTO g_oad[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_oad_t.oad01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     SELECT oac02 INTO g_oad[l_ac].oac02_1
                       FROM oac_file WHERE oac01=g_oad[l_ac].oad01
                     IF STATUS THEN LET g_oad[l_ac].oac02_1='' END IF
                     SELECT oac02 INTO g_oad[l_ac].oac02_2
                       FROM oac_file WHERE oac01=g_oad[l_ac].oad02
                     IF STATUS THEN LET g_oad[l_ac].oac02_2='' END IF
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO oad_file(oad01,oad02,oad041,oad042,oad043,
                                 oad051,oad052,oad053)
            VALUES(g_oad[l_ac].oad01,g_oad[l_ac].oad02,
                   g_oad[l_ac].oad041,g_oad[l_ac].oad042,
                   g_oad[l_ac].oad043,g_oad[l_ac].oad051,
                   g_oad[l_ac].oad052,g_oad[l_ac].oad053)
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_oad[l_ac].oad01,SQLCA.sqlcode,0)   #No.FUN-660167
                CALL cl_err3("ins","oad_file",g_oad[l_ac].oad01,g_oad[l_ac].oad02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
            #--Move original INSERT block from AFTER ROW to here
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570109 --start--                                                                                                            
            LET g_before_input_done = FALSE                                                                                      
            CALL i032_set_entry_b(p_cmd)                                                                                         
            CALL i032_set_no_entry_b(p_cmd)                                                                                      
            LET g_before_input_done = TRUE                                                                                       
#No.FUN-570109 --end--      
            INITIALIZE g_oad[l_ac].* TO NULL      #900423
            LET g_oad_t.* = g_oad[l_ac].*         #新輸入資料
            LET g_oad[l_ac].oad041=0 LET g_oad[l_ac].oad042=0
            LET g_oad[l_ac].oad043=0 LET g_oad[l_ac].oad051=0
            LET g_oad[l_ac].oad052=0 LET g_oad[l_ac].oad053=0
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD oad01
 
        AFTER FIELD oad01  
           IF not cl_null(g_oad[l_ac].oad01) THEN 
              SELECT oac02 INTO g_oad[l_ac].oac02_1
                FROM oac_file WHERE oac01=g_oad[l_ac].oad01
              IF STATUS THEN 
                 CALL cl_err(g_oad[l_ac].oad01,SQLCA.sqlcode,0) #No.TQC-6B0089
                 LET g_oad[l_ac].oac02_1='' 
                 NEXT FIELD oad01 
              END IF
           END IF
       
        AFTER FIELD oad02                        #check 編號是否重複
            IF NOT cl_null(g_oad[l_ac].oad02) THEN
               IF g_oad[l_ac].oad02 != g_oad_t.oad02 OR
               (g_oad[l_ac].oad02 IS NOT NULL AND g_oad_t.oad02 IS NULL) THEN
                SELECT count(*) INTO l_n FROM oad_file
                 WHERE oad01 = g_oad[l_ac].oad01
                   AND oad02 = g_oad[l_ac].oad02
                IF l_n > 0 THEN
             #      CALL cl_err('',-239,0)
                   LET g_oad[l_ac].oad02 = g_oad_t.oad02
#No.TQC-790126--start--
               {ELSE 
                   CALL cl_err(g_oad[l_ac].oad02,'axm-237',0)      #No.TQC-740129
                   NEXT FIELD oad02}
#No.TQC-790126--end--
                END IF
           END IF
           SELECT oac02 INTO g_oad[l_ac].oac02_2
             FROM oac_file WHERE oac01=g_oad[l_ac].oad02
           IF STATUS THEN LET g_oad[l_ac].oac02_2='' NEXT FIELD oad02 END IF
           END IF
 
#No.TQC-790064---Begin
        AFTER FIELD oad041 
          IF g_oad[l_ac].oad041 < 0  THEN
             CALL cl_err(g_oad[l_ac].oad041,'axm-888',1)
        NEXT FIELD oad041  
          END IF 
 
        AFTER FIELD oad042 
          IF g_oad[l_ac].oad042 < 0 THEN
             CALL cl_err(g_oad[l_ac].oad042,'axm-888',1)
        NEXT FIELD oad042  
          END IF 
 
        AFTER FIELD oad043 
          IF g_oad[l_ac].oad043 < 0 THEN
             CALL cl_err(g_oad[l_ac].oad043,'axm-888',1)
        NEXT FIELD oad043  
          END IF 
 
        AFTER FIELD oad051 
          IF g_oad[l_ac].oad051 < 0 THEN
             CALL cl_err(g_oad[l_ac].oad051,'axm-888',1)
        NEXT FIELD oad051  
          END IF 
 
        AFTER FIELD oad052 
          IF g_oad[l_ac].oad052 < 0 THEN
             CALL cl_err(g_oad[l_ac].oad052,'axm-888',1)
        NEXT FIELD oad052
          END IF 
 
        AFTER FIELD oad053                                                                                                          
          IF g_oad[l_ac].oad053 < 0 THEN                                                                                                        
             CALL cl_err(g_oad[l_ac].oad053,'axm-888',1)                                                                                   
        NEXT FIELD oad053
          END IF                                                                                                                    
#No.TQC-790064---End   
 
        BEFORE DELETE                            #是否取消單身
            IF g_oad_t.oad01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                
                DELETE FROM oad_file 
                 WHERE oad01 = g_oad_t.oad01 
                   AND oad02 = g_oad_t.oad02
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_oad_t.oad01,SQLCA.sqlcode,0)   #No.FUN-660167
                   CALL cl_err3("del","oad_file",g_oad_t.oad01,g_oad_t.oad02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
 
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK"
                CLOSE i032_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_oad[l_ac].* = g_oad_t.*
               CLOSE i032_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_oad[l_ac].oad01,-263,1)
               LET g_oad[l_ac].* = g_oad_t.*
            ELSE
               UPDATE oad_file SET oad01=g_oad[l_ac].oad01,
                                   oad02=g_oad[l_ac].oad02,
                                   oad041=g_oad[l_ac].oad041,
                                   oad042=g_oad[l_ac].oad042,
                                   oad043=g_oad[l_ac].oad043,
                                   oad051=g_oad[l_ac].oad051,
                                   oad052=g_oad[l_ac].oad052,
                                   oad053=g_oad[l_ac].oad053
                 WHERE oad01=g_oad_t.oad01 
                   AND oad02=g_oad_t.oad02
 
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_oad[l_ac].oad01,SQLCA.sqlcode,0)   #No.FUN-660167
                   CALL cl_err3("upd","oad_file",g_oad_t.oad01,g_oad_t.oad02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   LET g_oad[l_ac].* = g_oad_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   CLOSE i032_bcl
                   COMMIT WORK
               END IF
            END IF
 
        #--New AFTER ROW block
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_oad[l_ac].* = g_oad_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_oad.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i032_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034 add
            CLOSE i032_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i032_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(oad01) AND l_ac > 1 THEN
                LET g_oad[l_ac].* = g_oad[l_ac-1].*
                NEXT FIELD oad01
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp
           CASE 
              WHEN INFIELD(oad01) 
#                CALL q_oac(8,10,g_oad[l_ac].oad01)
#                     RETURNING g_oad[l_ac].oad01
#                CALL FGL_DIALOG_SETBUFFER( g_oad[l_ac].oad01 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oac"
                 LET g_qryparam.default1 = g_oad[l_ac].oad01
                 CALL cl_create_qry() RETURNING g_oad[l_ac].oad01
#                 CALL FGL_DIALOG_SETBUFFER( g_oad[l_ac].oad01 )
                  DISPLAY BY NAME g_oad[l_ac].oad01           #No.MOD-490371
                 NEXT FIELD oad01
              WHEN INFIELD(oad02)
#                CALL q_oac(8,10,g_oad[l_ac].oad02)
#                     RETURNING g_oad[l_ac].oad02
#                CALL FGL_DIALOG_SETBUFFER( g_oad[l_ac].oad02 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oac"
                 LET g_qryparam.default1 = g_oad[l_ac].oad02
                 CALL cl_create_qry() RETURNING g_oad[l_ac].oad02
#                 CALL FGL_DIALOG_SETBUFFER( g_oad[l_ac].oad02 )
                  DISPLAY BY NAME g_oad[l_ac].oad02           #No.MOD-490371
                 NEXT FIELD oad02
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
 
        
        END INPUT
 
    CLOSE i032_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i032_b_askkey()
    CLEAR FORM
    CALL g_oad.clear()
 CONSTRUCT g_wc2 ON oad01,oad02,oad041,oad042,oad043,oad051,oad052,oad053
         FROM s_oad[1].oad01,s_oad[1].oad02,s_oad[1].oad041,s_oad[1].oad042,
              s_oad[1].oad043,s_oad[1].oad051,s_oad[1].oad052,s_oad[1].oad053 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE 
              WHEN INFIELD(oad01) 
#                CALL q_oac(8,10,g_oad[1].oad01)
#                     RETURNING g_oad[1].oad01
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oac"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_oad[1].oad01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_oad[1].oad01
                 NEXT FIELD oad01
              WHEN INFIELD(oad02)
#                CALL q_oac(8,10,g_oad[1].oad02)
#                     RETURNING g_oad[1].oad02
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oac"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_oad[1].oad02
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_oad[1].oad02
                 NEXT FIELD oad02
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i032_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i032_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(200)
 
    LET g_sql = "SELECT oad01,oac02,oad02,'',oad041,oad042,",
                "       oad043,oad051,oad052,oad053",
                " FROM oad_file LEFT OUTER JOIN oac_file ON oad_file.oad01=oac_file.oac01",
                " WHERE ", p_wc2 CLIPPED,                     #單身
                " ORDER BY 1"
    PREPARE i032_pb FROM g_sql
    DECLARE oad_curs CURSOR FOR i032_pb
 
    CALL g_oad.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH oad_curs INTO g_oad[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
      SELECT oac02 INTO g_oad[g_cnt].oac02_2
        FROM oac_file WHERE oac01=g_oad[g_cnt].oad02
      LET g_cnt = g_cnt + 1
      
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
     
    END FOREACH
    CALL g_oad.deleteElement(g_cnt)
    MESSAGE ""
 
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i032_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oad TO s_oad.* ATTRIBUTE(COUNT=g_rec_b)
 
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
#NO.FUN-7C0043---BEGIN
FUNCTION i032_out()
#   DEFINE
#       l_oad           RECORD LIKE oad_file.*,
#       l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
#       l_name          LIKE type_file.chr20,                 # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_za05          LIKE type_file.chr1000,               #No.FUN-680137 VARCHAR(40)
#   #   l_oac02_1       LIKE type_file.chr10,                 #No.FUN-680137 VARCHAR(10) #No.TQC-6A0079
#   #   l_oac02_2       LIKE type_file.chr10                  #No.FUN-680137 VARCHAR(10) #No.TQC-6A0079
#       l_oac02_1       LIKE oac_file.oac02,                  #No.FUN-680137 VARCHAR(10) #No.TQC-6A0079     #No.TQC-740129
#       l_oac02_2       LIKE oac_file.oac02                   #No.FUN-680137 VARCHAR(10) #No.TQC-6A0079     #No.TQC-740129
    DEFINE l_cmd  LIKE type_file.chr1000
    IF g_wc2 IS NULL THEN CALL cl_err('',9057,0) RETURN END IF                   
    LET l_cmd = 'p_query "axmi032" "',g_wc2 CLIPPED,'"'                          
    CALL cl_cmdrun(l_cmd)  
 
#   IF g_wc2 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
#   CALL cl_wait()
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
#   LET g_sql="SELECT * FROM oad_file ",          # 組合出 SQL 指令
#             " WHERE ",g_wc2 CLIPPED
#   PREPARE i032_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i032_co                         # CURSOR
#       CURSOR FOR i032_p1
 
#   LET g_rlang = g_lang                          #FUN-4C0096 add
#   CALL cl_outnam('axmi032') RETURNING l_name    #FUN-4C0096 add
 
#   START REPORT i032_rep TO l_name
 
#   FOREACH i032_co INTO l_oad.*
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('foreach:',SQLCA.sqlcode,1)  
#           EXIT FOREACH
#           END IF
#       SELECT oac02 INTO l_oac02_1 FROM oac_file 
#              WHERE oac01=l_oad.oad01
#       SELECT oac02 INTO l_oac02_2 FROM oac_file 
#              WHERE oac01=l_oad.oad02
 
#       OUTPUT TO REPORT i032_rep(l_oad.*,l_oac02_1,l_oac02_2)
#   END FOREACH
 
#   FINISH REPORT i032_rep
 
#   CLOSE i032_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i032_rep(sr,l_p1,l_p2)
#   DEFINE
#     # l_p1            LIKE type_file.chr10,      #No.FUN-680137  VARCHAR(10) #No.TQC-6A0079
#     # l_p2            LIKE type_file.chr10,      #No.FUN-680137  VARCHAR(10) #No.TQC-6A0079
#       l_p1            LIKE oac_file.oac02,      #No.FUN-680137  VARCHAR(10) #No.TQC-6A0079    #No.TQC_740129
#       l_p2            LIKE oac_file.oac02,      #No.FUN-680137  VARCHAR(10) #No.TQC-6A0079    #No.TQC_740129
#       l_trailer_sw    LIKE type_file.chr1,       #No.FUN-680137  VARCHAR(1)
#       sr RECORD LIKE oad_file.*
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.oad01
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<','/pageno'
#           PRINT g_head CLIPPED, pageno_total
#           PRINT ''
#           PRINT g_dash[1,g_len]
#           PRINT g_x[31], 
#                 g_x[32],
#                 g_x[33],
#                 g_x[34],
#                 g_x[35],
#                 g_x[36],
#                 g_x[37],
#                 g_x[38],
#                 g_x[39],
#                 g_x[40] 
#           PRINT g_dash1                                
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#           PRINT COLUMN g_c[31],sr.oad01,
#                 COLUMN g_c[32],l_p1,
#                 COLUMN g_c[33],sr.oad02,
#                 COLUMN g_c[34],l_p2,
#                 COLUMN g_c[35],cl_numfor(sr.oad041,35,g_azi04),
#                 COLUMN g_c[36],cl_numfor(sr.oad042,36,g_azi04),
#                 COLUMN g_c[37],cl_numfor(sr.oad043,37,g_azi04),
#                 COLUMN g_c[38],cl_numfor(sr.oad051,38,g_azi04),
#                 COLUMN g_c[39],cl_numfor(sr.oad052,39,g_azi04),
#                 COLUMN g_c[40],cl_numfor(sr.oad053,40,g_azi04) 
 
#       ON LAST ROW
#          PRINT g_dash[1,g_len]
#          PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED  #No.MOD-580212
#          LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#              PRINT g_dash[1,g_len]
#              PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED  #No.MOD-580212
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#NO.FUN-7C0043---END
#No.FUN-570109 --start--                                                                                                            
FUNCTION i032_set_entry_b(p_cmd)                                                                                                    
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1                           #No.FUN-680137 VARCHAR(1)
                                                                                                                                    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("oad01,oad02",TRUE)                                                                                     
  END IF                                                                                                                            
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
                                                                                                                                    
FUNCTION i032_set_no_entry_b(p_cmd)                                                                                                 
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1                           #No.FUN-680137 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("oad01,oad02",FALSE)                                                                                    
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
#No.FUN-570109 --end--         
