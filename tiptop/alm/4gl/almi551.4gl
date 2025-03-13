# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: almi551.4gl
# Descriptions...: 卡、券生效范围作业
# Date & Author..: NO:FUN-960058 09/06/12 By  destiny  
# Modify.........: No:FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No:FUN-A20034 10/02/08 By shiwuying 增加促銷生效範圍
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A40015 10/04/06 By shiwuying 門店改抓azw01,lma02->azp02
# Modify.........: No:FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore
# Modify.........: No:FUN-A60010 10/07/14 By huangtao 小类代号用產品分類代替,刪除大類和中類
# Modify.........: NO:FUN-A80148 10/09/01 By wangxin 因為lma_file已不使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: NO:FUN-B30174 11/03/23 By huangtao 門店開窗複選
# Modify.........: NO:TQC-B60209 11/06/20 By baogc MARK掉查詢功能
# Modify.........: NO:TQC-C80090 12/08/15 By yangxf 摊位编号背景为黄色，如果为空可以确定
# Modify.........: No:FUN-D30033 13/04/09 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-960058--begin 
DEFINE 
     g_lnk           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        lnk03       LIKE lnk_file.lnk03,  
        azp02       LIKE azp_file.azp02,    
        lnk04       LIKE lnk_file.lnk04,   
#        lmk04       LIKE lmk_file.lmk04,             #FUN-A60010
#        lmi02       LIKE lmi_file.lmi02,             #FUN-A60010
#        lmk03       LIKE lmk_file.lmk03,             #FUN-A60010
#        lmj02       LIKE lmj_file.lmj02,            #FUN-A60010
#        lmk01       LIKE lmk_file.lmk01,            #FUN-A60010
#        lmk02       LIKE lmk_file.lmk02,            #FUN-A60010
        oba01       LIKE  oba_file.oba01,          #FUN-A60010 add
        oba02       LIKE  oba_file.oba02,           #FUN-A60010 add
        lnk05       LIKE lnk_file.lnk05
                    END RECORD,
     g_lnk_t         RECORD                #程式變數 (舊值)
        lnk03       LIKE lnk_file.lnk03,  
        azp02       LIKE azp_file.azp02,    
        lnk04       LIKE lnk_file.lnk04,   
#        lmk04       LIKE lmk_file.lmk04,             #FUN-A60010
#        lmi02       LIKE lmi_file.lmi02,             #FUN-A60010
#        lmk03       LIKE lmk_file.lmk03,             #FUN-A60010
#        lmj02       LIKE lmj_file.lmj02,            #FUN-A60010
#        lmk01       LIKE lmk_file.lmk01,            #FUN-A60010
#        lmk02       LIKE lmk_file.lmk02,            #FUN-A60010
        oba01       LIKE  oba_file.oba01,          #FUN-A60010 add
        oba02       LIKE  oba_file.oba02,           #FUN-A60010 add
        lnk05       LIKE lnk_file.lnk05
                    END RECORD,
    g_wc2,g_sql     LIKE type_file.chr1000,         
    g_rec_b         LIKE type_file.num5,                #單身筆數     
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL       
DEFINE g_argv1      LIKE lnk_file.lnk01
DEFINE g_argv2      LIKE lnk_file.lnk02
DEFINE g_cnt        LIKE type_file.num10    
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose        
DEFINE g_before_input_done   LIKE type_file.num5        
 
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   LET g_argv1=ARG_VAL(1)                
   LET g_argv2=ARG_VAL(2)               
    
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    
 
    OPEN WINDOW i551_w WITH FORM "alm/42f/almi551"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
    IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN 
       LET g_wc2 = '1=1' 
       CALL i551_b_fill(g_wc2)
    END IF 
    CALL i551_menu()
    CLOSE WINDOW i551_w                    #結束畫面
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION i551_menu()
 DEFINE l_cmd   LIKE type_file.chr1000 
                                
   WHILE TRUE
      CALL i551_bp("G")
      CASE g_action_choice
