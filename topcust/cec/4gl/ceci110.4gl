# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: ceci110.4gl
# Descriptions...: 工艺工时维护
# Date & Author..: 2017/04/18 By Wgh
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE 
 
    g_tcecg           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        tc_ecg01   LIKE tc_ecg_file.tc_ecg01,   #
        tc_ecg02   LIKE tc_ecg_file.tc_ecg02,   #
        tc_ecg03   LIKE tc_ecg_file.tc_ecg03,   #
        tc_ecg04   LIKE tc_ecg_file.tc_ecg04,   #
        tc_ecg05   LIKE tc_ecg_file.tc_ecg05,   #
        tc_ecg06   LIKE tc_ecg_file.tc_ecg06,   #
        tc_ecg07   LIKE tc_ecg_file.tc_ecg07
#add by jiangln 170525 start------
       ,tc_ecg08   LIKE tc_ecg_file.tc_ecg08    #资料建立日期 
       ,tc_ecg09   LIKE tc_ecg_file.tc_ecg09    #资料建立人员
       ,gen02      LIKE gen_file.gen02
       ,tc_ecg10   LIKE tc_ecg_file.tc_ecg10    #资料建立部门
       ,gem02      LIKE gem_file.gem02
#add by jiangln 170525 end------
                    END RECORD,
    g_tcecg_t         RECORD                 #程式變數 (舊值)
        tc_ecg01   LIKE tc_ecg_file.tc_ecg01,   #
        tc_ecg02   LIKE tc_ecg_file.tc_ecg02,   #
        tc_ecg03   LIKE tc_ecg_file.tc_ecg03,   #
        tc_ecg04   LIKE tc_ecg_file.tc_ecg04,   #
        tc_ecg05   LIKE tc_ecg_file.tc_ecg05,   #
        tc_ecg06   LIKE tc_ecg_file.tc_ecg06,   #
        tc_ecg07   LIKE tc_ecg_file.tc_ecg07
#add by jiangln 170525 start------
       ,tc_ecg08   LIKE tc_ecg_file.tc_ecg08    #资料建立日期 
       ,tc_ecg09   LIKE tc_ecg_file.tc_ecg09    #资料建立人员
       ,gen02      LIKE gen_file.gen02
       ,tc_ecg10   LIKE tc_ecg_file.tc_ecg10    #资料建立部门
       ,gem02      LIKE gem_file.gem02
#add by jiangln 170525 end------
                    END RECORD,

    g_wc,g_sql     STRING,  
    g_rec_b         LIKE type_file.num5,   
    l_ac            LIKE type_file.num5  
DEFINE   p_row,p_col     LIKE type_file.num5        
DEFINE   g_before_input_done  LIKE type_file.num5 
DEFINE   g_forupd_sql STRING
DEFINE   g_forupd_sql2   STRING            #add by jiangln 170525 
DEFINE   g_cnt           LIKE type_file.num10  
DEFINE   g_i             LIKE type_file.num5    
DEFINE   g_msg           LIKE ze_file.ze03      
 
MAIN
DEFINE p_cmd LIKE type_file.chr1           #add by jiangln 170525
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("CEC")) THEN
      EXIT PROGRAM
   END IF
 
      CALL cl_used(g_prog,g_time,1) RETURNING g_time

    LET p_row = 4 LET p_col = 5
 
    OPEN WINDOW i110_w AT p_row,p_col WITH FORM "cec/42f/ceci110"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_init()
#    LET g_wc = '1=1' CALL i110_b_fill(g_wc,p_cmd)   #No.TQC-6B0074    #mark by jiangln 170525
    CALL i110_menu()
    CLOSE WINDOW i110_w                 #結束畫面
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
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
         WHEN "output"  
            IF cl_chk_act_auth() THEN 
               CALL i110_out() 
            END IF
         WHEN "help"  
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg"  
            CALL cl_cmdask()
#add by jiangln 170525 start-----
         WHEN "all_delete"  
            IF cl_chk_act_auth() THEN
               CALL i110_all_delete() 
            END IF
#add by jiangln 170525 end------
#add by jiangln 170525 start-----
         WHEN "hour_query"  
            IF cl_chk_act_auth() THEN
               CALL i110_h_q() 
            END IF
#add by jiangln 170525 end------
          WHEN "related_document"  
             IF cl_chk_act_auth() AND l_ac != 0 THEN  #No.FUN-570148
               IF g_tcecg[l_ac].tc_ecg01 IS NOT NULL THEN
                  LET g_doc.column1 = "tc_ecg01"
                  LET g_doc.value1 =  g_tcecg[l_ac].tc_ecg01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tcecg),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i110_q()
   CALL i110_b_askkey()
END FUNCTION
 
