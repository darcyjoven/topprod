# Prog. Version..: '5.30.06-13.04.22(00003)'     #
# Pattern name...: agli110.4gl
# Descriptions...: 會計科目對沖關係維護作業
# Date & Author..: 10/12/23 By lutingting
# Modify.........: NO.FUN-B40104 By jll  合并报表作业產品
# Modify.........: NO.MOD-C90156 By wujie aaw01改为aaz641
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    g_axff           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        axff05       LIKE axff_file.axff05,  
        axff06       LIKE axff_file.axff06, 
        axff01       LIKE axff_file.axff01,   #科目編號
        axff01_desc  LIKE aag_file.aag02,
        axff07       LIKE axff_file.axff07,
        axff02       LIKE axff_file.axff02,   #簡稱
        axff02_desc  LIKE aag_file.aag02,
        axff03       LIKE axff_file.axff03,
        axff04       LIKE axff_file.axff04,
        axff04_desc  LIKE aag_file.aag02,
        axffacti     LIKE axff_file.axffacti
                    END RECORD,
    g_axff_t         RECORD                 #程式變數 (舊值)
        axff05       LIKE axff_file.axff05,
        axff06       LIKE axff_file.axff06,
        axff01       LIKE axff_file.axff01,   #科目編號
        axff01_desc  LIKE aag_file.aag02,
        axff07       LIKE axff_file.axff07, 
        axff02       LIKE axff_file.axff02,   #簡稱
        axff02_desc  LIKE aag_file.aag02,
        axff03       LIKE axff_file.axff03,
        axff04       LIKE axff_file.axff04,
        axff04_desc  LIKE aag_file.aag02,
        axffacti     LIKE axff_file.axffacti
                    END RECORD,
    i               LIKE type_file.num5,   
    g_wc,g_wc2      STRING,      
    g_sql           STRING,#TQC-630166     
    g_rec_b         LIKE type_file.num5,   #單身筆數                
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT    

#主程式開始
DEFINE g_before_input_done   STRING       
DEFINE g_forupd_sql   STRING                       #SELECT ... FOR UPDATE NOWAIT SQL    
DEFINE g_sql_tmp      STRING                    
DEFINE g_cnt          LIKE type_file.num10     
DEFINE g_msg          LIKE type_file.chr1000  
DEFINE g_row_count    LIKE type_file.num10   
DEFINE g_i            LIKE type_file.num5   
DEFINE g_curs_index   LIKE type_file.num10 
DEFINE g_jump         LIKE type_file.num10
DEFINE mi_no_ask      LIKE type_file.num5 
#DEFINE g_aaw01        LIKE aaw_file.aaw01
DEFINE g_aaz641       LIKE aaz_file.aaz641   #No.MOD-C90156
DEFINE g_dbs_gl       LIKE type_file.chr21
DEFINE g_dbs_axz03    LIKE type_file.chr21 
DEFINE tm          RECORD
                       axa01      LIKE axa_file.axa01,  #族群代號
                       axa02      LIKE axa_file.axa02,  #上層公司
                       axa03      LIKE axa_file.axa03,  #帳別
                       axb04      LIKE axb_file.axb04,  #下層公司
                       axb05      LIKE axb_file.axb05   #帳別
                      END RECORD
MAIN
DEFINE p_row,p_col     LIKE type_file.num5 

   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET p_row = 4 LET p_col = 12

#   SELECT aaw01 INTO g_aaw01 FROM aaw_file WHERE aaw00 = '0'
   SELECT aaz641 INTO g_aaz641 FROM aaz_file WHERE aaz00 = '0'   #No.MOD-C90156
   LET g_dbs = s_dbstring(g_dbs)
   OPEN WINDOW i110_w AT p_row,p_col WITH FORM "agl/42f/agli110"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()

   CALL i110_menu()
   CLOSE FORM i110_w                      #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

#QBE 查詢資料
FUNCTION i110_b_askkey() 
    CLEAR FORM                            #清除畫面
    CALL g_axff.clear()
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
    CONSTRUCT g_wc ON axff05,axff06,axff01,axff07,axff02,axff03,axff04
         FROM s_axff[1].axff05,s_axff[1].axff06,s_axff[1].axff01,
              s_axff[1].axff07,s_axff[1].axff02,s_axff[1].axff03,
              s_axff[1].axff04 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()

       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(axff01) #來源會計科目
                CALL q_m_aag2(TRUE,TRUE,g_plant,g_axff[1].axff01,'23',g_aaz641)        #No.MOD-C90156  aaw01 -->aaz641       
                     RETURNING g_qryparam.multiret                                      
                DISPLAY g_qryparam.multiret TO axff01                                  
                NEXT FIELD axff01        
             WHEN INFIELD(axff02) #對沖會計科目
                CALL q_m_aag2(TRUE,TRUE,g_plant,g_axff[1].axff02,'23',g_aaz641)        #No.MOD-C90156  aaw01 -->aaz641       
                     RETURNING g_qryparam.multiret                                      
                DISPLAY g_qryparam.multiret TO axff02                                  
                NEXT FIELD axff02    
             WHEN INFIELD(axff04) #差額對應會計科目
                CALL q_m_aag2(TRUE,TRUE,g_plant,g_axff[1].axff04,'23',g_aaz641)        #No.MOD-C90156  aaw01 -->aaz641  
                     RETURNING g_qryparam.multiret                                
                DISPLAY g_qryparam.multiret TO axff04                            
                NEXT FIELD axff04     
             OTHERWISE
                EXIT CASE
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

    IF INT_FLAG THEN
       RETURN
    END IF

    CALL i110_b_fill(g_wc)

END FUNCTION

FUNCTION i110_menu()

   WHILE TRUE
      CALL i110_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i110_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i110_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "misc_source_acc"
            IF cl_chk_act_auth() THEN
               CALL i110_msa()
            END IF
         WHEN "misc_opposite_acc"
            IF cl_chk_act_auth() THEN
               CALL i110_moa()
            END IF
         WHEN "gen_agli003"
            IF cl_chk_act_auth() THEN
               CALL i110_gen()
            END IF
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
                  LET g_doc.column1 = "axff01"
                  LET g_doc.column2 = "axff02"  
                  LET g_doc.value1 = g_axff[l_ac].axff01
                  LET g_doc.value2 = g_axff[l_ac].axff02  
                  CALL cl_doc()
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_axff),'','')
            END IF

      END CASE
   END WHILE
END FUNCTION

#Query 查詢
FUNCTION i110_q()

    CALL i110_b_askkey()

END FUNCTION

FUNCTION i110_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc     LIKE type_file.chr1000  

    LET g_sql = "SELECT axff05,axff06,axff01,'',axff07,axff02,'',axff03,axff04,'',axffacti FROM axff_file ",  
                " WHERE ",p_wc CLIPPED, 
                " ORDER BY axff01"
    PREPARE i110_prepare2 FROM g_sql      #預備一下
    DECLARE axff_cs CURSOR FOR i110_prepare2

    CALL g_axff.clear()

    LET g_cnt = 1
    LET g_rec_b = 0

    FOREACH axff_cs INTO g_axff[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF

      CALL i110_aag('a',g_axff[g_cnt].axff01)  
           RETURNING g_axff[g_cnt].axff01_desc  

      CALL i110_aag('a',g_axff[g_cnt].axff02) 
           RETURNING g_axff[g_cnt].axff02_desc

      CALL i110_aag('a',g_axff[g_cnt].axff04)
           RETURNING g_axff[g_cnt].axff04_desc 

      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
    END FOREACH
    CALL g_axff.deleteElement(g_cnt)
    LET g_rec_b=g_cnt -1

    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

#單身
FUNCTION i110_b()
DEFINE
    l_ac_t          LIKE type_file.num5,         #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,         #檢查重複用      
    l_lock_sw       LIKE type_file.chr1,         #單身鎖住否     
    p_cmd           LIKE type_file.chr1,         #處理狀態      
    l_allow_insert  LIKE type_file.num5,         #可新增否     
    l_allow_delete  LIKE type_file.num5,         #可刪除否    
    l_cmd           STRING                  

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT axff05,axff06,axff01,'',axff07,axff02,'',axff03,axff04,'',axffacti FROM axff_file ", 
                       "WHERE axff01 = ? AND axff02=?  FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i110_bcl CURSOR FROM g_forupd_sql  

    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_axff WITHOUT DEFAULTS FROM s_axff.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF

        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()

            IF g_rec_b >= l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_axff_t.* = g_axff[l_ac].*
               OPEN i110_bcl USING g_axff_t.axff01,g_axff_t.axff02
               IF STATUS THEN
                  CALL cl_err("OPEN i110_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i110_bcl INTO g_axff[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_axff_t.axff01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  SELECT aag02 INTO g_axff[l_ac].axff01_desc FROM aag_file
                   WHERE aag01=g_axff[l_ac].axff01
                     AND aag00=g_aaz641       #No.MOD-C90156
#                    AND aag00=g_aaw01
                  SELECT aag02 INTO g_axff[l_ac].axff02_desc FROM aag_file
                   WHERE aag01=g_axff[l_ac].axff02
                     AND aag00=g_aaz641       #No.MOD-C90156
#                    AND aag00=g_aaw01
                  SELECT aag02 INTO g_axff[l_ac].axff04_desc FROM aag_file
                   WHERE aag01=g_axff[l_ac].axff04
                      AND aag00=g_aaz641       #No.MOD-C90156
#                    AND aag00=g_aaw01
               END IF
               CALL cl_show_fld_cont()
            END IF

        LET g_before_input_done = FALSE
        CALL i110_set_entry(p_cmd)
        CALL i110_set_no_entry(p_cmd)
        LET g_before_input_done = TRUE
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET  g_before_input_done = FALSE
            CALL i110_set_entry(p_cmd)
            CALL i110_set_no_entry(p_cmd)
            LET  g_before_input_done = TRUE
            INITIALIZE g_axff[l_ac].* TO NULL
            LET g_axff[l_ac].axff03  ='N'
            LET g_axff[l_ac].axffacti='Y'
            LET g_axff[l_ac].axff05 = 'N' 
            LET g_axff[l_ac].axff06 = '1' 
            LET g_axff[l_ac].axff07 = '1' 
            LET g_axff_t.* = g_axff[l_ac].* 
            CALL cl_show_fld_cont()
            NEXT FIELD axff05    

        AFTER INSERT
            IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              INITIALIZE g_axff[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_axff[l_ac].* TO s_axff.*
              CALL g_axff.deleteElement(g_rec_b+1)
              ROLLBACK WORK
              EXIT INPUT
            END IF
            IF NOT cl_null(g_axff[l_ac].axff01) AND NOT cl_null(g_axff[l_ac].axff02) THEN 
                INSERT INTO axff_file(axff01,axff02,axff03,axff04,
                                      axff05,axff06,axff07,axffacti)
                              VALUES(g_axff[l_ac].axff01,g_axff[l_ac].axff02,g_axff[l_ac].axff03,g_axff[l_ac].axff04,
                                     g_axff[l_ac].axff05,g_axff[l_ac].axff06,g_axff[l_ac].axff07,g_axff[l_ac].axffacti)
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins","axff_file",g_axff[l_ac].axff01,"",SQLCA.sqlcode,"","",1) 
                    CANCEL INSERT
                ELSE
                    LET g_rec_b = g_rec_b + 1
                    DISPLAY g_rec_b TO FORMONLY.cn2
                    MESSAGE 'INSERT O.K'
                END IF
            ELSE               
                CALL cl_err('','9044',1)   
            END IF                        

       AFTER FIELD axff05 
          IF g_axff[l_ac].axff05 = 'Y' THEN
              FOR i = 1 TO ARR_COUNT()
                  IF i <> l_ac THEN
                      IF g_axff[i].axff05 = 'Y' THEN
                          LET g_axff[l_ac].axff05 = 'N' 
                          DISPLAY BY NAME g_axff[l_ac].axff05
                          CALL cl_err('','agl027',1)
                      END IF
                  END IF
              END FOR
          END IF

        AFTER FIELD axff01   
           IF NOT cl_null(g_axff[l_ac].axff01) THEN
              IF g_axff[l_ac].axff01[1,4]<>'MISC' THEN
                 IF g_axff_t.axff01 IS NULL OR
                    g_axff_t.axff02 IS NULL OR   
                    (g_axff[l_ac].axff01 != g_axff_t.axff01) OR  
                   (g_axff[l_ac].axff02 != g_axff_t.axff02) THEN
                    SELECT count(*) INTO l_n FROM axff_file
                     WHERE axff01 = g_axff[l_ac].axff01
                       AND axff02 = g_axff[l_ac].axff02 
                    IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_axff[l_ac].axff01 = g_axff_t.axff01
                       NEXT FIELD axff01
                    END IF
                 END IF
                 CALL i110_aag('a',g_axff[l_ac].axff01)
                      RETURNING g_axff[l_ac].axff01_desc 
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_axff[l_ac].axff01,g_errno,0)
                    LET g_axff[l_ac].axff01=g_axff_t.axff01
                    NEXT FIELD axff01
                 ELSE
                    DISPLAY g_axff[l_ac].axff01_desc TO axff01_desc
                 END IF
              ELSE
                 LET g_axff[l_ac].axff01_desc=NULL
                 DISPLAY BY NAME g_axff[l_ac].axff01_desc
              END IF
              #luttb 110311--add--str--
              IF NOT cl_null(g_axff_t.axff01)  
                 AND g_axff_t.axff01[1,4]='MISC'
                 AND g_axff_t.axff01 !=g_axff[l_ac].axff01[1,4] THEN
                 DELETE FROM axss_file
                  WHERE axss00 = g_aaz641     #No.MOD-C90156  aaw01 -->aaz641  
                    AND axss01 = g_axff_t.axff01
              END IF 
              #luttb 110311--add-end
              LET l_cmd=g_axff[l_ac].axff01[1,4]   
              IF UPSHIFT(l_cmd) = 'MISC' THEN
                 CALL i110_msa()
              END IF
           END IF
 
        AFTER FIELD axff02
           IF NOT cl_null(g_axff[l_ac].axff02) THEN
              IF g_axff[l_ac].axff02[1,4]<>'MISC' THEN 
                 CALL i110_aag('a',g_axff[l_ac].axff02)
                      RETURNING g_axff[l_ac].axff02_desc 
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_axff[l_ac].axff02,g_errno,0)
                    LET g_axff[l_ac].axff02=g_axff_t.axff02
                    NEXT FIELD axff02
                 ELSE
                    DISPLAY g_axff[l_ac].axff02_desc TO axff02_desc
                 END IF
              ELSE
                 LET g_axff[l_ac].axff02_desc=NULL
                 DISPLAY BY NAME g_axff[l_ac].axff02_desc
              END IF
              #luttb 110311--add--str--
              IF NOT cl_null(g_axff_t.axff02)
                 AND g_axff_t.axff02[1,4]='MISC'
                 AND g_axff_t.axff02 !=g_axff[l_ac].axff02[1,4] THEN
                 DELETE FROM axtt_file
                  WHERE axtt00 = g_aaz641     #No.MOD-C90156  aaw01 -->aaz641 
                    AND axtt01 = g_axff_t.axff02
              END IF
              #luttb 110311--add--end
              LET l_cmd=g_axff[l_ac].axff02[1,4]   
              IF UPSHIFT(l_cmd) = 'MISC' THEN
                 CALL i110_moa()
              END IF
           END IF
        AFTER FIELD axff03
           IF NOT cl_null(g_axff[l_ac].axff03) THEN
              IF g_axff[l_ac].axff03 NOT MATCHES'[YN]' THEN
                 NEXT FIELD axff03
              END IF
           END IF
        AFTER FIELD axff04
           IF NOT cl_null(g_axff[l_ac].axff04) THEN
              CALL i110_aag('a',g_axff[l_ac].axff04)   
                   RETURNING g_axff[l_ac].axff04_desc 
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_axff[l_ac].axff04,g_errno,0)
                 LET g_axff[l_ac].axff04=g_axff_t.axff04
                 NEXT FIELD axff04
               ELSE
                 DISPLAY g_axff[l_ac].axff02_desc TO axff04_desc
              END IF
           END IF

        BEFORE DELETE                            #是否取消單身
            IF g_axff_t.axff01 IS NOT NULL THEN
                IF NOT i110_chk_source_acc() THEN
                   CANCEL DELETE
                END IF
                IF NOT i110_chk_oppsite_acc() THEN
                   CANCEL DELETE
                END IF
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                INITIALIZE g_doc.* TO NULL                 
                LET g_doc.column1 = "axff01"              
                LET g_doc.column2 = "axff02"             
                LET g_doc.value1 = g_axff[l_ac].axff01  
                LET g_doc.value2 = g_axff[l_ac].axff02 
                CALL cl_del_doc()                     

                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF

                DELETE FROM axff_file
                 WHERE axff01 = g_axff_t.axff01
                   AND axff02 = g_axff_t.axff02 
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","axff_file",g_axff_t.axff01,"",SQLCA.sqlcode,"","",1) 
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b = g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF

            COMMIT WORK

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_axff[l_ac].* = g_axff_t.*
               CLOSE i110_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_axff[l_ac].axff01,-263,1)
               LET g_axff[l_ac].* = g_axff_t.*
            ELSE
               UPDATE axff_file SET axff01 = g_axff[l_ac].axff01,
                                   axff02 = g_axff[l_ac].axff02,
                                   axff03 = g_axff[l_ac].axff03,
                                   axff04 = g_axff[l_ac].axff04,
                                   axff05 = g_axff[l_ac].axff05,  
                                   axff06 = g_axff[l_ac].axff06, 
                                   axff07 = g_axff[l_ac].axff07,
                                   axffacti = g_axff[l_ac].axffacti 
                WHERE axff01 = g_axff_t.axff01 
                  AND axff02 = g_axff_t.axff02 
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","axff_file",g_axff_t.axff01,"",SQLCA.sqlcode,"","",1)  
                  LET g_axff[l_ac].* = g_axff_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D30032
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #LET g_axff[l_ac].* = g_axff_t.*  #FUN-D30032 mark
               #FUN-D30032--add--str--
               IF p_cmd='u' THEN
                  LET g_axff[l_ac].* = g_axff_t.* 
               ELSE
                  CALL g_axff.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               END IF
               #FUN-D30032--add--end--
               CLOSE i110_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30032

            LET g_axff_t.* = g_axff[l_ac].*
            CLOSE i110_bcl
            COMMIT WORK
            CALL g_axff.deleteElement(g_rec_b+1)

        ON ACTION mntn_acc_code1
           IF g_axff[l_ac].axff01 = 'MISC' THEN    
              CALL cl_err('','agl-255',1)         
              CONTINUE INPUT                     
           ELSE                                 
#              LET g_msg = "agli102 '",g_aaw01,"' '",g_axff[l_ac].axff01 ,"' " 
              LET g_msg = "agli102 '",g_aaz641,"' '",g_axff[l_ac].axff01 ,"' "   #No.MOD-C90156
              CALL cl_cmdrun(g_msg)
           END IF            
        ON ACTION mntn_acc_code2
           IF g_axff[l_ac].axff02 = 'MISC' THEN   
              CALL cl_err('','agl-256',1)        
              CONTINUE INPUT                    
           ELSE                                
#              LET g_msg = "agli102 '",g_aaw01,"' '",g_axff[l_ac].axff02 ,"' " 
              LET g_msg = "agli102 '",g_aaz641,"' '",g_axff[l_ac].axff02 ,"' "   #No.MOD-C90156
              CALL cl_cmdrun(g_msg)
           END IF               
        ON ACTION mntn_acc_code4
#           LET g_msg = "agli102 '",g_aaw01,"' '",g_axff[l_ac].axff04 ,"' "
           LET g_msg = "agli102 '",g_aaz641,"' '",g_axff[l_ac].axff04 ,"' "      #No.MOD-C90156
           CALL cl_cmdrun(g_msg)

        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(axff01) AND l_ac > 1 THEN
              LET g_axff[l_ac].* = g_axff[l_ac-1].*
              NEXT FIELD axff01
           END IF

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION help
           CALL cl_show_help()

        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(axff01) #來源會計科目
                 CALL q_m_aag2(FALSE,TRUE,g_plant,g_axff[l_ac].axff01,'23',g_aaz641)      #No.MOD-C90156  aaw01 -->aaz641
                     RETURNING g_axff[l_ac].axff01                               
                 DISPLAY BY NAME g_axff[l_ac].axff01                            
                 NEXT FIELD axff01                                             
              WHEN INFIELD(axff02) #對沖會計科目
                 CALL q_m_aag2(FALSE,TRUE,g_plant,g_axff[l_ac].axff02,'23',g_aaz641)      #No.MOD-C90156  aaw01 -->aaz641
                     RETURNING g_axff[l_ac].axff02                                     
                 DISPLAY BY NAME g_axff[l_ac].axff02                                  
                 NEXT FIELD axff02                                                   
              WHEN INFIELD(axff04) #差額對應會計科目
                 CALL q_m_aag2(FALSE,TRUE,g_plant,g_axff[l_ac].axff04,'23',g_aaz641)      #No.MOD-C90156  aaw01 -->aaz641
                     RETURNING g_axff[l_ac].axff04                                     
                 DISPLAY BY NAME g_axff[l_ac].axff04                                  
                 NEXT FIELD axff04  
              OTHERWISE EXIT CASE
           END CASE
        ON ACTION controls                                        
           CALL cl_set_head_visible("","AUTO")                    
    END INPUT

    CLOSE i110_bcl
    COMMIT WORK

END FUNCTION

FUNCTION i110_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1  

   CALL cl_set_comp_entry("axff01,axff02",TRUE)  #FUN-960093
END FUNCTION

FUNCTION i110_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1   

END FUNCTION


#-->檢查科目名稱
FUNCTION i110_aag(p_cmd,p_act)
   DEFINE  p_cmd      LIKE type_file.chr1,  
           p_act      LIKE aag_file.aag01,
           l_aag02    LIKE aag_file.aag02,
           l_aag03    LIKE aag_file.aag03,
           l_aag07    LIKE aag_file.aag07,
           l_aagacti  LIKE aag_file.aagacti

   LET g_errno = ' '
   SELECT aag02,aag03,aag07,aagacti       
     INTO l_aag02,l_aag03,l_aag07,l_aagacti
     FROM aag_file                        
    WHERE aag01 = p_act                  
      AND aag00 = g_aaz641       #No.MOD-C90156  aaw01 -->aaz641
   CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-001'
        WHEN l_aagacti = 'N'     LET g_errno = '9028'
        WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
        OTHERWISE           LET g_errno = SQLCA.sqlcode USING '----------'
   END CASE

   RETURN l_aag02

END FUNCTION

FUNCTION i110_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY ARRAY g_axff TO s_axff.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()


      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
      
#@    ON ACTION MISC來源科目設定
      ON ACTION misc_source_acc
         LET g_action_choice="misc_source_acc"
         EXIT DISPLAY

#@    ON ACTION MISC對沖科目設定
      ON ACTION misc_opposite_acc
         LET g_action_choice="misc_opposite_acc"
         EXIT DISPLAY

      ON ACTION gen_agli003
         LET g_action_choice="gen_agli003"
         EXIT DISPLAY

#@    ON ACTION 相關文件
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i110_msa()   
   DEFINE l_cmd STRING
   IF g_rec_b=0 THEN
      CALL cl_err('','amr-304',0)
      RETURN
   END IF
   LET l_cmd=g_axff[l_ac].axff01[1,4]   
   IF UPSHIFT(l_cmd) <> 'MISC' THEN
      CALL cl_err('','agl-099',0)
      RETURN
   END IF

#   LET l_cmd="agli0034 '",g_aaw01,"' ", 
   LET l_cmd="agli0034 '",g_aaz641,"' ",    #No.MOD-C90156
             "'",g_axff[l_ac].axff01,"' "    #來源會計科目編號 
   CALL cl_cmdrun_wait(l_cmd)
END FUNCTION

FUNCTION i110_moa()
   DEFINE l_cmd STRING
   IF g_rec_b=0 THEN
      CALL cl_err('','amr-304',0)
      RETURN
   END IF
   LET l_cmd=g_axff[l_ac].axff02[1,4]   
   IF UPSHIFT(l_cmd) <> 'MISC' THEN
      CALL cl_err('','agl-123',0)
      RETURN
   END IF

#   LET l_cmd="agli0035 '",g_aaw01,"' ",     #來源帳別
   LET l_cmd="agli0035 '",g_aaz641,"' ",     #來源帳別   #No.MOD-C90156
             "'",g_axff[l_ac].axff02,"' "    #來源會計科目編號

   CALL cl_cmdrun_wait(l_cmd)
END FUNCTION

FUNCTION i110_chk_source_acc()
   LET g_sql=g_axff[l_ac].axff01[1,4]
   IF UPSHIFT(g_sql) = 'MISC' THEN
      SELECT COUNT(*) INTO g_cnt FROM axss_file
                                WHERE axss00=g_aaz641        #No.MOD-C90156 aaw01 --> aaz641
                                  AND axss01=g_axff[l_ac].axff01
      IF SQLCA.sqlcode OR cl_null(g_cnt) THEN
         LET g_cnt=0
      END IF
      IF g_cnt>0 THEN
         DELETE FROM axss_file 
          WHERE axss00=g_aaz641        #No.MOD-C90156 aaw01 --> aaz641
            AND axss01=g_axff[l_ac].axff01                                                                       
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err('','agl-151',1)
            RETURN FALSE
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION i110_chk_oppsite_acc()
   LET g_sql=g_axff[l_ac].axff02[1,4]
   IF UPSHIFT(g_sql) = 'MISC' THEN
      SELECT COUNT(*) INTO g_cnt FROM axtt_file
                                WHERE axtt00=g_aaz641        #No.MOD-C90156 aaw01 --> aaz641
                                  AND axtt01=g_axff[l_ac].axff02
      IF SQLCA.sqlcode OR cl_null(g_cnt) THEN
         LET g_cnt=0
      END IF
      IF g_cnt>0 THEN
         DELETE FROM axtt_file 
          WHERE axtt00=g_aaz641        #No.MOD-C90156 aaw01 --> aaz641
            AND axtt01=g_axff[l_ac].axff02                                                                       
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN  
            #CALL cl_err('','agl-125',1)
            CALL cl_err('','agl-161',1)
            RETURN FALSE
         END IF 
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION i110_gen()    #产生族群内所有公司的
DEFINE p_row,p_col     LIKE type_file.num5
DEFINE g_dept   DYNAMIC ARRAY OF RECORD
                 axa01     LIKE axa_file.axa01,  #族群代號
                 axa02     LIKE axa_file.axa02,  #上層公司
                 axa03     LIKE axa_file.axa03,  #帳別
                 axb04     LIKE axb_file.axb04,  #下層公司
                 axb05     LIKE axb_file.axb05   #帳別
                END RECORD,
       l_axf    RECORD LIKE axf_file.*,
       l_axff   RECORD LIKE axff_file.*,
       l_axs    RECORD LIKE axs_file.*,
       l_axss   RECORD LIKE axss_file.*,
       l_axt    RECORD LIKE axt_file.*,
       l_axtt   RECORD LIKE axtt_file.*,
       l_sql    STRING,
       i,j,g_no LIKE type_file.num5

   LET p_row = 4 LET p_col = 12
   OPEN WINDOW i110_w1 AT p_row,p_col WITH FORM "agl/42f/agli110_1"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL cl_ui_locale("agli110_1")
   INPUT tm.axa01 WITHOUT DEFAULTS FROM axa01
      AFTER FIELD axa01   #族群代號
         IF NOT cl_null(tm.axa01) THEN
            SELECT DISTINCT axa01 FROM axa_file WHERE axa01=tm.axa01
            IF STATUS THEN
               CALL cl_err3("sel","axa_file",tm.axa01,tm.axa02,"agl-117","","",0)
               NEXT FIELD axa01
            ELSE
               SELECT axa02,axa03 INTO tm.axa02,tm.axa03 FROM axa_file
                WHERE axa01 = tm.axa01
                  AND axa04 = 'Y'
            END IF
         END IF

      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(axa01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_axa5"
                LET g_qryparam.default1 = tm.axa01
                CALL cl_create_qry() RETURNING tm.axa01,tm.axa02,tm.axa03
                DISPLAY BY NAME tm.axa01
                NEXT FIELD axa01
         END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()
   END INPUT

   CLOSE WINDOW i110_w1                #結束畫面
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF

   DROP TABLE i110_tmp

   CREATE TEMP TABLE i110_tmp(
      chk       LIKE type_file.chr1,
      axa01     LIKE axa_file.axa01,
      axa02     LIKE axa_file.axa02,
      axa03     LIKE axa_file.axa03,
      axb04     LIKE axb_file.axb04,
      axb05     LIKE axb_file.axb05    );
   CALL g_dept.clear()   #將g_dept清空

   CALL i110_dept()    #抓取關係人層級 

   BEGIN WORK
   CALL s_showmsg_init()
   LET g_success=  'Y'
   DELETE FROM axf_file WHERE axf13 = tm.axa01
   IF SQLCA.sqlcode THEN
     CALL s_errmsg('axa01',tm.axa01,'DELETE axa_file',STATUS,1)
     LET g_success = 'N'
   END IF
   DELETE FROM axt_file WHERE axt13 = tm.axa01
   IF SQLCA.sqlcode THEN
     CALL s_errmsg('axa01',tm.axa01,'DELETE axt_file',STATUS,1)
     LET g_success = 'N'
   END IF
   DELETE FROM axs_file WHERE axs13 = tm.axa01
   IF SQLCA.sqlcode THEN
     CALL s_errmsg('axa01',tm.axa01,'DELETE axs_file',STATUS,1)
     LET g_success = 'N'
   END IF
   LET l_sql=" SELECT axa01,axa02,axa03,axb04,axb05",
             "   FROM i110_tmp ",
             "  ORDER BY axa01,axa02,axa03,axb04"
   PREPARE p500_axa_p FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare:1',STATUS,1)
      CALL cl_batch_bg_javamail('N')
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE p500_axa_c CURSOR FOR p500_axa_p
   LET g_no = 1
   CALL s_showmsg_init()
   FOREACH p500_axa_c INTO g_dept[g_no].*
      IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success='Y'
      END IF
      IF SQLCA.SQLCODE THEN
         CALL s_errmsg(' ',' ','for_axa_c:',STATUS,1)
         LET g_success = 'N'
         RETURN
      END IF
      LET g_no=g_no+1
   END FOREACH
   CALL g_dept.deleteElement(g_no)
   LET g_no=g_no-1
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF

   FOR i =1 TO g_no

      ####来源公司为上层,对冲公司为下层
      FOR j = 1 to g_axff.getlength()
          INITIALIZE l_axf.* TO NULL
          LET l_axf.axf01 = g_axff[j].axff01
          IF l_axf.axf01 = 'MISC' THEN
             DECLARE sel_axs_cur CURSOR FOR 
              SELECT * FROM axss_file WHERE axss01 = l_axf.axf01
                 AND axss00 = g_aaz641        #No.MOD-C90156 aaw01 --> aaz641  
             INITIALIZE l_axs.* TO NULL
             FOREACH sel_axs_cur INTO l_axss.*
                 LET l_axs.axs01 = l_axss.axss01
                 LET l_axs.axs03 = l_axss.axss03
                 LET l_axs.axs09 = g_dept[i].axa02
                 LET l_axs.axs10 = g_dept[i].axb04 
                 CALL s_aaz641_dbs(tm.axa01,l_axs.axs09) RETURNING g_dbs_axz03
                 CALL s_get_aaz641(g_dbs_axz03) RETURNING l_axs.axs00
                 CALL s_aaz641_dbs(tm.axa01,l_axs.axs10) RETURNING g_dbs_gl
                 CALL s_get_aaz641(g_dbs_gl) RETURNING l_axs.axs12
                 LET l_axs.axs13 = tm.axa01
                 INSERT INTO axs_file VALUES(l_axs.*)
                 IF SQLCA.sqlcode THEN
                    #CALL cl_err3("ins","axs_file",l_axs.axs00,l_axs.axs01,SQLCA.sqlcode,"","",1) #luttb 110311
                    LET g_showmsg =l_axs.axs09,"/",l_axs.axs10
                    CALL s_errmsg('axs09,axs10',g_showmsg,'ins axs_file',STATUS,1)
                    LET g_success = 'N'
                    EXIT FOREACH
                 END IF
             END FOREACH
          END IF 
          LET l_axf.axf02 = g_axff[j].axff02
          IF l_axf.axf02 = 'MISC' THEN
             DECLARE sel_axtt_cur CURSOR FOR
              SELECT * FROM axtt_file
               WHERE axtt00 = g_aaz641        #No.MOD-C90156 aaw01 --> aaz641
                 AND axtt01 = l_axf.axf02
             INITIALIZE l_axt.* TO NULL
             FOREACH sel_axtt_cur INTO l_axtt.*
                 LET l_axt.axt01 = l_axtt.axtt01
                 LET l_axt.axt03 = l_axtt.axtt03
                 LET l_axt.axt04 = l_axtt.axtt04
                 LET l_axt.axt05 = l_axtt.axtt05
                 LET l_axt.axt06 = l_axtt.axtt06
                 LET l_axt.axt09 = g_dept[i].axa02
                 LET l_axt.axt10 = g_dept[i].axb04
                 LET l_axt.axt13 = tm.axa01
                 CALL s_aaz641_dbs(tm.axa01,l_axt.axt09) RETURNING g_dbs_axz03
                 CALL s_get_aaz641(g_dbs_axz03) RETURNING l_axt.axt00
                 CALL s_aaz641_dbs(tm.axa01,l_axt.axt10) RETURNING g_dbs_gl
                 CALL s_get_aaz641(g_dbs_gl) RETURNING l_axt.axt12
                 INSERT INTO axt_file VALUES(l_axt.*)
                 IF SQLCA.sqlcode THEN
                   # CALL cl_err3("ins","axt_file",l_axt.axt00,l_axt.axt01,SQLCA.sqlcode,"","",1)  #luttb 110311
                    LET g_showmsg =l_axt.axt09,"/",l_axt.axt10
                    CALL s_errmsg('axt09,axt10',g_showmsg,'ins axt_file',STATUS,1)
                    LET g_success = 'N'
                    EXIT FOREACH
                 END IF
             END FOREACH
          END IF 
          LET l_axf.axf03 = g_axff[j].axff03
          LET l_axf.axf04 = g_axff[j].axff04 
          LET l_axf.axfuser = g_user
          LET l_axf.axfgrup = g_grup
          LET l_axf.axf09 = g_dept[i].axa02
          LET l_axf.axf10 = g_dept[i].axb04
          CALL s_aaz641_dbs(tm.axa01,l_axf.axf09) RETURNING g_dbs_axz03
          CALL s_get_aaz641(g_dbs_axz03) RETURNING l_axf.axf00
          CALL s_aaz641_dbs(tm.axa01,l_axf.axf10) RETURNING g_dbs_gl
          CALL s_get_aaz641(g_dbs_gl) RETURNING l_axf.axf12
          LET l_axf.axf13 = tm.axa01
          LET l_axf.axf14 = g_axff[j].axff05
          LET l_axf.axf15 = g_axff[j].axff06
          LET l_axf.axf16 = tm.axa02
          LET l_axf.axf17 = g_axff[j].axff07
          LET l_axf.axfacti = g_axff[j].axffacti
          INSERT INTO axf_file VALUES(l_axf.*)
          IF SQLCA.sqlcode THEN
             #CALL cl_err3("ins","axf_file",l_axf.axf09,l_axf.axf10,SQLCA.sqlcode,"","",1)  #luttb 110311
             LET g_showmsg =l_axf.axf09,"/",l_axf.axf10
             CALL s_errmsg('axf09,axf10',g_showmsg,'ins axf_file',STATUS,1)
             LET g_success = 'N'
             EXIT FOR
          END IF 
      END FOR
      ####来源公司为上层,对冲公司为下层
       
      #處理側流
      CALL i110_gen_1(g_dept[i].*)

   END FOR
   IF g_success="N" THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK 
   END IF
   CALL s_showmsg()
END FUNCTION

FUNCTION i110_gen_1(g_dept)
DEFINE g_dept       RECORD
                     axa01      LIKE axa_file.axa01,   #族群代號
                     axa02      LIKE axa_file.axa02,   #上層公司
                     axa03      LIKE axa_file.axa03,   #帳別
                     axb04      LIKE axb_file.axb04,   #下層公司
                     axb05      LIKE axb_file.axb05    #帳別
                    END RECORD,
       l_axs        RECORD LIKE axs_file.*,
       l_axss       RECORD LIKE axss_file.*,
       l_axt        RECORD LIKE axt_file.*,
       l_axtt       RECORD LIKE axtt_file.*,
       l_axf        RECORD LIKE axf_file.*,    
       l_sql        STRING,
       g_axb04      LIKE axb_file.axb04,               #其他下層公司
       l_axz05      LIKE axz_file.axz05,
       i,j          LIKE type_file.num5

   #抓取其他子公司
   #luttb 110311--mod--str--
   LET l_sql="SELECT axa02 FROM axa_file ",
             " WHERE axa01 = '",tm.axa01,"'",
            # "   AND axa02 !='",tm.axa02,"'",   #luttb 110314
             "   AND axa02 !='",g_dept.axb04,"'", 
             "  UNION ",
             "SELECT axb04 ",
             "  FROM axb_file ",
             " WHERE axb01 ='",tm.axa01,"'",
             "   AND axb04!='",g_dept.axb04,"'"
   PREPARE i110_axb_p FROM l_sql
   IF STATUS THEN
      CALL cl_err('i110_axb_p',STATUS,1)
   END IF
   DECLARE i110_axb_c CURSOR FOR i110_axb_p
   FOREACH i110_axb_c INTO g_axb04
      IF SQLCA.SQLCODE THEN
         CALL s_errmsg(' ',' ','i110_axb_c:',STATUS,1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
      SELECT axz05 INTO l_axz05 FROM axz_file WHERE axz01 = g_axb04
      ##来源公司为下层公司,对冲公司为当前层除下层公司外的其他下层公司
      FOR j = 1 to g_axff.getlength()   #luttb 110309 先修改  这时候多出空白行
          INITIALIZE l_axf.* TO NULL
          LET l_axf.axf01 = g_axff[j].axff01
          IF l_axf.axf01 = 'MISC' THEN
             DECLARE sel_axs_cur1 CURSOR FOR
              SELECT * FROM axss_file WHERE axss01 = l_axf.axf01
                 AND axss00 = g_aaz641        #No.MOD-C90156 aaw01 --> aaz641
             INITIALIZE l_axs.* TO NULL
             FOREACH sel_axs_cur1 INTO l_axss.*
                 LET l_axs.axs01 = l_axss.axss01
                 LET l_axs.axs03 = l_axss.axss03
                 LET l_axs.axs09 = g_dept.axb04
                 LET l_axs.axs10 = g_axb04
                 LET l_axs.axs13 = tm.axa01
                 CALL s_aaz641_dbs(tm.axa01,l_axs.axs09) RETURNING g_dbs_axz03
                 CALL s_get_aaz641(g_dbs_axz03) RETURNING l_axs.axs00
                 CALL s_aaz641_dbs(tm.axa01,l_axs.axs10) RETURNING g_dbs_gl
                 CALL s_get_aaz641(g_dbs_gl) RETURNING l_axs.axs12
                 INSERT INTO axs_file VALUES(l_axs.*)
                 IF SQLCA.sqlcode THEN
                   # CALL cl_err3("ins","axs_file",l_axs.axs00,l_axs.axs01,SQLCA.sqlcode,"","",1)  #luttb 110311
                    LET g_showmsg =l_axs.axs09,"/",l_axs.axs10
                    CALL s_errmsg('axs09,axs10',g_showmsg,'ins axs_file',SQLCA.sqlcode,1)
                    LET g_success = 'N'
                    EXIT FOREACH
                 END IF
             END FOREACH
          END IF
          LET l_axf.axf02 = g_axff[j].axff02
          IF l_axf.axf02 = 'MISC' THEN
             DECLARE sel_axtt_cur1 CURSOR FOR
              SELECT * FROM axtt_file
               WHERE axtt00 = g_aaz641        #No.MOD-C90156 aaw01 --> aaz641
                 AND axtt01 = l_axf.axf02
             INITIALIZE l_axt.* TO NULL
             FOREACH sel_axtt_cur1 INTO l_axtt.*
                 LET l_axt.axt01 = l_axtt.axtt01
                 LET l_axt.axt03 = l_axtt.axtt03
                 LET l_axt.axt04 = l_axtt.axtt04
                 LET l_axt.axt05 = l_axtt.axtt05
                 LET l_axt.axt06 = l_axtt.axtt06
                 LET l_axt.axt09 = g_dept.axb04
                 LET l_axt.axt10 = g_axb04
                 LET l_axt.axt13 = tm.axa01
                 CALL s_aaz641_dbs(tm.axa01,l_axt.axt09) RETURNING g_dbs_axz03
                 CALL s_get_aaz641(g_dbs_axz03) RETURNING l_axt.axt00
                 CALL s_aaz641_dbs(tm.axa01,l_axt.axt10) RETURNING g_dbs_gl
                 CALL s_get_aaz641(g_dbs_gl) RETURNING l_axt.axt12
                 INSERT INTO axt_file VALUES(l_axt.*)
                 IF SQLCA.sqlcode THEN
                    #CALL cl_err3("ins","axt_file",l_axt.axt00,l_axt.axt01,SQLCA.sqlcode,"","",1)
                    LET g_showmsg =l_axt.axt09,"/",l_axt.axt10
                    CALL s_errmsg('axt09,axt10',g_showmsg,'ins axt_file',SQLCA.sqlcode,1)
                    LET g_success = 'N'
                    EXIT FOREACH
                 END IF
             END FOREACH
          END IF
          LET l_axf.axf03 = g_axff[j].axff03
          LET l_axf.axf04 = g_axff[j].axff04
          LET l_axf.axfuser = g_user
          LET l_axf.axfgrup = g_grup
          LET l_axf.axf09 = g_dept.axb04
          LET l_axf.axf10 = g_axb04 
          CALL s_aaz641_dbs(tm.axa01,l_axf.axf09) RETURNING g_dbs_axz03
          CALL s_get_aaz641(g_dbs_axz03) RETURNING l_axf.axf00
          CALL s_aaz641_dbs(tm.axa01,l_axf.axf10) RETURNING g_dbs_gl
          CALL s_get_aaz641(g_dbs_gl) RETURNING l_axf.axf12
          LET l_axf.axf13 = tm.axa01
          LET l_axf.axf14 = g_axff[j].axff05
          LET l_axf.axf15 = g_axff[j].axff06
          LET l_axf.axf16 = tm.axa02
          LET l_axf.axf17 = g_axff[j].axff07
          LET l_axf.axfacti = g_axff[j].axffacti
          INSERT INTO axf_file VALUES(l_axf.*)
          IF SQLCA.sqlcode THEN
             #CALL cl_err3("ins","axf_file",l_axf.axf09,l_axf.axf10,SQLCA.sqlcode,"","",1)
             LET g_showmsg =l_axf.axf09,"/",l_axf.axf10
             CALL s_errmsg('axf09,axf10',g_showmsg,'ins axf_file',SQLCA.sqlcode,1)
             LET g_success = 'N'
             EXIT FOREACH
          END IF
      END FOR

   END FOREACH
END FUNCTION

FUNCTION i110_dept()
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_sql       STRING
   DEFINE l_dept      RECORD
                       axa01      LIKE axa_file.axa01,  #族群代號
                       axa02      LIKE axa_file.axa02,  #上層公司
                       axa03      LIKE axa_file.axa03,  #帳別
                       axb04      LIKE axb_file.axb04,  #下層公司
                       axb05      LIKE axb_file.axb05   #帳別
                      END RECORD
   #假設集團公司層級如下:A下面有B、C,B下面有D、E,E下面有F,C下面有G
   #       A             #需產生A-B
   #   ┌─┴─┐        #      A-C
   #   B        C        #      A-D
   # ┌┴┐     │       #      A-E
   # D   E      G        #      A-F
   #     │              #      A-G等關係人層級資料
   #     F

   #1.先檢查Temptable裡有沒有資料,沒有的話,先寫入最上一層的關係人層級資料
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM i110_tmp
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt = 0 THEN CALL i110_bom(tm.axa01,tm.axa02,tm.axa03) END IF

   #2-1.檢查Temptable裡有沒有chk=N的資料(表示還未抓它的下層公司),
   #    沒有的話,表示所有層級資料都產生了,離開此FUNCTION
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM i110_tmp WHERE chk='N'
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt = 0 THEN RETURN END IF

   #2-2.檢查Temptable裡有沒有chk=N的資料(表示還未抓它的下層公司),
   #    以下層公司當上層公司,去抓其下層公司,產生跨層的公司層級資料
   DECLARE axb_curs1 CURSOR FOR
      SELECT axa01,axa02,axa03,axb04,axb05
        FROM i110_tmp
       WHERE chk='N'
   FOREACH axb_curs1 INTO l_dept.*
      CALL i110_bom(l_dept.axa01,l_dept.axb04,l_dept.axb05)
      UPDATE i110_tmp SET chk='Y'
       WHERE axa01=l_dept.axa01
         AND axb04=l_dept.axb04
         AND axb05=l_dept.axb05
   END FOREACH

   CALL i110_dept()

END FUNCTION

FUNCTION i110_bom(p_axa01,p_axa02,p_axa03)
   DEFINE p_axa01   LIKE axa_file.axa01   #族群代號
   DEFINE p_axa02   LIKE axa_file.axa02   #上層公司
   DEFINE p_axa03   LIKE axa_file.axa03   #帳別
   DEFINE l_sql       STRING

   LET l_sql="INSERT INTO i110_tmp (chk,axa01,axa02,axa03,axb04,axb05)",
             "SELECT 'N',",
             "       '",tm.axa01 CLIPPED,"',",
             "       '",tm.axa02 CLIPPED,"',",
             "       '",tm.axa03 CLIPPED,"',",
             "       axb04,axb05",
             "  FROM axb_file,axa_file ",
             " WHERE axa01=axb01 AND axa02=axb02 AND axa03=axb03 ",
             "   AND axb06 = 'Y'",    #luttb 110311 add
             "   AND axa01=? AND axa02=? AND axa03=?"
   PREPARE p500_axb_p1 FROM l_sql
   EXECUTE p500_axb_p1 USING p_axa01,p_axa02,p_axa03

END FUNCTION
#NO.FUN-B40104
