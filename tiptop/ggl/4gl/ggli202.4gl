# Prog. Version..: '5.30.06-13.04.22(00004)'     #
# Pattern name...: ggli202.4gl
# Descriptions...: 會計科目對沖關係維護作業
# Date & Author..: 10/12/23 By lutingting
# Modify.........: NO.FUN-B40104 By jll  合并报表作业產品
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植
# Modify.........: NO.FUN-C80056 12/08/15 By xuxz 添加asqq18的控管
# Modify.........: NO.TQC-C80163 12/08/29 By lujh 整批生成科目對衝關系時，產生的資料不完整
# Modify.........: No:FUN-D30032 13/04/02 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE                                            #FUN-BB0036
    g_asqq           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        asqq05       LIKE asqq_file.asqq05,  
        asqq06       LIKE asqq_file.asqq06, 
        asqq01       LIKE asqq_file.asqq01,   #科目編號
        asqq01_desc  LIKE aag_file.aag02,
        asqq07       LIKE asqq_file.asqq07,
        asqq02       LIKE asqq_file.asqq02,   #簡稱
        asqq02_desc  LIKE aag_file.aag02,
        asqq03       LIKE asqq_file.asqq03,
        asqq18       LIKE asqq_file.asqq18, #FUN-C80056 add
        asqq04       LIKE asqq_file.asqq04,
        asqq04_desc  LIKE aag_file.aag02,
        asqqacti     LIKE asqq_file.asqqacti
                    END RECORD,
    g_asqq_t         RECORD                 #程式變數 (舊值)
        asqq05       LIKE asqq_file.asqq05,
        asqq06       LIKE asqq_file.asqq06,
        asqq01       LIKE asqq_file.asqq01,   #科目編號
        asqq01_desc  LIKE aag_file.aag02,
        asqq07       LIKE asqq_file.asqq07, 
        asqq02       LIKE asqq_file.asqq02,   #簡稱
        asqq02_desc  LIKE aag_file.aag02,
        asqq03       LIKE asqq_file.asqq03,
        asqq18       LIKE asqq_file.asqq18, #FUN-C80056 add
        asqq04       LIKE asqq_file.asqq04,
        asqq04_desc  LIKE aag_file.aag02,
        asqqacti     LIKE asqq_file.asqqacti
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
DEFINE g_asz01        LIKE asz_file.asz01
DEFINE g_dbs_gl       LIKE type_file.chr21
DEFINE g_dbs_asg03    LIKE type_file.chr21 
DEFINE tm          RECORD
                       asa01      LIKE asa_file.asa01,  #族群代號
                       asa02      LIKE asa_file.asa02,  #上層公司
                       asa03      LIKE asa_file.asa03,  #帳別
                       asb04      LIKE asb_file.asb04,  #下層公司
                       asb05      LIKE asb_file.asb05   #帳別
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
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET p_row = 4 LET p_col = 12

   SELECT asz01 INTO g_asz01 FROM asz_file WHERE asz00 = '0'
   LET g_dbs = s_dbstring(g_dbs)
   OPEN WINDOW i110_w AT p_row,p_col WITH FORM "ggl/42f/ggli202"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()

   CALL i110_menu()
   CLOSE FORM i110_w                      #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