FUNCTION i110_b()
DEFINE
    l_ac_t          LIKE type_file.num5,               #未取消的ARRAY CNT   #No.FUN-680136 SMALLINT 
    l_n             LIKE type_file.num5,               #檢查重複用          #No.FUN-680136 SMALLINT
    l_lock_sw       LIKE type_file.chr1,               #單身鎖住否          #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,               #處理狀態            #No.FUN-680136 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,               #可新增否            #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否            #No.FUN-680136 SMALLINT
    g_sql  STRING
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT tc_ecg01,tc_ecg02,tc_ecg03,tc_ecg04,tc_ecg05,tc_ecg06,tc_ecg07,tc_ecg08,tc_ecg09,'',tc_ecg10,'' FROM tc_ecg_file WHERE tc_ecg01=? and tc_ecg02=? and tc_ecg03=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i110_bcl CURSOR FROM g_forupd_sql 
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_tcecg WITHOUT DEFAULTS FROM s_tcecg.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
           
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3  
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
               LET p_cmd='u'
               LET g_tcecg_t.* = g_tcecg[l_ac].*  #BACKUP
#No.FUN-570109 --start--                                                                                                            
               LET  g_before_input_done = FALSE                                                                                     
               CALL i110_set_entry(p_cmd)                                                                                           
               CALL i110_set_no_entry(p_cmd)                                                                                        
               LET  g_before_input_done = TRUE                                                                                      
#No.FUN-570109 --end--     
               BEGIN WORK
               OPEN i110_bcl USING g_tcecg_t.tc_ecg01,g_tcecg_t.tc_ecg02,g_tcecg_t.tc_ecg03
               IF STATUS THEN
                  CALL cl_err("OPEN i110_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i110_bcl INTO g_tcecg[l_ac].* 
                  IF STATUS THEN
                     CALL cl_err(g_tcecg_t.tc_ecg01,STATUS,1)
                     LET l_lock_sw = "Y"
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
            INSERT INTO tc_ecg_file(tc_ecg01,tc_ecg02,tc_ecg03,tc_ecg04,tc_ecg05,tc_ecg06,tc_ecg07,tc_ecg08,tc_ecg09,tc_ecg10)  #add 08,09,10 by jiangln 170525
            VALUES(g_tcecg[l_ac].tc_ecg01,g_tcecg[l_ac].tc_ecg02,
                   g_tcecg[l_ac].tc_ecg03,g_tcecg[l_ac].tc_ecg04,
                   g_tcecg[l_ac].tc_ecg05,g_tcecg[l_ac].tc_ecg06,
                   g_tcecg[l_ac].tc_ecg07,g_tcecg[l_ac].tc_ecg08,g_tcecg[l_ac].tc_ecg09,g_tcecg[l_ac].tc_ecg10)      #No.FUN-980030 10/01/04  insert columns oriu, orig  #add 08,09,10 by jiangln 170525
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","tc_ecg_file",g_tcecg[l_ac].tc_ecg01+g_tcecg[l_ac].tc_ecg02+g_tcecg[l_ac].tc_ecg03,"",
                              SQLCA.sqlcode,"","",1)  #No.FUN-660129
                CANCEL INSERT
            ELSE
            	LET g_sql = " UPDATE ecb_file SET ecb19=(select case when substr(to_char(?,'99999999.999'),length(to_char(?,'99999999.999')),1)>0 then round(?,2)+0.01 else round(?,2) end  from dual),",
            	                                 "ecb21=(select case when substr(to_char(?,'99999999.999'),length(to_char(?,'99999999.999')),1)>0 then round(?,2)+0.01 else round(?,2) end  from dual)",
                                 " WHERE ecb01=? ",
                                 " AND ecb02=? ",
                                 " AND ecb03=? "
             
             #LET g_sql = cl_forupd_sql(g_sql)
 
             PREPARE i110_bc2 FROM g_sql 
             EXECUTE i110_bc2 USING g_tcecg[l_ac].tc_ecg06,g_tcecg[l_ac].tc_ecg06,g_tcecg[l_ac].tc_ecg06,g_tcecg[l_ac].tc_ecg06,
                                    g_tcecg[l_ac].tc_ecg07,g_tcecg[l_ac].tc_ecg07,g_tcecg[l_ac].tc_ecg07,g_tcecg[l_ac].tc_ecg07,
                                    g_tcecg[l_ac].tc_ecg01,g_tcecg[l_ac].tc_ecg02,g_tcecg[l_ac].tc_ecg03

                MESSAGE 'INSERT O.K'
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570109 --start--                                                                                                            
            LET  g_before_input_done = FALSE                                                                                        
            CALL i110_set_entry(p_cmd)                                                                                              
            CALL i110_set_no_entry(p_cmd)                                                                                           
            LET  g_before_input_done = TRUE                                                                                         
#No.FUN-570109 --end--           
            INITIALIZE g_tcecg[l_ac].* TO NULL  
            LET g_tcecg[l_ac].tc_ecg06 = 0         
            LET g_tcecg[l_ac].tc_ecg07 = 0
            LET g_tcecg[l_ac].tc_ecg08 = g_today      #add by jiangln 170525
            LET g_tcecg[l_ac].tc_ecg09 = g_user       #add by jiangln 170525
            LET g_tcecg[l_ac].tc_ecg10 = g_grup       #add by jiangln 170525     
            LET g_tcecg_t.* = g_tcecg[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD tc_ecg01

#add by jiangln 170525 start------
        BEFORE FIELD tc_ecg01
            SELECT gen02 INTO g_tcecg[l_ac].gen02 FROM gen_file WHERE gen01 = g_tcecg[l_ac].tc_ecg09
            SELECT gem02 INTO g_tcecg[l_ac].gem02 FROM gem_file WHERE gem01 = g_tcecg[l_ac].tc_ecg10
#add by jiangln 170525 end--------

        AFTER FIELD tc_ecg01                        #check 編號是否重複
            IF g_tcecg[l_ac].tc_ecg01 IS NOT NULL THEN
            IF g_tcecg[l_ac].tc_ecg01 != g_tcecg_t.tc_ecg01 OR
               (g_tcecg[l_ac].tc_ecg01 IS NOT NULL AND g_tcecg_t.tc_ecg01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM ecu_file
                    WHERE #ecu10='Y' AND 
                    ecu01 = g_tcecg[l_ac].tc_ecg01
                IF l_n = 0 THEN
                   # CALL cl_err('',-239,0)
                   CALL cl_err('','aec-200',0)
                
                    LET g_tcecg[l_ac].tc_ecg01 = g_tcecg_t.tc_ecg01
                    NEXT FIELD tc_ecg01
                END IF
            END IF
            END IF
 
        AFTER FIELD tc_ecg02   
            IF g_tcecg[l_ac].tc_ecg02 IS NOT NULL THEN
            IF g_tcecg[l_ac].tc_ecg02 != g_tcecg_t.tc_ecg02 OR
               (g_tcecg[l_ac].tc_ecg02 IS NOT NULL AND g_tcecg_t.tc_ecg02 IS NULL) THEN
                SELECT count(*) INTO l_n FROM ecu_file
                    WHERE #ecu10='Y' AND 
                    ecu01 = g_tcecg[l_ac].tc_ecg01 AND ecu02 = g_tcecg[l_ac].tc_ecg02
                IF l_n = 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_tcecg[l_ac].tc_ecg02 = g_tcecg_t.tc_ecg02
                    NEXT FIELD tc_ecg02
                END IF
            END IF
            END IF
 
        AFTER FIELD tc_ecg03
            IF g_tcecg[l_ac].tc_ecg03 IS NOT NULL THEN
            IF g_tcecg[l_ac].tc_ecg03 != g_tcecg_t.tc_ecg03 OR
               (g_tcecg[l_ac].tc_ecg03 IS NOT NULL AND g_tcecg_t.tc_ecg03 IS NULL) THEN
                SELECT count(*) INTO l_n FROM ecu_file,ecb_file
                    WHERE #ecu10='Y' AND 
                    ecu01=ecb01 AND ecu02=ecb02
                    AND ecu01 = g_tcecg[l_ac].tc_ecg01 AND ecu02 = g_tcecg[l_ac].tc_ecg02
                    AND ECB03= g_tcecg[l_ac].tc_ecg03
                IF l_n = 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_tcecg[l_ac].tc_ecg03 = g_tcecg_t.tc_ecg03
                    NEXT FIELD tc_ecg03
                END IF
            END IF
            END IF
   
        AFTER FIELD tc_ecg04
            IF g_tcecg[l_ac].tc_ecg04 IS NOT NULL THEN
            IF g_tcecg[l_ac].tc_ecg04 != g_tcecg_t.tc_ecg04 OR
               (g_tcecg[l_ac].tc_ecg04 IS NOT NULL AND g_tcecg_t.tc_ecg04 IS NULL) THEN
                SELECT count(*) INTO l_n FROM ecu_file,ecb_file
                    WHERE #ecu10='Y' AND  
                    ecu01=ecb01 AND ecu02=ecb02
                    AND ecu01 = g_tcecg[l_ac].tc_ecg01 AND ecu02 = g_tcecg[l_ac].tc_ecg02
                    AND ECB03= g_tcecg[l_ac].tc_ecg03 AND ECB06= g_tcecg[l_ac].tc_ecg04
                IF l_n = 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_tcecg[l_ac].tc_ecg04 = g_tcecg_t.tc_ecg04
                    NEXT FIELD tc_ecg04
                END IF
            END IF
            END IF

        AFTER FIELD tc_ecg05
            IF g_tcecg[l_ac].tc_ecg05 IS NOT NULL THEN
            IF g_tcecg[l_ac].tc_ecg05 != g_tcecg_t.tc_ecg05 OR
               (g_tcecg[l_ac].tc_ecg05 IS NOT NULL AND g_tcecg_t.tc_ecg05 IS NULL) THEN
                SELECT count(*) INTO l_n FROM ecu_file,ecb_file
                    WHERE #ecu10='Y' AND  
                    ecu01=ecb01 AND ecu02=ecb02
                    AND ecu01 = g_tcecg[l_ac].tc_ecg01 AND ecu02 = g_tcecg[l_ac].tc_ecg02
                    AND ECB03= g_tcecg[l_ac].tc_ecg03 AND ECB06= g_tcecg[l_ac].tc_ecg04
                    AND ECB08= g_tcecg[l_ac].tc_ecg05
                IF l_n = 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_tcecg[l_ac].tc_ecg05 = g_tcecg_t.tc_ecg05
                    NEXT FIELD tc_ecg05
                END IF
            END IF
          END IF  
 
        BEFORE DELETE                            #是否取消單身
           IF g_tcecg_t.tc_ecg01 IS NOT NULL AND g_tcecg_t.tc_ecg02 IS NOT NULL
            AND g_tcecg_t.tc_ecg03 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                INITIALIZE g_doc.* TO NULL               
                LET g_doc.column1 = "tc_ecg01"   
                LET g_doc.value1 =  g_tcecg[l_ac].tc_ecg01 
                CALL cl_del_doc() 
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
               DELETE FROM tc_ecg_file WHERE tc_ecg01 = g_tcecg_t.tc_ecg01 AND tc_ecg02 = g_tcecg_t.tc_ecg02
                    AND tc_ecg03= g_tcecg_t.tc_ecg03
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","tc_ecg_file",g_tcecg_t.tc_ecg01,"",
                                 SQLCA.sqlcode,"","",1) 
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK"
                CLOSE i110_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_tcecg[l_ac].* = g_tcecg_t.*
               CLOSE i110_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_tcecg[l_ac].tc_ecg01,-263,1)
               LET g_tcecg[l_ac].* = g_tcecg_t.*
            ELSE
               UPDATE tc_ecg_file 
                             SET tc_ecg04=g_tcecg[l_ac].tc_ecg04,
                                 tc_ecg05=g_tcecg[l_ac].tc_ecg05,
                                 tc_ecg06=g_tcecg[l_ac].tc_ecg06,
                                 tc_ecg07=g_tcecg[l_ac].tc_ecg07
                                ,tc_ecg08=g_tcecg[l_ac].tc_ecg08,    #add by jiangln 170525
                                 tc_ecg09=g_tcecg[l_ac].tc_ecg09,    #add by jiangln 170525
                                 tc_ecg10=g_tcecg[l_ac].tc_ecg10     #add by jiangln 170525
                WHERE tc_ecg01 = g_tcecg_t.tc_ecg01 AND tc_ecg02 = g_tcecg_t.tc_ecg02
                    AND tc_ecg03= g_tcecg_t.tc_ecg03
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","tc_ecg_file",g_tcecg[l_ac].tc_ecg01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                   LET g_tcecg[l_ac].* = g_tcecg_t.*
               ELSE
                   CLOSE i110_bcl
            	       LET g_sql = " UPDATE ecb_file SET ecb19=(select case when substr(to_char(?,'99999999.999'),length(to_char(?,'99999999.999')),1)>0 then round(?,2)+0.01 else round(?,2) end  from dual),",
            	                   "ecb21=(select case when substr(to_char(?,'99999999.999'),length(to_char(?,'99999999.999')),1)>0 then round(?,2)+0.01 else round(?,2) end  from dual)",
                                 " WHERE ecb01=? ",
                                 " AND ecb02=? ",
                                 " AND ecb03=? "
             #LET g_sql = cl_forupd_sql(g_sql)
 
             PREPARE i110_bc21 FROM g_sql 
             EXECUTE i110_bc21 USING g_tcecg[l_ac].tc_ecg06,g_tcecg[l_ac].tc_ecg06,g_tcecg[l_ac].tc_ecg06,g_tcecg[l_ac].tc_ecg06,
                                     g_tcecg[l_ac].tc_ecg07,g_tcecg[l_ac].tc_ecg07,g_tcecg[l_ac].tc_ecg07,g_tcecg[l_ac].tc_ecg07,
                                     g_tcecg_t.tc_ecg01,g_tcecg_t.tc_ecg02,g_tcecg_t.tc_ecg03
            	
                   MESSAGE 'UPDATE O.K'

                   COMMIT WORK
               END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN 
                  LET g_tcecg[l_ac].* = g_tcecg_t.*
               ELSE
                  CALL g_tcecg.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               END IF 
               CLOSE i110_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D30034 add
            CLOSE i110_bcl
            COMMIT WORK

#add by jiangln 170524 start-----
        ON ACTION controlp
           CASE
              WHEN INFIELD(tc_ecg01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ecu01"
                 CALL cl_create_qry() RETURNING g_tcecg[l_ac].tc_ecg01
                 DISPLAY BY NAME g_tcecg[l_ac].tc_ecg01
                 SELECT ecb02,ecb03,ecb06,ecb08,ecb19,ecb21 INTO g_tcecg[l_ac].tc_ecg02,g_tcecg[l_ac].tc_ecg03,
                   g_tcecg[l_ac].tc_ecg04,g_tcecg[l_ac].tc_ecg05,g_tcecg[l_ac].tc_ecg06,g_tcecg[l_ac].tc_ecg07
                 FROM ecb_file WHERE ecb01 = g_tcecg[l_ac].tc_ecg01
                 DISPLAY BY NAME g_tcecg[l_ac].tc_ecg02
                 DISPLAY BY NAME g_tcecg[l_ac].tc_ecg03
                 DISPLAY BY NAME g_tcecg[l_ac].tc_ecg04
                 DISPLAY BY NAME g_tcecg[l_ac].tc_ecg05
                 DISPLAY BY NAME g_tcecg[l_ac].tc_ecg06
                 DISPLAY BY NAME g_tcecg[l_ac].tc_ecg07
                 NEXT FIELD tc_ecg01

              OTHERWISE
                 EXIT CASE
           END CASE
#add by jiangln 170524 end------
 
        ON ACTION CONTROLN
            CALL i110_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(tc_ecg01) AND l_ac > 1 THEN
                LET g_tcecg[l_ac].* = g_tcecg[l_ac-1].*
                NEXT FIELD tc_ecg01
            END IF
 
        ON ACTION CONTROLR
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
 
    CLOSE i110_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i110_b_askkey()
DEFINE p_cmd LIKE type_file.chr1   #add by jiangln 170525
    LET p_cmd = 'q'
    CLEAR FORM
    CALL g_tcecg.clear()
    CALL cl_opmsg('q')
    CONSTRUCT g_wc ON tc_ecg01,tc_ecg02,tc_ecg03,tc_ecg04,tc_ecg05,tc_ecg06,tc_ecg07,tc_ecg08,tc_ecg09,tc_ecg10
            FROM s_tcecg[1].tc_ecg01,s_tcecg[1].tc_ecg02,s_tcecg[1].tc_ecg03,
                 s_tcecg[1].tc_ecg04,s_tcecg[1].tc_ecg05,s_tcecg[1].tc_ecg06,s_tcecg[1].tc_ecg07
                 ,s_tcecg[1].tc_ecg08,s_tcecg[1].tc_ecg09,s_tcecg[1].tc_ecg10    #add by jiangln 170525
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

#add by jiangln 170524 start-----
        ON ACTION controlp
           CASE
              WHEN INFIELD(tc_ecg01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ecu01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_ecg01
                 NEXT FIELD tc_ecg01

              WHEN INFIELD(tc_ecg09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_ecg09
                 NEXT FIELD tc_ecg09

              WHEN INFIELD(tc_ecg01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_ecg10
                 NEXT FIELD tc_ecg10

              OTHERWISE
                 EXIT CASE
           END CASE
#add by jiangln 170524 end------
           
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
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
    CALL i110_b_fill(g_wc,p_cmd)
END FUNCTION
 
FUNCTION i110_b_fill(p_wc2,p_cmd)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200) 
DEFINE p_cmd           LIKE type_file.chr1          #add by jiangln 170525

#modify by jiangln 170525 start--------
    IF  p_cmd = 'q' THEN
        LET g_sql =
            "SELECT tc_ecg01,tc_ecg02,tc_ecg03,tc_ecg04,tc_ecg05,tc_ecg06,tc_ecg07,tc_ecg08,tc_ecg09,'',tc_ecg10,'' ",
            " FROM tc_ecg_file",
            " WHERE ", p_wc2 CLIPPED,                     #單身
            " ORDER BY tc_ecg01,tc_ecg02,tc_ecg03"
    END IF
    IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
        LET p_wc2=cl_replace_str(p_wc2, "tc_ecg01", "ecb01") 
        LET g_sql =
            " SELECT ecb01,ecb02,ecb03,ecb06,ecb08,ecb19,ecb21,'','','','','' FROM ecb_file ",
            " WHERE ", p_wc2 CLIPPED,                     
            " ORDER BY ecb01,ecb02,ecb03" 
    END IF 
#modify by jiangln 170525 end----------    

    PREPARE i110_pb FROM g_sql
    DECLARE pma_curs CURSOR FOR i110_pb
 
    CALL g_tcecg.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH pma_curs INTO g_tcecg[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#add by jiangln 170525 start------
        SELECT tc_ecg08,tc_ecg09,tc_ecg10 INTO g_tcecg[g_cnt].tc_ecg08,g_tcecg[g_cnt].tc_ecg09,g_tcecg[g_cnt].tc_ecg10 
          FROM tc_ecg_file 
         WHERE tc_ecg01 = g_tcecg[g_cnt].tc_ecg01 AND tc_ecg02 = g_tcecg[g_cnt].tc_ecg02 
           AND tc_ecg03 = g_tcecg[g_cnt].tc_ecg03 AND tc_ecg04 = g_tcecg[g_cnt].tc_ecg04
           AND tc_ecg05 = g_tcecg[g_cnt].tc_ecg05
        SELECT gen02 INTO g_tcecg[g_cnt].gen02
          FROM gen_file
         WHERE gen01 = g_tcecg[g_cnt].tc_ecg09 
        SELECT gem02 INTO g_tcecg[g_cnt].gem02
          FROM gem_file
         WHERE gem01 = g_tcecg[g_cnt].tc_ecg10          
#add by jiangln 170525 end--------
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_tcecg.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
    DISPLAY g_cnt   TO FORMONLY.cn3  
END FUNCTION
 
FUNCTION i110_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tcecg TO s_tcecg.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
 
    ON ACTION related_document  
      LET g_action_choice="related_document"
      EXIT DISPLAY
      
#add by jiangln 170525 start----
    ON ACTION all_delete
      LET g_action_choice="all_delete"
      EXIT DISPLAY
#add by jiangln 170525 end------

#add by jiangln 170525 start----
    ON ACTION hour_query
      LET g_action_choice="hour_query"
      EXIT DISPLAY
#add by jiangln 170525 end------

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
 
FUNCTION i110_out()
   DEFINE
       l_i             LIKE type_file.num5, 
       l_name          LIKE type_file.chr20, 
       l_tcecg           RECORD  
           tc_ecg01   LIKE tc_ecg_file.tc_ecg01,   
           tc_ecg02   LIKE tc_ecg_file.tc_ecg02,   
           tc_ecg03   LIKE tc_ecg_file.tc_ecg03,   
           tc_ecg04   LIKE tc_ecg_file.tc_ecg04,   
           tc_ecg05   LIKE tc_ecg_file.tc_ecg05,   
           tc_ecg06   LIKE tc_ecg_file.tc_ecg06,   
           tc_ecg07   LIKE tc_ecg_file.tc_ecg07
                       END RECORD,
       l_za05          LIKE type_file.chr1000,     
       l_chr           LIKE type_file.chr1     
 
DEFINE l_cmd           LIKE type_file.chr1000   

  IF cl_null(g_wc) THEN
     CALL cl_err("","9057",0)
     RETURN
  END IF
                                                                                                            
  LET l_cmd = 'p_query "ceci110" "',g_wc CLIPPED,'"'                                                                                
  CALL cl_cmdrun(l_cmd)                                                                                                             
  RETURN

END FUNCTION
 
FUNCTION i110_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1
 
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("tc_ecg01,tc_ecg02,tc_ecg03",TRUE)                                                                                           
  END IF                                                                                                                            
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i110_set_no_entry(p_cmd)                                                                                                   
  DEFINE p_cmd   LIKE type_file.chr1
 
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                               
     CALL cl_set_comp_entry("tc_ecg01,tc_ecg02,tc_ecg03",FALSE)                                                                                          
  END IF                                                                                                                            
END FUNCTION

#add by jiangln 170525 start----增加批量删除功能
FUNCTION i110_all_delete()
    DEFINE tc_ecg01_1 LIKE tc_ecg_file.tc_ecg01
    DEFINE tc_ecg08_1 LIKE tc_ecg_file.tc_ecg08
    DEFINE l_cnt      LIKE type_file.num5
    DEFINE p_cmd      LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   
   OPEN WINDOW i110_a_w AT 06,15 WITH FORM "cec/42f/ceci110_a"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 

   CALL cl_ui_locale("ceci110_a")

   LET tc_ecg01_1 = NULL    
   LET tc_ecg08_1 = NULL      
   
   LET g_before_input_done = FALSE   
   CALL i110_set_entry('a')         
   LET g_before_input_done = TRUE    
   CALL cl_set_head_visible("","YES") 
   
   INPUT BY NAME  tc_ecg01_1,tc_ecg08_1  
               WITHOUT DEFAULTS
               
      AFTER FIELD tc_ecg01_1
        IF tc_ecg01_1 IS NULL THEN NEXT FIELD tc_ecg01_1 END IF
        IF NOT cl_null(tc_ecg01_1) THEN
            LET l_cnt = 0
            SELECT count(*) INTO l_cnt FROM tc_ecg_file
             WHERE tc_ecg01 = tc_ecg01_1
            IF l_cnt=0 THEN
                CALL cl_err('','cec-028',1)
                NEXT FIELD tc_ecg08_1 
            END IF 
        END IF
        
      AFTER FIELD tc_ecg08_1
        IF tc_ecg08_1 IS NULL THEN NEXT FIELD tc_ecg08_1 END IF

        IF NOT cl_null(tc_ecg08_1) THEN
           LET l_cnt =0
           SELECT COUNT(*) INTO l_cnt FROM tc_ecg_file
              WHERE tc_ecg01 = tc_ecg01_1 AND tc_ecg08 = tc_ecg08_1
           IF l_cnt =0 THEN
              CALL cl_err('','cec-028',1)
              NEXT FIELD tc_ecg08_1
           END IF
        END IF

       AFTER INPUT
          IF INT_FLAG THEN EXIT INPUT END IF
          IF tc_ecg01_1 IS NULL THEN NEXT FIELD tc_ecg01_1 END IF
          IF cl_null(tc_ecg08_1) THEN NEXT FIELD tc_ecg08_1 END IF
          SELECT COUNT(*) INTO l_cnt FROM tc_ecg_file
           WHERE tc_ecg01 = tc_ecg01_1
             AND tc_ecg08 = tc_ecg08_1
          IF l_cnt=0 THEN
             CALL cl_err('','cec-028',1)
             NEXT FIELD tc_ecg08_1
          END IF

        ON ACTION controlp
           CASE
              WHEN INFIELD(tc_ecg01_1)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "cq_tc_ecg01"
                   LET g_qryparam.default1 = tc_ecg01_1
                   CALL cl_create_qry() RETURNING tc_ecg01_1
                   DISPLAY BY NAME tc_ecg01_1
                   NEXT FIELD tc_ecg01_1
              OTHERWISE EXIT CASE
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
   CLOSE WINDOW i110_a_w

   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF

#add by jiangln 170525 start-----
    LET g_forupd_sql2 = "SELECT tc_ecg01,tc_ecg02,tc_ecg03,tc_ecg04,tc_ecg05,tc_ecg06,tc_ecg07 FROM tc_ecg_file WHERE tc_ecg01=? and tc_ecg08=? FOR UPDATE"
 
    LET g_forupd_sql2 = cl_forupd_sql(g_forupd_sql2)
    DECLARE i110_a_bcl CURSOR FROM g_forupd_sql2 
#add by jiangln 170525 end-------

   BEGIN WORK

   OPEN i110_a_bcl USING tc_ecg01_1,tc_ecg08_1
   IF STATUS THEN
      CALL cl_err("OPEN i110_a_bcl:", STATUS, 1)
      ROLLBACK WORK
      RETURN
   END IF

   DELETE FROM tc_ecg_file WHERE tc_ecg01 = tc_ecg01_1 AND tc_ecg08 = tc_ecg08_1
    IF SQLCA.sqlcode THEN
       CALL cl_err3("del","tc_ecg_file",g_tcecg_t.tc_ecg01,"",SQLCA.sqlcode,"","",1) 
       ROLLBACK WORK
    ELSE
       CLOSE i110_a_bcl    
       COMMIT WORK
    END IF   
    LET p_cmd = 'u' 
    CALL i110_b_fill(g_wc,p_cmd)    
END FUNCTION

FUNCTION i110_h_q() 

    CALL i110_b_askkey_h()

END FUNCTION 

FUNCTION i110_b_askkey_h()
DEFINE p_cmd LIKE type_file.chr1   #add by jiangln 170525
    LET p_cmd = 'u'
    CLEAR FORM
    CALL g_tcecg.clear()
    CALL cl_opmsg('q')
    CONSTRUCT g_wc ON tc_ecg01,tc_ecg02,tc_ecg03,tc_ecg04,tc_ecg05,tc_ecg06,tc_ecg07,tc_ecg08,tc_ecg09,tc_ecg10
            FROM s_tcecg[1].tc_ecg01,s_tcecg[1].tc_ecg02,s_tcecg[1].tc_ecg03,
                 s_tcecg[1].tc_ecg04,s_tcecg[1].tc_ecg05,s_tcecg[1].tc_ecg06,s_tcecg[1].tc_ecg07
                 ,s_tcecg[1].tc_ecg08,s_tcecg[1].tc_ecg09,s_tcecg[1].tc_ecg10    #add by jiangln 170525
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

#add by jiangln 170524 start-----
        ON ACTION controlp
           CASE
              WHEN INFIELD(tc_ecg01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ecu01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_ecg01
                 NEXT FIELD tc_ecg01

              WHEN INFIELD(tc_ecg09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_ecg09
                 NEXT FIELD tc_ecg09

              WHEN INFIELD(tc_ecg01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_ecg10
                 NEXT FIELD tc_ecg10

              OTHERWISE
                 EXIT CASE
           END CASE
#add by jiangln 170524 end------
           
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
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
    CALL i110_b_fill_h(g_wc,p_cmd)
END FUNCTION
 
FUNCTION i110_b_fill_h(p_wc2,p_cmd)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200) 
DEFINE p_cmd           LIKE type_file.chr1          #add by jiangln 170525
DEFINE l_cnt           LIKE type_file.num5          #add by jiangln 170525

#modify by jiangln 170525 start--------
    IF  p_cmd = 'q' THEN
        LET g_sql =
            "SELECT tc_ecg01,tc_ecg02,tc_ecg03,tc_ecg04,tc_ecg05,tc_ecg06,tc_ecg07,tc_ecg08,tc_ecg09,'',tc_ecg10,'' ",
            " FROM tc_ecg_file",
            " WHERE ", p_wc2 CLIPPED,                     #單身
            " ORDER BY tc_ecg01,tc_ecg02,tc_ecg03"
    END IF
    IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
        LET p_wc2=cl_replace_str(p_wc2, "tc_ecg01", "ecb01") 
        LET g_sql =
            " SELECT ecb01,ecb02,ecb03,ecb06,ecb08,ecb19,ecb21,'','','','',''  FROM ecb_file ",
            " WHERE ", p_wc2 CLIPPED,                     
            " ORDER BY ecb01,ecb02,ecb03" 
    END IF 
#modify by jiangln 170525 end----------    

    PREPARE i110_pb_h FROM g_sql
    DECLARE pma_h_curs CURSOR FOR i110_pb_h
 
    CALL g_tcecg.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH pma_h_curs INTO g_tcecg[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#add by jiangln 170525 start------
        SELECT tc_ecg08,tc_ecg09,tc_ecg10 INTO g_tcecg[g_cnt].tc_ecg08,g_tcecg[g_cnt].tc_ecg09,g_tcecg[g_cnt].tc_ecg10 
          FROM tc_ecg_file 
         WHERE tc_ecg01 = g_tcecg[g_cnt].tc_ecg01 AND tc_ecg02 = g_tcecg[g_cnt].tc_ecg02 
           AND tc_ecg03 = g_tcecg[g_cnt].tc_ecg03 AND tc_ecg04 = g_tcecg[g_cnt].tc_ecg04
           AND tc_ecg05 = g_tcecg[g_cnt].tc_ecg05 
        SELECT gen02 INTO g_tcecg[g_cnt].gen02
          FROM gen_file
         WHERE gen01 = g_tcecg[g_cnt].tc_ecg09 
        SELECT gem02 INTO g_tcecg[g_cnt].gem02
          FROM gem_file
         WHERE gem01 = g_tcecg[g_cnt].tc_ecg10          
#add by jiangln 170525 end--------
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt FROM tc_ecg_file WHERE tc_ecg01 = g_tcecg[g_cnt].tc_ecg01 AND tc_ecg02 = g_tcecg[g_cnt].tc_ecg02
         AND tc_ecg03 = g_tcecg[g_cnt].tc_ecg03 AND tc_ecg04 = g_tcecg[g_cnt].tc_ecg04 AND tc_ecg05 = g_tcecg[g_cnt].tc_ecg05
       IF l_cnt = 0 THEN
            IF cl_null(g_tcecg[g_cnt].tc_ecg08) THEN 
                LET g_tcecg[g_cnt].tc_ecg08 = g_today 
            END IF
            IF cl_null(g_tcecg[g_cnt].tc_ecg09) THEN 
                LET g_tcecg[g_cnt].tc_ecg09 = g_user 
            END IF
            IF cl_null(g_tcecg[g_cnt].tc_ecg10) THEN 
                LET g_tcecg[g_cnt].tc_ecg10 = g_grup 
            END IF
        SELECT gen02 INTO g_tcecg[g_cnt].gen02
          FROM gen_file
         WHERE gen01 = g_tcecg[g_cnt].tc_ecg09 
        SELECT gem02 INTO g_tcecg[g_cnt].gem02
          FROM gem_file
         WHERE gem01 = g_tcecg[g_cnt].tc_ecg10
            INSERT INTO tc_ecg_file(tc_ecg01,tc_ecg02,tc_ecg03,tc_ecg04,tc_ecg05,tc_ecg06,tc_ecg07,tc_ecg08,tc_ecg09,tc_ecg10)  #add 08,09,10 by jiangln 170525
            VALUES(g_tcecg[g_cnt].tc_ecg01,g_tcecg[g_cnt].tc_ecg02,
                   g_tcecg[g_cnt].tc_ecg03,g_tcecg[g_cnt].tc_ecg04,
                   g_tcecg[g_cnt].tc_ecg05,g_tcecg[g_cnt].tc_ecg06,
                   g_tcecg[g_cnt].tc_ecg07,g_tcecg[g_cnt].tc_ecg08,g_tcecg[g_cnt].tc_ecg09,g_tcecg[g_cnt].tc_ecg10)   
       END IF   
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_tcecg.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
    DISPLAY g_cnt   TO FORMONLY.cn3  
END FUNCTION

#add by jiangln 170525 end------