#TQC-B60209 - MARK - BEGIN ----------------------
#        WHEN "query"  
#           IF cl_chk_act_auth() THEN
#              CALL i551_q()
#           END IF
#TQC-B60209 - MARK -  END  ----------------------
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i551_b()  
            END IF
#         WHEN "output"
#            IF cl_chk_act_auth() THEN
#               CALL i551_out()                                        
#            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"  
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_lnk[l_ac].lnk03 IS NOT NULL THEN
                  LET g_doc.column1 = "lnk03"
                  LET g_doc.value1 = g_lnk[l_ac].lnk03
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lnk),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i551_q()
   CALL i551_b_askkey()
END FUNCTION
 
FUNCTION i551_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        
   l_n             LIKE type_file.num5,                #檢查重複用       
   l_n1            LIKE type_file.num5,
   l_n2            LIKE type_file.num5,
   l_n3            LIKE type_file.num5,
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否       
   p_cmd           LIKE type_file.chr1,                #處理狀態        
   l_allow_insert  LIKE type_file.chr1,                #可新增否
   l_allow_delete  LIKE type_file.chr1,                #可刪除否
#   l_lmk05         LIKE lmk_file.lmk05,             #FUN-A60010
   l_obaacti       LIKE oba_file.obaacti,            #FUN-A60010 add
   l_lnk02         LIKE lnk_file.lnk02,
   l_count         LIKE type_file.num5,
   l_cot           LIKE type_file.num5,
   l_lph24         LIKE lph_file.lph24,
   l_lpx15         LIKE lpx_file.lpx15,
   l_azp02         LIKE azp_file.azp02
 DEFINE l_lqg07    LIKE lqg_file.lqg07  #No.FUN-A20034
#FUN-B30174 --------------STA
DEFINE tok         base.StringTokenizer
DEFINE l_plant     LIKE azw_file.azw01
DEFINE l_flag      LIKE type_file.chr1

   LET l_flag = 'N'