#QBE 查詢資料
FUNCTION i110_b_askkey() 
    CLEAR FORM                            #清除畫面
    CALL g_asqq.clear()
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
    CONSTRUCT g_wc ON asqq05,asqq06,asqq01,asqq07,asqq02,asqq03,asqq18,asqq04#FUN-C80056 add asqq18
         FROM s_asqq[1].asqq05,s_asqq[1].asqq06,s_asqq[1].asqq01,
              s_asqq[1].asqq07,s_asqq[1].asqq02,s_asqq[1].asqq03,s_asqq[1].asqq18, #FUN-C80056 add asqq18
              s_asqq[1].asqq04 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()

       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(asqq01) #來源會計科目
                CALL q_m_aag2(TRUE,TRUE,g_plant,g_asqq[1].asqq01,'23',g_asz01)      
                     RETURNING g_qryparam.multiret                                      
                DISPLAY g_qryparam.multiret TO asqq01                                  
                NEXT FIELD asqq01        
             WHEN INFIELD(asqq02) #對沖會計科目
                CALL q_m_aag2(TRUE,TRUE,g_plant,g_asqq[1].asqq02,'23',g_asz01)      
                     RETURNING g_qryparam.multiret                                      
                DISPLAY g_qryparam.multiret TO asqq02                                  
                NEXT FIELD asqq02    
             WHEN INFIELD(asqq04) #差額對應會計科目
                CALL q_m_aag2(TRUE,TRUE,g_plant,g_asqq[1].asqq04,'23',g_asz01)
                     RETURNING g_qryparam.multiret                                
                DISPLAY g_qryparam.multiret TO asqq04                            
                NEXT FIELD asqq04     
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
         WHEN "gen_ggli203"
            IF cl_chk_act_auth() THEN
               CALL i110_gen()
            END IF
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
                  LET g_doc.column1 = "asqq01"
                  LET g_doc.column2 = "asqq02"  
                  LET g_doc.value1 = g_asqq[l_ac].asqq01
                  LET g_doc.value2 = g_asqq[l_ac].asqq02  
                  CALL cl_doc()
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_asqq),'','')
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

    LET g_sql = "SELECT asqq05,asqq06,asqq01,'',asqq07,asqq02,'',asqq03,asqq18,asqq04,'',asqqacti FROM asqq_file ",  #FUN-C80056 add asqq18
                " WHERE ",p_wc CLIPPED, 
                " ORDER BY asqq01"
    PREPARE i110_prepare2 FROM g_sql      #預備一下
    DECLARE asqq_cs CURSOR FOR i110_prepare2

    CALL g_asqq.clear()

    LET g_cnt = 1
    LET g_rec_b = 0

    FOREACH asqq_cs INTO g_asqq[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF

      CALL i110_aag('a',g_asqq[g_cnt].asqq01)  
           RETURNING g_asqq[g_cnt].asqq01_desc  

      CALL i110_aag('a',g_asqq[g_cnt].asqq02) 
           RETURNING g_asqq[g_cnt].asqq02_desc

      CALL i110_aag('a',g_asqq[g_cnt].asqq04)
           RETURNING g_asqq[g_cnt].asqq04_desc 

      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
    END FOREACH
    CALL g_asqq.deleteElement(g_cnt)
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

    LET g_forupd_sql = "SELECT asqq05,asqq06,asqq01,'',asqq07,asqq02,'',asqq03,asqq18,asqq04,'',asqqacti FROM asqq_file ", #FUN-C80056 add asqq18
                       "WHERE asqq01 = ? AND asqq02=?  FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i110_bcl CURSOR FROM g_forupd_sql  

    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_asqq WITHOUT DEFAULTS FROM s_asqq.*
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
               LET g_asqq_t.* = g_asqq[l_ac].*
               OPEN i110_bcl USING g_asqq_t.asqq01,g_asqq_t.asqq02
               IF STATUS THEN
                  CALL cl_err("OPEN i110_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i110_bcl INTO g_asqq[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_asqq_t.asqq01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  SELECT aag02 INTO g_asqq[l_ac].asqq01_desc FROM aag_file
                   WHERE aag01=g_asqq[l_ac].asqq01
                    AND aag00=g_asz01
                  SELECT aag02 INTO g_asqq[l_ac].asqq02_desc FROM aag_file
                   WHERE aag01=g_asqq[l_ac].asqq02
                    AND aag00=g_asz01 
                  SELECT aag02 INTO g_asqq[l_ac].asqq04_desc FROM aag_file
                   WHERE aag01=g_asqq[l_ac].asqq04
                     AND aag00=g_asz01
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
            INITIALIZE g_asqq[l_ac].* TO NULL
            LET g_asqq[l_ac].asqq03  ='N'
            LET g_asqq[l_ac].asqqacti='Y'
            LET g_asqq[l_ac].asqq05 = 'N' 
            LET g_asqq[l_ac].asqq06 = '1' 
            LET g_asqq[l_ac].asqq07 = '1' 
            LET g_asqq_t.* = g_asqq[l_ac].* 
            CALL cl_show_fld_cont()
            NEXT FIELD asqq05    

        AFTER INSERT
            IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              INITIALIZE g_asqq[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_asqq[l_ac].* TO s_asqq.*
              CALL g_asqq.deleteElement(g_rec_b+1)
              ROLLBACK WORK
              EXIT INPUT
            END IF
            IF NOT cl_null(g_asqq[l_ac].asqq01) AND NOT cl_null(g_asqq[l_ac].asqq02) THEN 
                INSERT INTO asqq_file(asqq01,asqq02,asqq03,asqq18,asqq04,#FUN-C80056 add asqq18
                                      asqq05,asqq06,asqq07,asqqacti)
                              VALUES(g_asqq[l_ac].asqq01,g_asqq[l_ac].asqq02,g_asqq[l_ac].asqq03,g_asqq[l_ac].asqq18,g_asqq[l_ac].asqq04,#FUN-C80056 add asqq18
                                     g_asqq[l_ac].asqq05,g_asqq[l_ac].asqq06,g_asqq[l_ac].asqq07,g_asqq[l_ac].asqqacti)
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins","asqq_file",g_asqq[l_ac].asqq01,"",SQLCA.sqlcode,"","",1) 
                    CANCEL INSERT
                ELSE
                    LET g_rec_b = g_rec_b + 1
                    DISPLAY g_rec_b TO FORMONLY.cn2
                    MESSAGE 'INSERT O.K'
                END IF
            ELSE               
                CALL cl_err('','9044',1)   
            END IF                        

       AFTER FIELD asqq05 
          IF g_asqq[l_ac].asqq05 = 'Y' THEN
              FOR i = 1 TO ARR_COUNT()
                  IF i <> l_ac THEN
                      IF g_asqq[i].asqq05 = 'Y' THEN
                          LET g_asqq[l_ac].asqq05 = 'N' 
                          DISPLAY BY NAME g_asqq[l_ac].asqq05
                          CALL cl_err('','agl027',1)
                      END IF
                  END IF
              END FOR
          END IF

        AFTER FIELD asqq01   
           IF NOT cl_null(g_asqq[l_ac].asqq01) THEN
              IF g_asqq[l_ac].asqq01[1,4]<>'MISC' THEN
                 IF g_asqq_t.asqq01 IS NULL OR
                    g_asqq_t.asqq02 IS NULL OR   
                    (g_asqq[l_ac].asqq01 != g_asqq_t.asqq01) OR  
                   (g_asqq[l_ac].asqq02 != g_asqq_t.asqq02) THEN
                    SELECT count(*) INTO l_n FROM asqq_file
                     WHERE asqq01 = g_asqq[l_ac].asqq01
                       AND asqq02 = g_asqq[l_ac].asqq02 
                    IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_asqq[l_ac].asqq01 = g_asqq_t.asqq01
                       NEXT FIELD asqq01
                    END IF
                 END IF
                 CALL i110_aag('a',g_asqq[l_ac].asqq01)
                      RETURNING g_asqq[l_ac].asqq01_desc 
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_asqq[l_ac].asqq01,g_errno,0)
                    LET g_asqq[l_ac].asqq01=g_asqq_t.asqq01
                    NEXT FIELD asqq01
                 ELSE
                    DISPLAY g_asqq[l_ac].asqq01_desc TO asqq01_desc
                 END IF
              ELSE
                 LET g_asqq[l_ac].asqq01_desc=NULL
                 DISPLAY BY NAME g_asqq[l_ac].asqq01_desc
              END IF
              #luttb 110311--add--str--
              IF NOT cl_null(g_asqq_t.asqq01)  
                 AND g_asqq_t.asqq01[1,4]='MISC'
                 AND g_asqq_t.asqq01 !=g_asqq[l_ac].asqq01[1,4] THEN
                 DELETE FROM astt_file
                  WHERE astt00 = g_asz01   
                    AND astt01 = g_asqq_t.asqq01
              END IF 
              #luttb 110311--add-end
              LET l_cmd=g_asqq[l_ac].asqq01[1,4]   
              IF UPSHIFT(l_cmd) = 'MISC' THEN
                 CALL i110_msa()
              END IF
           END IF
 
        AFTER FIELD asqq02
           IF NOT cl_null(g_asqq[l_ac].asqq02) THEN
              IF g_asqq[l_ac].asqq02[1,4]<>'MISC' THEN 
                 CALL i110_aag('a',g_asqq[l_ac].asqq02)
                      RETURNING g_asqq[l_ac].asqq02_desc 
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_asqq[l_ac].asqq02,g_errno,0)
                    LET g_asqq[l_ac].asqq02=g_asqq_t.asqq02
                    NEXT FIELD asqq02
                 ELSE
                    DISPLAY g_asqq[l_ac].asqq02_desc TO asqq02_desc
                 END IF
              ELSE
                 LET g_asqq[l_ac].asqq02_desc=NULL
                 DISPLAY BY NAME g_asqq[l_ac].asqq02_desc
              END IF
              #luttb 110311--add--str--
              IF NOT cl_null(g_asqq_t.asqq02)
                 AND g_asqq_t.asqq02[1,4]='MISC'
                 AND g_asqq_t.asqq02 !=g_asqq[l_ac].asqq02[1,4] THEN
                 DELETE FROM asuu_file
                  WHERE asuu00 = g_asz01
                    AND asuu01 = g_asqq_t.asqq02
              END IF
              #luttb 110311--add--end
              LET l_cmd=g_asqq[l_ac].asqq02[1,4]   
              IF UPSHIFT(l_cmd) = 'MISC' THEN
                 CALL i110_moa()
              END IF
           END IF
        AFTER FIELD asqq03
           IF NOT cl_null(g_asqq[l_ac].asqq03) THEN
              IF g_asqq[l_ac].asqq03 NOT MATCHES'[YN]' THEN
                 NEXT FIELD asqq03
              END IF
           END IF
        AFTER FIELD asqq04
           IF NOT cl_null(g_asqq[l_ac].asqq04) THEN
              CALL i110_aag('a',g_asqq[l_ac].asqq04)   
                   RETURNING g_asqq[l_ac].asqq04_desc 
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_asqq[l_ac].asqq04,g_errno,0)
                 LET g_asqq[l_ac].asqq04=g_asqq_t.asqq04
                 NEXT FIELD asqq04
               ELSE
                 DISPLAY g_asqq[l_ac].asqq02_desc TO asqq04_desc
              END IF
           END IF

        BEFORE DELETE                            #是否取消單身
            IF g_asqq_t.asqq01 IS NOT NULL THEN
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
                LET g_doc.column1 = "asqq01"              
                LET g_doc.column2 = "asqq02"             
                LET g_doc.value1 = g_asqq[l_ac].asqq01  
                LET g_doc.value2 = g_asqq[l_ac].asqq02 
                CALL cl_del_doc()                     

                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF

                DELETE FROM asqq_file
                 WHERE asqq01 = g_asqq_t.asqq01
                   AND asqq02 = g_asqq_t.asqq02 
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","asqq_file",g_asqq_t.asqq01,"",SQLCA.sqlcode,"","",1) 
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
               LET g_asqq[l_ac].* = g_asqq_t.*
               CLOSE i110_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_asqq[l_ac].asqq01,-263,1)
               LET g_asqq[l_ac].* = g_asqq_t.*
            ELSE
               UPDATE asqq_file SET asqq01 = g_asqq[l_ac].asqq01,
                                   asqq02 = g_asqq[l_ac].asqq02,
                                   asqq03 = g_asqq[l_ac].asqq03,
                                   asqq18 = g_asqq[l_ac].asqq18,
                                   asqq04 = g_asqq[l_ac].asqq04,
                                   asqq05 = g_asqq[l_ac].asqq05,  
                                   asqq06 = g_asqq[l_ac].asqq06, 
                                   asqq07 = g_asqq[l_ac].asqq07,
                                   asqqacti = g_asqq[l_ac].asqqacti 
                WHERE asqq01 = g_asqq_t.asqq01 
                  AND asqq02 = g_asqq_t.asqq02 
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","asqq_file",g_asqq_t.asqq01,"",SQLCA.sqlcode,"","",1)  
                  LET g_asqq[l_ac].* = g_asqq_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac                    #FUN-D30032 Mark 
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              #LET g_asqq[l_ac].* = g_asqq_t.*   #FUN-D30032 Mark
               #FUN-D30032--add--str--
               IF p_cmd = 'u' THEN
                  LET g_asqq[l_ac].* = g_asqq_t.*
               ELSE
                  CALL g_asqq.deleteElement(l_ac)
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
            LET l_ac_t = l_ac                    #FUN-D30032 Add
            LET g_asqq_t.* = g_asqq[l_ac].*
            CLOSE i110_bcl
            COMMIT WORK
            CALL g_asqq.deleteElement(g_rec_b+1)
            #FUN-C80056 --add--str
            IF g_asqq[l_ac].asqq01[1,4] = 'MISC' OR g_asqq[l_ac].asqq02[1,4] = 'MISC' THEN 
	       IF g_asqq[l_ac].asqq18 <> '3' THEN 
                  CALL cl_err('','ggl-006',1)
                  LET g_asqq[l_ac].asqq18 = 3
                  UPDATE asqq_file SET asqq18 = '3'
                   WHERE asqq01 = g_asqq_t.asqq01 
                     AND asqq02 = g_asqq_t.asqq02 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("upd","asqq_file",g_asqq_t.asqq01,"",SQLCA.sqlcode,"","",1)  
                  ELSE
                     MESSAGE 'UPDATE O.K'
                     COMMIT WORK
                  END IF
                  NEXT FIELD asqq18
               END IF
            END IF
            #FUN-C80056 --add--end

        ON ACTION mntn_acc_code1
           IF g_asqq[l_ac].asqq01 = 'MISC' THEN    
              CALL cl_err('','agl-255',1)         
              CONTINUE INPUT                     
           ELSE                                 
              LET g_msg = "agli102 '",g_asz01,"' '",g_asqq[l_ac].asqq01 ,"' " 
              CALL cl_cmdrun(g_msg)
           END IF            
        ON ACTION mntn_acc_code2
           IF g_asqq[l_ac].asqq02 = 'MISC' THEN   
              CALL cl_err('','agl-256',1)        
              CONTINUE INPUT                    
           ELSE                                
              LET g_msg = "agli102 '",g_asz01,"' '",g_asqq[l_ac].asqq02 ,"' " 
              CALL cl_cmdrun(g_msg)
           END IF               
        ON ACTION mntn_acc_code4
           LET g_msg = "agli102 '",g_asz01,"' '",g_asqq[l_ac].asqq04 ,"' "
           CALL cl_cmdrun(g_msg)

        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(asqq01) AND l_ac > 1 THEN
              LET g_asqq[l_ac].* = g_asqq[l_ac-1].*
              NEXT FIELD asqq01
           END IF

        ON ACTION CONTROLZ
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
              WHEN INFIELD(asqq01) #來源會計科目
                 CALL q_m_aag2(FALSE,TRUE,g_plant,g_asqq[l_ac].asqq01,'23',g_asz01)
                     RETURNING g_asqq[l_ac].asqq01                               
                 DISPLAY BY NAME g_asqq[l_ac].asqq01                            
                 NEXT FIELD asqq01                                             
              WHEN INFIELD(asqq02) #對沖會計科目
                 CALL q_m_aag2(FALSE,TRUE,g_plant,g_asqq[l_ac].asqq02,'23',g_asz01)
                     RETURNING g_asqq[l_ac].asqq02                                     
                 DISPLAY BY NAME g_asqq[l_ac].asqq02                                  
                 NEXT FIELD asqq02                                                   
              WHEN INFIELD(asqq04) #差額對應會計科目
                 CALL q_m_aag2(FALSE,TRUE,g_plant,g_asqq[l_ac].asqq04,'23',g_asz01)
                     RETURNING g_asqq[l_ac].asqq04                                     
                 DISPLAY BY NAME g_asqq[l_ac].asqq04                                  
                 NEXT FIELD asqq04  
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

   CALL cl_set_comp_entry("asqq01,asqq02",TRUE)  #FUN-960093
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
      AND aag00 = g_asz01
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

   DISPLAY ARRAY g_asqq TO s_asqq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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

      ON ACTION gen_ggli203
         LET g_action_choice="gen_ggli203"
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
   LET l_cmd=g_asqq[l_ac].asqq01[1,4]   
   IF UPSHIFT(l_cmd) <> 'MISC' THEN
      CALL cl_err('','agl-099',0)
      RETURN
   END IF

   LET l_cmd="ggli2034 '",g_asz01,"' ", 
             "'",g_asqq[l_ac].asqq01,"' "    #來源會計科目編號 
   CALL cl_cmdrun_wait(l_cmd)
END FUNCTION

FUNCTION i110_moa()
   DEFINE l_cmd STRING
   IF g_rec_b=0 THEN
      CALL cl_err('','amr-304',0)
      RETURN
   END IF
   LET l_cmd=g_asqq[l_ac].asqq02[1,4]   
   IF UPSHIFT(l_cmd) <> 'MISC' THEN
      CALL cl_err('','agl-123',0)
      RETURN
   END IF

   LET l_cmd="ggli2035 '",g_asz01,"' ",     #來源帳別
             "'",g_asqq[l_ac].asqq02,"' "    #來源會計科目編號

   CALL cl_cmdrun_wait(l_cmd)
END FUNCTION

FUNCTION i110_chk_source_acc()
   LET g_sql=g_asqq[l_ac].asqq01[1,4]
   IF UPSHIFT(g_sql) = 'MISC' THEN
      SELECT COUNT(*) INTO g_cnt FROM astt_file
                                WHERE astt00=g_asz01
                                  AND astt01=g_asqq[l_ac].asqq01
      IF SQLCA.sqlcode OR cl_null(g_cnt) THEN
         LET g_cnt=0
      END IF
      IF g_cnt>0 THEN
         DELETE FROM astt_file 
          WHERE astt00=g_asz01
            AND astt01=g_asqq[l_ac].asqq01                                                                       
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err('','agl-151',1)
            RETURN FALSE
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION i110_chk_oppsite_acc()
   LET g_sql=g_asqq[l_ac].asqq02[1,4]
   IF UPSHIFT(g_sql) = 'MISC' THEN
      SELECT COUNT(*) INTO g_cnt FROM asuu_file
                                WHERE asuu00=g_asz01
                                  AND asuu01=g_asqq[l_ac].asqq02
      IF SQLCA.sqlcode OR cl_null(g_cnt) THEN
         LET g_cnt=0
      END IF
      IF g_cnt>0 THEN
         DELETE FROM asuu_file 
          WHERE asuu00=g_asz01
            AND asuu01=g_asqq[l_ac].asqq02                                                                       
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
                 asa01     LIKE asa_file.asa01,  #族群代號
                 asa02     LIKE asa_file.asa02,  #上層公司
                 asa03     LIKE asa_file.asa03,  #帳別
                 asb04     LIKE asb_file.asb04,  #下層公司
                 asb05     LIKE asb_file.asb05   #帳別
                END RECORD,
       l_asq    RECORD LIKE asq_file.*,
       l_asqq   RECORD LIKE asqq_file.*,
       l_ast    RECORD LIKE ast_file.*,
       l_astt   RECORD LIKE astt_file.*,
       l_asu    RECORD LIKE asu_file.*,
       l_asuu   RECORD LIKE asuu_file.*,
       l_sql    STRING,
       i,j,g_no LIKE type_file.num5
DEFINE l_count  LIKE type_file.num5     #111101 lilingyu

   LET p_row = 4 LET p_col = 12
   OPEN WINDOW i110_w1 AT p_row,p_col WITH FORM "ggl/42f/ggli202_1"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL cl_ui_locale("ggli202_1")
   INPUT tm.asa01 WITHOUT DEFAULTS FROM asa01
      AFTER FIELD asa01   #族群代號
         IF NOT cl_null(tm.asa01) THEN
            SELECT DISTINCT asa01 FROM asa_file WHERE asa01=tm.asa01
            IF STATUS THEN
               CALL cl_err3("sel","asa_file",tm.asa01,tm.asa02,"agl-117","","",0)
               NEXT FIELD asa01
            ELSE
               SELECT asa02,asa03 INTO tm.asa02,tm.asa03 FROM asa_file
                WHERE asa01 = tm.asa01
                  AND asa04 = 'Y'
            END IF
         END IF

      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(asa01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_asa5"
                LET g_qryparam.default1 = tm.asa01
                CALL cl_create_qry() RETURNING tm.asa01,tm.asa02,tm.asa03
                DISPLAY BY NAME tm.asa01
                NEXT FIELD asa01
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
      asa01     LIKE asa_file.asa01,
      asa02     LIKE asa_file.asa02,
      asa03     LIKE asa_file.asa03,
      asb04     LIKE asb_file.asb04,
      asb05     LIKE asb_file.asb05    );
   CALL g_dept.clear()   #將g_dept清空

   CALL i110_dept()    #抓取關係人層級 

   BEGIN WORK
   CALL s_showmsg_init()
   LET g_success=  'Y'
   DELETE FROM asq_file WHERE asq13 = tm.asa01
   IF SQLCA.sqlcode THEN
     CALL s_errmsg('asa01',tm.asa01,'DELETE asa_file',STATUS,1)
     LET g_success = 'N'
   END IF
   DELETE FROM asu_file WHERE asu13 = tm.asa01
   IF SQLCA.sqlcode THEN
     CALL s_errmsg('asa01',tm.asa01,'DELETE asu_file',STATUS,1)
     LET g_success = 'N'
   END IF
   DELETE FROM ast_file WHERE ast13 = tm.asa01
   IF SQLCA.sqlcode THEN
     CALL s_errmsg('asa01',tm.asa01,'DELETE ast_file',STATUS,1)
     LET g_success = 'N'
   END IF
   LET l_sql=" SELECT asa01,asa02,asa03,asb04,asb05",
             "   FROM i110_tmp ",
             "  ORDER BY asa01,asa02,asa03,asb04"
   PREPARE p500_asa_p FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare:1',STATUS,1)
      CALL cl_batch_bg_javamail('N')
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE p500_asa_c CURSOR FOR p500_asa_p
   LET g_no = 1
   CALL s_showmsg_init()
   FOREACH p500_asa_c INTO g_dept[g_no].*
      IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success='Y'
      END IF
      IF SQLCA.SQLCODE THEN
         CALL s_errmsg(' ',' ','for_asa_c:',STATUS,1)
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
      FOR j = 1 to g_asqq.getlength()
          INITIALIZE l_asq.* TO NULL
          LET l_asq.asq01 = g_asqq[j].asqq01
          IF l_asq.asq01 = 'MISC' THEN
             DECLARE sel_ast_cur CURSOR FOR 
              SELECT * FROM astt_file WHERE astt01 = l_asq.asq01
                 AND astt00 = g_asz01 
             INITIALIZE l_ast.* TO NULL
             FOREACH sel_ast_cur INTO l_astt.*
                 LET l_ast.ast01 = l_astt.astt01
                 LET l_ast.ast03 = l_astt.astt03
                 LET l_ast.ast09 = g_dept[i].asa02
                 LET l_ast.ast10 = g_dept[i].asb04 
                 CALL s_aaz641_asg(tm.asa01,l_ast.ast09) RETURNING g_dbs_asg03
                 CALL s_get_aaz641_asg(g_dbs_asg03) RETURNING l_ast.ast00
                 CALL s_aaz641_asg(tm.asa01,l_ast.ast10) RETURNING g_dbs_gl
                 CALL s_get_aaz641_asg(g_dbs_gl) RETURNING l_ast.ast12
                 LET l_ast.ast13 = tm.asa01
                 INSERT INTO ast_file VALUES(l_ast.*)
                 IF SQLCA.sqlcode THEN
                    #CALL cl_err3("ins","ast_file",l_ast.ast00,l_ast.ast01,SQLCA.sqlcode,"","",1) #luttb 110311
                    LET g_showmsg =l_ast.ast09,"/",l_ast.ast10
                    CALL s_errmsg('ast09,ast10',g_showmsg,'ins ast_file',STATUS,1)
                    LET g_success = 'N'
                    EXIT FOREACH
                 END IF
             END FOREACH
          END IF 
          LET l_asq.asq02 = g_asqq[j].asqq02
          IF l_asq.asq02 = 'MISC' THEN
             DECLARE sel_asuu_cur CURSOR FOR
              SELECT * FROM asuu_file
               WHERE asuu00 = g_asz01
                 AND asuu01 = l_asq.asq02
             INITIALIZE l_asu.* TO NULL
             FOREACH sel_asuu_cur INTO l_asuu.*
                 LET l_asu.asu01 = l_asuu.asuu01
                 LET l_asu.asu03 = l_asuu.asuu03
                 LET l_asu.asu04 = l_asuu.asuu04
                 LET l_asu.asu05 = l_asuu.asuu05
                 LET l_asu.asu06 = l_asuu.asuu06
                 LET l_asu.asu09 = g_dept[i].asa02
                 LET l_asu.asu10 = g_dept[i].asb04
                 LET l_asu.asu13 = tm.asa01
                 CALL s_aaz641_asg(tm.asa01,l_asu.asu09) RETURNING g_dbs_asg03
                 CALL s_get_aaz641_asg(g_dbs_asg03) RETURNING l_asu.asu00
                 CALL s_aaz641_asg(tm.asa01,l_asu.asu10) RETURNING g_dbs_gl
                 CALL s_get_aaz641_asg(g_dbs_gl) RETURNING l_asu.asu12
                 INSERT INTO asu_file VALUES(l_asu.*)
                 IF SQLCA.sqlcode THEN
                   # CALL cl_err3("ins","asu_file",l_asu.asu00,l_asu.asu01,SQLCA.sqlcode,"","",1)  #luttb 110311
                    LET g_showmsg =l_asu.asu09,"/",l_asu.asu10
                    CALL s_errmsg('asu09,asu10',g_showmsg,'ins asu_file',STATUS,1)
                    LET g_success = 'N'
                    EXIT FOREACH
                 END IF
             END FOREACH
          END IF 
          LET l_asq.asq03 = g_asqq[j].asqq03
          LET l_asq.asq04 = g_asqq[j].asqq04 
          LET l_asq.asquser = g_user
          LET l_asq.asqgrup = g_grup
          LET l_asq.asq09 = g_dept[i].asa02
          LET l_asq.asq10 = g_dept[i].asb04
          CALL s_aaz641_asg(tm.asa01,l_asq.asq09) RETURNING g_dbs_asg03
          CALL s_get_aaz641_asg(g_dbs_asg03) RETURNING l_asq.asq00
          CALL s_aaz641_asg(tm.asa01,l_asq.asq10) RETURNING g_dbs_gl
          CALL s_get_aaz641_asg(g_dbs_gl) RETURNING l_asq.asq12
          LET l_asq.asq13 = tm.asa01
          LET l_asq.asq14 = g_asqq[j].asqq05
          LET l_asq.asq15 = g_asqq[j].asqq06
          LET l_asq.asq16 = tm.asa02
          LET l_asq.asq17 = g_asqq[j].asqq07
          LET l_asq.asqacti = g_asqq[j].asqqacti
          LET l_asq.asq18 = g_asqq[j].asqq18 #FUN-C80056 add
#TQC-C80163--mark--str--
#111101 lilingyu --begin--
#          LET l_count = 0 
#          SELECT COUNT(*) INTO l_count FROM asq_file
#           WHERE asq00 = l_asq.asq00
#             AND asq01 = l_asq.asq01
#             AND asq02 = l_asq.asq02
#             AND asq12 = l_asq.asq12
#             AND asq13 = l_asq.asq13
#             AND asq16 = l_asq.asq16
#             AND ((asq09=l_asq.asq10 AND asq10=l_asq.asq09) OR 
#                   (asq09=l_asq.asq09 AND asq10=l_asq.asq10))
#
#          IF l_count > 0 THEN 
#             CONTINUE FOR 
#          END IF            
#111101 lilingyu --end--
#TQC-C80163--mark--end-- 
         
          INSERT INTO asq_file VALUES(l_asq.*)
          IF SQLCA.sqlcode THEN
             #CALL cl_err3("ins","asq_file",l_asq.asq09,l_asq.asq10,SQLCA.sqlcode,"","",1)  #luttb 110311
             LET g_showmsg =l_asq.asq09,"/",l_asq.asq10
             CALL s_errmsg('asq09,asq10',g_showmsg,'ins asq_file',STATUS,1)
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
                     asa01      LIKE asa_file.asa01,   #族群代號
                     asa02      LIKE asa_file.asa02,   #上層公司
                     asa03      LIKE asa_file.asa03,   #帳別
                     asb04      LIKE asb_file.asb04,   #下層公司
                     asb05      LIKE asb_file.asb05    #帳別
                    END RECORD,
       l_ast        RECORD LIKE ast_file.*,
       l_astt       RECORD LIKE astt_file.*,
       l_asu        RECORD LIKE asu_file.*,
       l_asuu       RECORD LIKE asuu_file.*,
       l_asq        RECORD LIKE asq_file.*,    
       l_sql        STRING,
       g_asb04      LIKE asb_file.asb04,               #其他下層公司
       l_asg05      LIKE asg_file.asg05,
       i,j          LIKE type_file.num5
DEFINE l_count  LIKE type_file.num5     #111101 lilingyu

   #抓取其他子公司
   #luttb 110311--mod--str--
   LET l_sql="SELECT asa02 FROM asa_file ",
             " WHERE asa01 = '",tm.asa01,"'",
            # "   AND asa02 !='",tm.asa02,"'",   #luttb 110314
             "   AND asa02 !='",g_dept.asb04,"'", 
             "  UNION ",
             "SELECT asb04 ",
             "  FROM asb_file ",
             " WHERE asb01 ='",tm.asa01,"'",
             "   AND asb04!='",g_dept.asb04,"'"
   PREPARE i110_asb_p FROM l_sql
   IF STATUS THEN
      CALL cl_err('i110_asb_p',STATUS,1)
   END IF
   DECLARE i110_asb_c CURSOR FOR i110_asb_p
   FOREACH i110_asb_c INTO g_asb04
      IF SQLCA.SQLCODE THEN
         CALL s_errmsg(' ',' ','i110_asb_c:',STATUS,1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
      SELECT asg05 INTO l_asg05 FROM asg_file WHERE asg01 = g_asb04
      ##来源公司为下层公司,对冲公司为当前层除下层公司外的其他下层公司
      FOR j = 1 to g_asqq.getlength()   #luttb 110309 先修改  这时候多出空白行
          INITIALIZE l_asq.* TO NULL
          LET l_asq.asq01 = g_asqq[j].asqq01
          IF l_asq.asq01 = 'MISC' THEN
             DECLARE sel_ast_cur1 CURSOR FOR
              SELECT * FROM astt_file WHERE astt01 = l_asq.asq01
                 AND astt00 = g_asz01
             INITIALIZE l_ast.* TO NULL
             FOREACH sel_ast_cur1 INTO l_astt.*
                 LET l_ast.ast01 = l_astt.astt01
                 LET l_ast.ast03 = l_astt.astt03
                 LET l_ast.ast09 = g_dept.asb04
                 LET l_ast.ast10 = g_asb04
                 LET l_ast.ast13 = tm.asa01
                 CALL s_aaz641_asg(tm.asa01,l_ast.ast09) RETURNING g_dbs_asg03
                 CALL s_get_aaz641_asg(g_dbs_asg03) RETURNING l_ast.ast00
                 CALL s_aaz641_asg(tm.asa01,l_ast.ast10) RETURNING g_dbs_gl
                 CALL s_get_aaz641_asg(g_dbs_gl) RETURNING l_ast.ast12
                 INSERT INTO ast_file VALUES(l_ast.*)
                 IF SQLCA.sqlcode THEN
                   # CALL cl_err3("ins","ast_file",l_ast.ast00,l_ast.ast01,SQLCA.sqlcode,"","",1)  #luttb 110311
                    LET g_showmsg =l_ast.ast09,"/",l_ast.ast10
                    CALL s_errmsg('ast09,ast10',g_showmsg,'ins ast_file',SQLCA.sqlcode,1)
                    LET g_success = 'N'
                    EXIT FOREACH
                 END IF
             END FOREACH
          END IF
          LET l_asq.asq02 = g_asqq[j].asqq02
          IF l_asq.asq02 = 'MISC' THEN
             DECLARE sel_asuu_cur1 CURSOR FOR
              SELECT * FROM asuu_file
               WHERE asuu00 = g_asz01
                 AND asuu01 = l_asq.asq02
             INITIALIZE l_asu.* TO NULL
             FOREACH sel_asuu_cur1 INTO l_asuu.*
                 LET l_asu.asu01 = l_asuu.asuu01
                 LET l_asu.asu03 = l_asuu.asuu03
                 LET l_asu.asu04 = l_asuu.asuu04
                 LET l_asu.asu05 = l_asuu.asuu05
                 LET l_asu.asu06 = l_asuu.asuu06
                 LET l_asu.asu09 = g_dept.asb04
                 LET l_asu.asu10 = g_asb04
                 LET l_asu.asu13 = tm.asa01
                 CALL s_aaz641_asg(tm.asa01,l_asu.asu09) RETURNING g_dbs_asg03
                 CALL s_get_aaz641_asg(g_dbs_asg03) RETURNING l_asu.asu00
                 CALL s_aaz641_asg(tm.asa01,l_asu.asu10) RETURNING g_dbs_gl
                 CALL s_get_aaz641_asg(g_dbs_gl) RETURNING l_asu.asu12
                 INSERT INTO asu_file VALUES(l_asu.*)
                 IF SQLCA.sqlcode THEN
                    #CALL cl_err3("ins","asu_file",l_asu.asu00,l_asu.asu01,SQLCA.sqlcode,"","",1)
                    LET g_showmsg =l_asu.asu09,"/",l_asu.asu10
                    CALL s_errmsg('asu09,asu10',g_showmsg,'ins asu_file',SQLCA.sqlcode,1)
                    LET g_success = 'N'
                    EXIT FOREACH
                 END IF
             END FOREACH
          END IF
          LET l_asq.asq03 = g_asqq[j].asqq03
          LET l_asq.asq04 = g_asqq[j].asqq04
          LET l_asq.asquser = g_user
          LET l_asq.asqgrup = g_grup
          LET l_asq.asq09 = g_dept.asb04
          LET l_asq.asq10 = g_asb04 
          CALL s_aaz641_asg(tm.asa01,l_asq.asq09) RETURNING g_dbs_asg03
          CALL s_get_aaz641_asg(g_dbs_asg03) RETURNING l_asq.asq00
          CALL s_aaz641_asg(tm.asa01,l_asq.asq10) RETURNING g_dbs_gl
          CALL s_get_aaz641_asg(g_dbs_gl) RETURNING l_asq.asq12
          LET l_asq.asq13 = tm.asa01
          LET l_asq.asq14 = g_asqq[j].asqq05
          LET l_asq.asq15 = g_asqq[j].asqq06
          LET l_asq.asq16 = tm.asa02
          LET l_asq.asq17 = g_asqq[j].asqq07
          LET l_asq.asqacti = g_asqq[j].asqqacti
          LET l_asq.asq18 = g_asqq[j].asqq18 #FUN-C80056 add
#TQC-C80163--mark--str--
#111101 lilingyu --begin--
#          LET l_count = 0 
#          SELECT COUNT(*) INTO l_count FROM asq_file
#           WHERE asq00 = l_asq.asq00
#             AND asq01 = l_asq.asq01
#             AND asq02 = l_asq.asq02
#             AND asq12 = l_asq.asq12
#             AND asq13 = l_asq.asq13
#             AND asq16 = l_asq.asq16
#             AND ((asq09=l_asq.asq10 AND asq10=l_asq.asq09) OR 
#                   (asq09=l_asq.asq09 AND asq10=l_asq.asq10))
#
#          IF l_count > 0 THEN 
#             CONTINUE FOR  
#          END IF            
#111101 lilingyu --end--        
#TQC-C80163--mark--end--
          INSERT INTO asq_file VALUES(l_asq.*)
          IF SQLCA.sqlcode THEN
             #CALL cl_err3("ins","asq_file",l_asq.asq09,l_asq.asq10,SQLCA.sqlcode,"","",1)
             LET g_showmsg =l_asq.asq09,"/",l_asq.asq10
             CALL s_errmsg('asq09,asq10',g_showmsg,'ins asq_file',SQLCA.sqlcode,1)
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
                       asa01      LIKE asa_file.asa01,  #族群代號
                       asa02      LIKE asa_file.asa02,  #上層公司
                       asa03      LIKE asa_file.asa03,  #帳別
                       asb04      LIKE asb_file.asb04,  #下層公司
                       asb05      LIKE asb_file.asb05   #帳別
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
   IF l_cnt = 0 THEN CALL i110_bom(tm.asa01,tm.asa02,tm.asa03) END IF

   #2-1.檢查Temptable裡有沒有chk=N的資料(表示還未抓它的下層公司),
   #    沒有的話,表示所有層級資料都產生了,離開此FUNCTION
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM i110_tmp WHERE chk='N'
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt = 0 THEN RETURN END IF

   #2-2.檢查Temptable裡有沒有chk=N的資料(表示還未抓它的下層公司),
   #    以下層公司當上層公司,去抓其下層公司,產生跨層的公司層級資料
   DECLARE asb_curs1 CURSOR FOR
      SELECT asa01,asa02,asa03,asb04,asb05
        FROM i110_tmp
       WHERE chk='N'
   FOREACH asb_curs1 INTO l_dept.*
      CALL i110_bom(l_dept.asa01,l_dept.asb04,l_dept.asb05)
      UPDATE i110_tmp SET chk='Y'
       WHERE asa01=l_dept.asa01
         AND asb04=l_dept.asb04
         AND asb05=l_dept.asb05
   END FOREACH

   CALL i110_dept()

END FUNCTION

FUNCTION i110_bom(p_asa01,p_asa02,p_asa03)
   DEFINE p_asa01   LIKE asa_file.asa01   #族群代號
   DEFINE p_asa02   LIKE asa_file.asa02   #上層公司
   DEFINE p_asa03   LIKE asa_file.asa03   #帳別
   DEFINE l_sql       STRING

   LET l_sql="INSERT INTO i110_tmp (chk,asa01,asa02,asa03,asb04,asb05)",
             "SELECT 'N',",
             "       '",tm.asa01 CLIPPED,"',",
             "       '",tm.asa02 CLIPPED,"',",
             "       '",tm.asa03 CLIPPED,"',",
             "       asb04,asb05",
             "  FROM asb_file,asa_file ",
             " WHERE asa01=asb01 AND asa02=asb02 AND asa03=asb03 ",
             "   AND asb06 = 'Y'",    #luttb 110311 add
             "   AND asa01=? AND asa02=? AND asa03=?"
   PREPARE p500_asb_p1 FROM l_sql
   EXECUTE p500_asb_p1 USING p_asa01,p_asa02,p_asa03

END FUNCTION
#NO.FUN-B40104