#FUN-B30174 --------------END    
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
   IF cl_null(g_argv1) OR cl_null(g_argv2) THEN 
      CALL cl_err('','alm-836',1)
      RETURN 
   END IF 
   IF g_argv2='1' THEN 
      SELECT lph24 INTO l_lph24 FROM lph_file WHERE lph01=g_argv1
      IF l_lph24 ='Y' THEN 
         CALL cl_err(g_argv1,'abm-879',1)
         RETURN 
      END IF 
   ELSE 
     IF g_argv2='2' THEN #No.FUN-A20034
      SELECT lpx15 INTO l_lpx15 FROM lpx_file WHERE lpx01=g_argv1
      IF l_lpx15 ='Y' THEN 
         CALL cl_err(g_argv1,'abm-879',1)
         RETURN 
      END IF
    #No.FUN-A20034 -BEGIN-----
     ELSE
        SELECT lqg07 INTO l_lqg07
          FROM lqg_file
         WHERE lqg01 = g_argv1
        IF l_lqg07 = 'Y' THEN
           CALL cl_err(g_argv1,'abm-879',1)
           RETURN
        END IF
     END IF
    #No.FUN-A20034 -END-------
   END IF    
  # SELECT COUNT(*) INTO l_count FROM lma_file
  #  WHERE lma01 = g_plant
  #    AND rtz28 = 'Y'
  #  IF l_count < 1 THEN 
  #     CALL cl_err('','alm-606',1)
  #     RETURN 
  #  END IF
    
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT lnk03,'',lnk04,'','',lnk05 ",  #FUN-A60010 
                      "  FROM lnk_file WHERE lnk01='",g_argv1,"' AND lnk02='",g_argv2,"' ",
                      "  AND lnk03= ? AND lnk04= ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i551_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_lnk WITHOUT DEFAULTS FROM s_lnk.*
     ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
 
          IF g_rec_b>=l_ac THEN 
             BEGIN WORK
             LET p_cmd='u'                                                
             LET g_before_input_done = FALSE                                    
             LET g_before_input_done = TRUE                                             
             LET g_lnk_t.* = g_lnk[l_ac].*  #BACKUP
             OPEN i551_bcl USING g_lnk_t.lnk03,g_lnk_t.lnk04
             IF STATUS THEN
                CALL cl_err("OPEN i551_bcl:",STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i551_bcl INTO g_lnk[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_lnk_t.lnk03,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                ELSE
                   CALL i551_lnk04('d')
                   CALL i551_lnk03('d')
                END IF
             END IF
             CALL cl_show_fld_cont()     
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                              
          LET g_before_input_done = FALSE                                       
          LET g_before_input_done = TRUE                                        
          INITIALIZE g_lnk[l_ac].* TO NULL   
          LET g_lnk[l_ac].lnk05 = 'Y'  
          LET g_lnk_t.* = g_lnk[l_ac].*         #新輸入資料
          LET g_lnk[l_ac].lnk04 = ' '           #TQC-C80090 add
          CALL cl_show_fld_cont()    
          NEXT FIELD lnk03
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i551_bcl
             CANCEL INSERT
          END IF
          INSERT INTO lnk_file(lnk01,lnk02,lnk03,lnk04,lnk05)   
          VALUES(g_argv1,g_argv2,g_lnk[l_ac].lnk03,g_lnk[l_ac].lnk04,g_lnk[l_ac].lnk05)  
          IF SQLCA.sqlcode THEN   
             CALL cl_err3("ins","lnk_file",g_lnk[l_ac].lnk03,"",SQLCA.sqlcode,"","",1)  
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
              
            
       AFTER FIELD lnk03                        #check 門店加攤位是否重複
          IF NOT cl_null(g_lnk[l_ac].lnk03) THEN 
             IF g_lnk[l_ac].lnk03 != g_lnk_t.lnk03 OR
                g_lnk_t.lnk03 IS NULL THEN
                #IF g_lnk[l_ac].lnk04 IS NOT NULL THEN 
                #   SELECT count(*) INTO l_n FROM lnk_file
                #    WHERE lnk03 = g_lnk[l_ac].lnk03    
                #      AND lnk04 = g_lnk[l_ac].lnk04 
                #    IF l_n>0 THEN 
                #       CALL cl_err('','alm-835',1)  
                #       LET g_lnk[l_ac].lnk03 = g_lnk_t.lnk03                                                                             
                #       NEXT FIELD lnk03   
                #   END IF 
                #   SELECT COUNT(*) INTO l_n3 FROM lml_file
                #    WHERE lml01=g_lnk[l_ac].lnk04
                #      AND lmlstore=g_lnk[l_ac].lnk03
                #   IF l_n3=0 THEN 
                #      CALL cl_err('','alm-837',1)
                #      LET g_lnk[l_ac].lnk03 = g_lnk_t.lnk03                                                                             
                #      NEXT FIELD lnk03   
                #   END IF 
                #END IF   
                CALL i551_check()
                IF NOT cl_null(g_errno) THEN 
                  CALL cl_err('',g_errno,1)
                  LET g_lnk[l_ac].lnk03 = g_lnk_t.lnk03
                  NEXT FIELD lnk03
                END IF                            
                CALL i551_lnk03('a') 
                IF NOT cl_null(g_errno) THEN 
                  CALL cl_err('',g_errno,1)
                  LET g_lnk[l_ac].lnk03 = g_lnk_t.lnk03
                  NEXT FIELD lnk03
                END IF                                                                                          
             END IF      
          ELSE 
             LET g_lnk[l_ac].azp02=''
             DISPLAY '' TO g_lnk[l_ac].azp02
          END IF
           
        AFTER FIELD lnk04
           #IF g_lnk[l_ac].lnk04 IS NOT NULL THEN           #TQC-C80090 MARK                
           IF NOT cl_null(g_lnk[l_ac].lnk04) THEN           #TQC-C80090 add 
              IF g_lnk[l_ac].lnk04 != g_lnk_t.lnk04 OR
                 g_lnk_t.lnk04 IS NULL THEN
                 IF NOT cl_null(g_lnk[l_ac].lnk03) THEN           #門店不為空時，檢查此攤位是否在門店下存在
                    #SELECT count(*) INTO l_n1 FROM lnk_file
                    # WHERE lnk03 = g_lnk[l_ac].lnk03    
                    #   AND lnk04 = g_lnk[l_ac].lnk04 
                    # IF l_n1>0 THEN 
                    #    CALL cl_err('','alm-835',1)       
                    #    LET g_lnk[l_ac].lnk04 = g_lnk_t.lnk04                                                                        
                    #    NEXT FIELD lnk04   
                    # END IF 
                    # SELECT COUNT(*) INTO l_n2 FROM lml_file
                    #  WHERE lml01=g_lnk[l_ac].lnk04
                    #    AND lmlstore=g_lnk[l_ac].lnk03     
                    # IF l_n2=0 THEN 
                    #    CALL cl_err('','alm-837',1)
                    #    LET g_lnk[l_ac].lnk04 = g_lnk_t.lnk04
                    #    NEXT FIELD lnk04
                    #END IF     
                    CALL i551_check()
                    IF NOT cl_null(g_errno) THEN 
                       CALL cl_err('',g_errno,1)
                       LET g_lnk[l_ac].lnk04 = g_lnk_t.lnk04
                       NEXT FIELD lnk04
                    END IF                
                 ELSE                            #門店為空時，從小類與攤位關係檔中帶出門店     
                   #No.FUN-A40015 -BEGIN-----
                   #SELECT lma02,lmlstore INTO g_lnk[l_ac].lma02,g_lnk[l_ac].lnk03 
                   #  FROM lml_file,lma_file
                   # WHERE lml01=g_lnk[l_ac].lnk04 AND lma01=lmlstore 
                    SELECT lmlstore INTO g_lnk[l_ac].lnk03 FROM lml_file
                     WHERE lml01=g_lnk[l_ac].lnk04
                   #No.FUN-A40015 -END-------
                    IF SQLCA.sqlcode=100 THEN 
                       CALL cl_err('','alm-837',1) 
                       LET g_lnk[l_ac].lnk04 = g_lnk_t.lnk04
                       LET g_lnk[l_ac].lnk03 = g_lnk_t.lnk03
                       NEXT FIELD lnk04
                    END IF 
                    SELECT count(*) INTO l_n FROM lnk_file
                     WHERE lnk01=g_argv1 AND lnk02=g_argv2 
                       AND lnk03 = g_lnk[l_ac].lnk03    
                       AND lnk04 = g_lnk[l_ac].lnk04 
                     IF l_n>0 THEN            
                        CALL cl_err('','alm-835',1)
                        LET g_lnk[l_ac].lnk04 = g_lnk_t.lnk04
                        LET g_lnk[l_ac].lnk03 = g_lnk_t.lnk03    
                        LET g_lnk[l_ac].azp02 = g_lnk_t.azp02
                        NEXT FIELD lnk04
                     END IF
                    #No.FUN-A40015 -BEGIN-----
                     SELECT azp02 INTO g_lnk[l_ac].azp02 FROM azp_file
                      WHERE azp01 = g_lnk[l_ac].lnk03
                    #No.FUN-A40015 -END-------
                     DISPLAY BY NAME g_lnk[l_ac].lnk03
                     DISPLAY BY NAME g_lnk[l_ac].azp02
                 END IF
                 CALL i551_lnk04('a')
                 IF NOT cl_null(g_errno) THEN 
                   CALL cl_err('',g_errno,1)
                   LET g_lnk[l_ac].lnk04 = g_lnk_t.lnk04
                   NEXT FIELD lnk04
                 END IF   
              END IF      
           ELSE 
              LET g_lnk[l_ac].lnk04=' '
              IF p_cmd = 'a' OR (p_cmd = 'u' AND (g_lnk[l_ac].lnk04 != g_lnk_t.lnk04)) THEN  #TQC-C80090 add
#FUN-A60010--------------------mark---------------              
#              DISPLAY '' TO g_lnk[l_ac].lmk01
#       	   DISPLAY '' TO g_lnk[l_ac].lmk02
#       	   DISPLAY '' TO g_lnk[l_ac].lmk03 
#              DISPLAY '' TO g_lnk[l_ac].lmk04
#              DISPLAY '' TO g_lnk[l_ac].lmi02
#              DISPLAY '' TO g_lnk[l_ac].lmj02 
#FUN-A60010---------mark-------------------------
#FUN-A60010 add ---------------start------------------
               # DISPLAY '' TO g_lnk[l_ac].oba01   #TQC-C80090 mark
               # DISPLAY '' TO g_lnk[l_ac].oba02   #TQC-C80090 mark
                 DISPLAY '' TO oba01               #TQC-C80090 add
                 DISPLAY '' TO oba02               #TQC-C80090 add
#FUN-A60010 add  ------------end--------------------
                 CALL i551_check() 
                 IF NOT cl_null(g_errno) THEN 
                   CALL cl_err('',g_errno,1)
                   LET g_lnk[l_ac].lnk04 = g_lnk_t.lnk04
                   NEXT FIELD lnk04
                 END IF   
              END IF                               #TQC-C80090 add
           END IF  
          
       AFTER FIELD lnk05
          IF NOT cl_null(g_lnk[l_ac].lnk05) THEN
             IF g_lnk[l_ac].lnk05 NOT MATCHES '[YN]' THEN 
                LET g_lnk[l_ac].lnk05 = g_lnk_t.lnk05
                NEXT FIELD lnk05
             END IF
          END IF
          
       BEFORE DELETE                            #是否取消單身
          IF g_lnk_t.lnk03 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "lnk03"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_lnk[l_ac].lnk03      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM lnk_file WHERE lnk03 = g_lnk_t.lnk03 AND lnk04=g_lnk_t.lnk04 
                                    AND lnk01 = g_argv1 AND lnk02 = g_argv2
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","lnk_file",g_lnk_t.lnk03,"",SQLCA.sqlcode,"","",1)  
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_lnk[l_ac].* = g_lnk_t.*
             CLOSE i551_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_lnk[l_ac].lnk03,-263,0)
             LET g_lnk[l_ac].* = g_lnk_t.*
          ELSE
          	 #IF
             #SELECT count(*) INTO l_cot FROM lnk_file
             # WHERE lnk03 = g_lnk[l_ac].lnk03    
             #   AND lnk04 = g_lnk[l_ac].lnk04 
             #IF l_cot>0 THEN 
             #    CALL cl_err('','alm-835',1)                                                                              
             #    NEXT FIELD lnk03   
             #END IF              
             UPDATE lnk_file SET lnk03=g_lnk[l_ac].lnk03,
                                 lnk04=g_lnk[l_ac].lnk04,
                                 lnk05=g_lnk[l_ac].lnk05
              WHERE lnk03 = g_lnk_t.lnk03 
                AND lnk04 = g_lnk_t.lnk04
                AND lnk01 = g_argv1
                AND lnk02 = g_argv2
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","lnk_file",g_lnk_t.lnk03,"",SQLCA.sqlcode,"","",1) 
                LET g_lnk[l_ac].* = g_lnk_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()            # 新增
         #LET l_ac_t = l_ac                # 新增  #FUN-D30033 Mark
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_lnk[l_ac].* = g_lnk_t.*
             #FUN-D30033--add--str--
             ELSE
                CALL g_lnk.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30033--add--end--
             END IF
             CLOSE i551_bcl            # 新增
             ROLLBACK WORK             # 新增
             EXIT INPUT
          END IF
 
          LET l_ac_t = l_ac            #FUN-D30033 Add    
          CLOSE i551_bcl               # 新增
          COMMIT WORK
          
       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(lnk03)
#FUN-B30174 -------------STA
#                CALL cl_init_qry_var()
#                LET g_qryparam.form ="q_azw"  #No.FUN-A40015
#                LET g_qryparam.default1 = g_lnk[l_ac].lnk03
#                CALL cl_create_qry() RETURNING g_lnk[l_ac].lnk03
#                DISPLAY BY NAME g_lnk[l_ac].lnk03
#                NEXT FIELD lnk03
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azw"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 LET tok = base.StringTokenizer.createExt(g_qryparam.multiret,"|",'',TRUE)
                 WHILE tok.hasMoreTokens() 
                    LET l_plant = tok.nextToken()
                    IF cl_null(l_plant) THEN
                       CONTINUE WHILE
                    ELSE
                      SELECT COUNT(*) INTO l_count  FROM lnk_file
                       WHERE lnk01 = g_argv1 AND lnk02 = g_argv2
                        AND lnk03 = l_plant AND lnk04 = ' '
                      IF l_count > 0 THEN
                         CONTINUE WHILE
                      END IF
                    END IF
                    INSERT INTO lnk_file VALUES (g_argv1,g_argv2,l_plant,' ','Y')                    
                 END WHILE
                 LET l_flag = 'Y'
                 EXIT INPUT
#FUN-B30174 -------------END 
                    
              WHEN INFIELD(lnk04)
                 CALL cl_init_qry_var()
                 IF NOT cl_null(g_lnk[l_ac].lnk03) THEN 
                    LET g_qryparam.form ="q_lml1"
                    LET g_qryparam.arg1 =g_lnk[l_ac].lnk03
                 ELSE
                     LET g_qryparam.form ="q_lml"
                 END IF 
                 LET g_qryparam.default1 = g_lnk[l_ac].lnk04
                 CALL cl_create_qry() RETURNING g_lnk[l_ac].lnk04
                 DISPLAY BY NAME g_lnk[l_ac].lnk04
                 NEXT FIELD lnk04   
           END CASE
           
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(lnk03) AND l_ac > 1 THEN
             LET g_lnk[l_ac].* = g_lnk[l_ac-1].*
             NEXT FIELD lnk03
          END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
          
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
       
   END INPUT
#FUN-B30174 -----------STA
   IF l_flag = 'Y' THEN
       CALL i551_b_fill(" 1=1")
       CALL i551_b()
   END IF
#FUN-B30174 -----------END
   CLOSE i551_bcl
   COMMIT WORK
 
END FUNCTION

FUNCTION i551_b_askkey()
 
   CLEAR FORM
   CALL g_lnk.clear()
   LET l_ac =1
   CONSTRUCT g_wc2 ON lnk03,lnk04,lnk05
        FROM s_lnk[1].lnk03,s_lnk[1].lnk04,s_lnk[1].lnk05
 
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
         
      ON ACTION CONTROLP
          CASE
            WHEN INFIELD(lnk03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lnk03"
                 LET g_qryparam.arg1=g_argv1
                 LET g_qryparam.arg2=g_argv2
                 LET g_qryparam.state='c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lnk03
                 NEXT FIELD lnk03
                                              
            WHEN INFIELD(lnk04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lnk04"
                 LET g_qryparam.arg1=g_argv1
                 LET g_qryparam.arg2=g_argv2
                 LET g_qryparam.state='c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lnk04
                 NEXT FIELD lnk04
          END CASE
   
      ON ACTION qbe_select
         CALL cl_qbe_select() 
      ON ACTION qbe_save
		   CALL cl_qbe_save()
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      LET g_rec_b =0 
      RETURN
   END IF
 
   CALL i551_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i551_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000      
 
    LET g_sql =
        "SELECT lnk03,'',lnk04,'','',lnk05 ",      #FUN-A60010
        " FROM lnk_file ",
        " WHERE lnk01='",g_argv1,"' AND lnk02='",g_argv2,"' AND ", g_wc2 CLIPPED,        #單身
        " ORDER BY lnk03"
    PREPARE i551_pb FROM g_sql
    DECLARE lnk_curs CURSOR FOR i551_pb
 
    CALL g_lnk.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH lnk_curs INTO g_lnk[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT azp02 INTO g_lnk[g_cnt].azp02 FROM azp_file
           WHERE azp01 =g_lnk[g_cnt].lnk03
           
#        SELECT lml02 INTO g_lnk[g_cnt].lmk01 FROM lml_file        #FUN-A60010
         SELECT lml02 INTO g_lnk[g_cnt].oba01 FROM lml_file        #FUN-A60010  add      
         WHERE lml01=g_lnk[g_cnt].lnk04
#        SELECT lmk02,lmk03,lmk04 INTO g_lnk[g_cnt].lmk02,g_lnk[g_cnt].lmk03,g_lnk[g_cnt].lmk04     #FUN-A60010
#          FROM lmk_file                                              #FUN-A60010
#         WHERE lmk01 = g_lnk[g_cnt].lmk01                           #FUN-A60010
 #FUN-A60010 add-----------------start---------------------
         SELECT  oba02 INTO g_lnk[g_cnt].oba02
         FROM oba_file
         WHERE oba01 = g_lnk[g_cnt].oba01                
  #FUN-A60010 add------------------end----------------------     
#        SELECT lmi02 INTO g_lnk[g_cnt].lmi02 FROM lmi_file 
#         WHERE lmi01 = g_lnk[g_cnt].lmk04        
#        SELECT lmj02 INTO g_lnk[g_cnt].lmj02 FROM lmj_file 
#         WHERE lmj01 = g_lnk[g_cnt].lmk03
        
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_lnk.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i551_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lnk TO s_lnk.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
#TQC-B60209 - MARK - BEGIN -------------------
#     ON ACTION query
#        LET g_action_choice="query"
#        EXIT DISPLAY
#TQC-B60209 - MARK -  END  -------------------
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         LET l_ac = 1
         EXIT DISPLAY
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
 
   
 
       ON ACTION related_document  
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#FUNCTION i551_out()
#DEFINE l_cmd LIKE type_file.chr1000
#
#    IF g_wc2 IS NULL THEN 
#       CALL cl_err('','9057',0)
#       RETURN
#    END IF
#    LET l_cmd = 'p_query "alnk200" "',g_wc2 CLIPPED,'"'                                                                               
#    CALL cl_cmdrun(l_cmd) 
#    RETURN
#END FUNCTION 

FUNCTION i551_check()
DEFINE   l_n         LIKE type_file.num5
DEFINE   l_n1        LIKE type_file.num5
    LET g_errno = " "
    IF NOT cl_null(g_lnk[l_ac].lnk03) AND g_lnk[l_ac].lnk04 IS NOT NULL THEN 
       SELECT count(*) INTO l_n FROM lnk_file
        WHERE lnk01=g_argv1 
          AND lnk02=g_argv2 
          AND lnk03 = g_lnk[l_ac].lnk03    
          AND lnk04 = g_lnk[l_ac].lnk04 
        IF l_n>0 THEN 
           LET g_errno='alm-835'
           RETURN 
       END IF
    END IF 
    IF NOT cl_null(g_lnk[l_ac].lnk03) AND NOT cl_null(g_lnk[l_ac].lnk04) THEN 
       SELECT COUNT(*) INTO l_n1 FROM lml_file
        WHERE lml01=g_lnk[l_ac].lnk04
          AND lmlstore=g_lnk[l_ac].lnk03
       IF l_n1=0 THEN 
          LET g_errno='alm-837'
          RETURN 
       END IF 
    END IF 
    
END FUNCTION     
              
FUNCTION i551_lnk03(p_cmd)
    DEFINE   p_cmd     LIKE type_file.chr1
    DEFINE   l_azp02   LIKE azp_file.azp02 #No.FUN-A40015
    DEFINE   l_rtz28   LIKE rtz_file.rtz28   #FUN-A80148 add
 
    LET g_errno = " "    
   #No.FUN-A40015 -BEGIN-----
   #SELECT lma02 INTO l_lma02 FROM lma_file WHERE lma01=g_lnk[l_ac].lnk03
   #CASE
   #   WHEN SQLCA.sqlcode=100   LET g_errno='anm-027'
   #                            LET l_lma02=NULL
   #   WHEN l_rtz28 !='Y'       LET g_errno='9029'
   #   OTHERWISE
   #        LET g_errno=SQLCA.sqlcode USING '------'
   #END CASE
   #IF cl_null(g_errno) OR p_cmd ='d' THEN 
   #   LET g_lnk[l_ac].lma02=l_lma02
   #   DISPLAY BY NAME g_lnk[l_ac].lma02
   #END IF
    SELECT azp02 INTO l_azp02 FROM azp_file,azw_file
     WHERE azp01=g_lnk[l_ac].lnk03
       AND azp01=azw01
    CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='anm-027'
                                LET l_azp02=NULL
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
    END CASE
    IF cl_null(g_errno) OR p_cmd ='d' THEN
       LET g_lnk[l_ac].azp02=l_azp02
       DISPLAY BY NAME g_lnk[l_ac].azp02
    END IF
   #No.FUN-A40015 -END-------           
END FUNCTION 
 
FUNCTION i551_lnk04(p_cmd)
DEFINE p_cmd        LIKE type_file.chr1
DEFINE l_lml02      LIKE lml_file.lml02
DEFINE l_lml06      LIKE lml_file.lml06
    
    LET g_errno = " "
    SELECT lml02,lml06
      INTO l_lml02,l_lml06
      FROM lml_file 
     WHERE lml01=g_lnk[l_ac].lnk04
       
      
      CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                  LET l_lml02=NULL 
           WHEN l_lml06='N'       LET g_errno='9028'
      OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
      END CASE 
    IF cl_null(g_errno) OR p_cmd= 'd' THEN  
 #      LET g_lnk[l_ac].lmk01=l_lml02     #FUN-A60010
       LET g_lnk[l_ac].oba01=l_lml02      #FUN-A60010 add
 #      SELECT lmk02,lmk03,lmk04                                       #FUN-A60010  
 #        INTO g_lnk[l_ac].lmk02,g_lnk[l_ac].lmk03,g_lnk[l_ac].lmk04    #FUN-A60010
 #        FROM lmk_file                                                 #FUN-A60010
 #       WHERE lmk01=g_lnk[l_ac].lmk01                                 #FUN-A60010 
  #FUN-A60010 add-----------------start---------------------
         SELECT  oba02 INTO g_lnk[l_ac].oba02
         FROM oba_file
         WHERE oba01 = g_lnk[l_ac].oba01                
  #FUN-A60010 add------------------end---------------------- 
 #FUN-A60010----------------------mark----------------------- 
 #      SELECT lmi02 INTO g_lnk[l_ac].lmi02 FROM lmi_file 
 #       WHERE lmi01 = g_lnk[l_ac].lmk04
 #      SELECT lmj02 INTO g_lnk[l_ac].lmj02 FROM lmj_file 
 #       WHERE lmj01 = g_lnk[l_ac].lmk03  
 #      DISPLAY BY NAME g_lnk[l_ac].lmk01
 #      DISPLAY BY NAME g_lnk[l_ac].lmk02
 #      DISPLAY BY NAME g_lnk[l_ac].lmk03         
 #      DISPLAY BY NAME g_lnk[l_ac].lmk04
 #      DISPLAY BY NAME g_lnk[l_ac].lmj02
 #      DISPLAY BY NAME g_lnk[l_ac].lmi02
 #FUN-A60010----------------------------mark-----------------------
        DISPLAY BY NAME g_lnk[l_ac].oba01      #FUN-A60010        
        DISPLAY BY NAME g_lnk[l_ac].oba02      #FUN-A60010
    END IF 
           
END FUNCTION 
 
                                                
FUNCTION i551_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                                             
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("lnk03,lnk02",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i551_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1
                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("lnk03,lnk02",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION
#FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore
