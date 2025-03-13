# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: arti105.4gl
# Descriptions...: 款別資料維護作業
# Date & Author..: 09/06/04 By lala
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-870007 09/12/09 By Cockroach PASS NO.
# Modify.........: No.FUN-9C0168 09/12/28 By lutingting 程序拿掉銀行相應欄位 
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-B60305 11/06/23 By guoch 取消打印按钮
# Modify.........: No.FUN-B80034 11/08/04 By nanbing 隱藏ryd03,ryd04欄位 
# Modify.........: No.FUN-C50036 12/05/22 By fanbj 增加功能編號(ryd06)及名稱
# Modify.........: No.FUN-C50036 12/05/31 By yangxf 如果aza88=Y， 已传pos否<>'1'，更改时把key值noentry
# Modify.........: No.FUN-C60050 12/07/12 BY yangxf 如果ryd04栏位值为NULL则赋值ryd02的值,新增ryd07,ryd08,ryd09栏位及相关逻辑
# Modify.........: No.FUN-C80072 12/08/27 By xumm ryd03->ryd10,key值检查改为ryd01+ryd10
# Modify.........: No.FUN-CB0007 12/11/02 By xumm 增加ryd11,ryd12栏位
# Modify.........: No.FUN-CC0116 13/01/17 By xumm 增加ryd13栏位
# Modify.........: No:FUN-D30033 13/04/10 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_ryd          DYNAMIC ARRAY OF RECORD 
        ryd01       LIKE ryd_file.ryd01,  
        ryd02       LIKE ryd_file.ryd02,  
        ryd06       LIKE ryd_file.ryd06,    #FUN-C50036 add
        ryd06_desc  LIKE ryx_file.ryx05,    #FUN-C50036 add
        #ryd03       LIKE ryd_file.ryd03,   #FUN-C80072 mark
        ryd10       LIKE ryd_file.ryd10,    #FUN-C80072 add
        ryd04       LIKE ryd_file.ryd04,
        #ryd05       LIKE ryd_file.ryd05,   #FUN-9C0168 mark
        #ryd05_desc  LIKE nma_file.nma02,   #FUN-9C0168 mark
        ryd07       LIKE ryd_file.ryd07,    #FUN-C60050 add
        ryd08       LIKE ryd_file.ryd08,    #FUN-C60050 add
        ryd11       LIKE ryd_file.ryd11,    #FUN-CB0007 add
        ryd12       LIKE ryd_file.ryd12,    #FUN-CB0007 add
        ryd13       LIKE ryd_file.ryd13,    #FUN-CC0116 add
        ryd09       LIKE ryd_file.ryd09,    #FUN-C60050 add
        rydpos      LIKE ryd_file.rydpos,   #FUN-C50036 add
        rydacti     LIKE ryd_file.rydacti   
                    END RECORD,
    g_ryd_t         RECORD                
        ryd01       LIKE ryd_file.ryd01,  
        ryd02       LIKE ryd_file.ryd02,  
        ryd06       LIKE ryd_file.ryd06,    #FUN-C50036 add
        ryd06_desc  LIKE ryx_file.ryx05,    #FUN-C50036 add
        #ryd03       LIKE ryd_file.ryd03,   #FUN-C80072 mark
        ryd10       LIKE ryd_file.ryd10,    #FUN-C80072 add
        ryd04       LIKE ryd_file.ryd04,
        #ryd05       LIKE ryd_file.ryd05,   #FUN-9C0168 mark
        #ryd05_desc  LIKE nma_file.nma02,   #FUN-9C0168 mark
        ryd07       LIKE ryd_file.ryd07,    #FUN-C60050 add
        ryd08       LIKE ryd_file.ryd08,    #FUN-C60050 add
        ryd11       LIKE ryd_file.ryd11,    #FUN-CB0007 add
        ryd12       LIKE ryd_file.ryd12,    #FUN-CB0007 add
        ryd13       LIKE ryd_file.ryd13,    #FUN-CC0116 add
        ryd09       LIKE ryd_file.ryd09,    #FUN-C60050 add
        rydpos      LIKE ryd_file.rydpos,   #FUN-C50036 add 
        rydacti     LIKE ryd_file.rydacti 
                    END RECORD,
     g_wc2,g_sql    STRING,  
    g_rec_b         LIKE type_file.num5,        
    l_ac            LIKE type_file.num5         
 
DEFINE g_forupd_sql STRING   
DEFINE   g_cnt           LIKE type_file.num10   
DEFINE   g_i             LIKE type_file.num5   
MAIN  
DEFINE p_row,p_col   LIKE type_file.num5  
    OPTIONS                              
        INPUT NO WRAP
    DEFER INTERRUPT    
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)   
         RETURNING g_time   
    LET p_row = 5 LET p_col = 22
    OPEN WINDOW i105_w AT p_row,p_col WITH FORM "art/42f/arti105"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
    #CALL cl_set_comp_visible('ryd03,ryd04',FALSE)    #FUN-B80034  #FUN-C50036 mark
    CALL cl_set_comp_visible("rydpos",g_aza.aza88 = 'Y')           #FUN-C50036 add
    LET g_wc2 = '1=1' CALL i105_b_fill(g_wc2)
    CALL i105_menu()
    CLOSE WINDOW i105_w              
      CALL  cl_used(g_prog,g_time,2) 
         RETURNING g_time  
END MAIN
 
FUNCTION i105_menu()
 
   WHILE TRUE
      CALL i105_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i105_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i105_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         #WHEN "output"
         #   IF cl_chk_act_auth() THEN
         #      CALL i105_out()
         #   END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "related_document"  
            IF cl_chk_act_auth() THEN
               IF g_ryd[l_ac].ryd01 IS NOT NULL THEN
                  LET g_doc.column1 = "ryd01"
                  LET g_doc.value1 = g_ryd[l_ac].ryd01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ryd),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i105_q()
   CALL i105_b_askkey()
END FUNCTION
 
FUNCTION i105_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     
    l_n             LIKE type_file.num5,      
    l_lock_sw       LIKE type_file.chr1,       
    p_cmd           LIKE type_file.chr1,      
    l_allow_insert  LIKE type_file.chr1,      
    l_allow_delete  LIKE type_file.chr1    

DEFINE l_rydpos     LIKE ryd_file.rydpos         #FUN-C50036 add 

    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    #LET g_forupd_sql = "SELECT ryd01,ryd02,ryd03,ryd04,ryd05,'',rydacti FROM ryd_file",  #FUN-9C0168
    #LET g_forupd_sql = "SELECT ryd01,ryd02,ryd03,ryd04,rydacti FROM ryd_file",    #FUN-9C0168  #FUN-C50036 mark
    #LET g_forupd_sql = "SELECT ryd01,ryd02,ryd06,'',ryd03,ryd04,rydpos,rydacti FROM ryd_file",  #FUN-C50036 add       #FUN-C60050 mark
    #LET g_forupd_sql = "SELECT ryd01,ryd02,ryd06,'',ryd03,ryd04,ryd07,ryd08,ryd09,rydpos,rydacti FROM ryd_file",      #FUN-C60050 add     #FUN-C80072 mark
    #                   " WHERE ryd01=? FOR UPDATE"                                                                    #FUN-C80072 mark
    LET g_forupd_sql = "SELECT ryd01,ryd02,ryd06,'',ryd10,ryd04,ryd07,ryd08,ryd11,ryd12,ryd13,ryd09,rydpos,rydacti FROM ryd_file",       #FUN-C80072 add  #FUN-CB0007 add ryd11,ryd12  #FUN-CC0116 add ryd13
                       " WHERE ryd01 = ?  AND ryd10 = ? FOR UPDATE "                                                                     #FUN-C80072 add
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i105_bcl CURSOR FROM g_forupd_sql    
 
    INPUT ARRAY g_ryd WITHOUT DEFAULTS FROM s_ryd.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'           
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
               
               #FUN-C50036--start add----------------------------
               LET p_cmd='u'
               #CALL cl_set_comp_entry("ryd01",FALSE)       #FUN-C80072 mark
               LET g_ryd_t.* = g_ryd[l_ac].*
   
               IF g_aza.aza88 = 'Y' THEN
                  BEGIN WORK
                  #OPEN i105_bcl USING g_ryd_t.ryd01  #FUN-C80072 mark
                  OPEN i105_bcl USING g_ryd_t.ryd01,g_ryd_t.ryd10   #FUN-C80072 add
                  IF STATUS THEN
                  ELSE
                     FETCH i105_bcl INTO g_ryd[l_ac].*
                     IF SQLCA.sqlcode THEN
                     ELSE
                        UPDATE ryd_file
                           SET rydpos = '4'
                         WHERE ryd01 = g_ryd[l_ac].ryd01
                           AND ryd10 = g_ryd[l_ac].ryd10      #FUN-C80072 add
                        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                           CALL cl_err3("upd","ryd_file",g_ryd_t.ryd01,"",SQLCA.sqlcode,"","",1)
                           LET l_lock_sw = "Y"
                        END IF
                        LET l_rydpos = g_ryd[l_ac].rydpos
                        LET g_ryd[l_ac].rydpos = '4'
                        DISPLAY BY NAME g_ryd[l_ac].rydpos
                     END IF
                  END IF
                  CLOSE i105_bcl
                  COMMIT WORK
               END IF
               #FUN-C50036--end add----------------------------------------

               BEGIN WORK
               #FUN-C50036--start add-----------------
               #LET p_cmd='u'
               #CALL cl_set_comp_entry("ryd01",FALSE)
               #LET g_ryd_t.* = g_ryd[l_ac].* 
               #FUN-C50036--end add-------------------
 
               #OPEN i105_bcl USING g_ryd_t.ryd01  #FUN-C80072 mark
               OPEN i105_bcl USING g_ryd_t.ryd01,g_ryd_t.ryd10   #FUN-C80072 add 
               IF STATUS THEN
                  CALL cl_err("OPEN i105_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE 
                  FETCH i105_bcl INTO g_ryd[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ryd_t.ryd01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  CALL i105_ryd06('d')                                   #FUN-C50036 add
               END IF
               #SELECT nma02  INTO g_ryd[l_ac].ryd05_desc FROM nma_file  #FUN-9C0168
               # WHERE g_ryd[l_ac].ryd05 = nma01                         #FUN-9C0168
               CALL cl_show_fld_cont()  
            END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           CALL cl_set_comp_entry("ryd01",TRUE)
           INITIALIZE g_ryd[l_ac].* TO NULL  
           LET g_ryd[l_ac].rydacti = 'Y'  
           LET g_ryd_t.* = g_ryd[l_ac].* 
           LET g_ryd[l_ac].ryd07 = 'Y'    #FUN-C60050 add
           LET g_ryd[l_ac].ryd08 = 'Y'    #FUN-C60050 add
           LET g_ryd[l_ac].ryd09 = 0      #FUN-C60050 add
           LET g_ryd[l_ac].ryd11 = 'Y'    #FUN-CB0007 add
           LET g_ryd[l_ac].ryd12 = 'Y'    #FUN-CB0007 add
           LET g_ryd[l_ac].ryd13 = 'Y'    #FUN-CC0116 add
           #FUN-C50036--start add----------------
           IF g_aza.aza88 = 'Y' THEN
              LET g_ryd[l_ac].rydpos = '1'
              LET l_rydpos = '1'
           END IF
           DISPLAY BY NAME g_ryd[l_ac].rydpos
           CALL cl_set_comp_entry("rydpos",FALSE)
           #FUN-C50036--end add------------------

           CALL cl_show_fld_cont() 
           NEXT FIELD ryd01
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i105_bcl
              CANCEL INSERT
           END IF
           #LET g_ryd[l_ac].ryd03 = g_ryd[l_ac].ryd01      #FUN-B80034 ryd01與ryd03在數據庫中類型不同       #FUN-C80072 mark
           #INSERT INTO ryd_file(ryd01,ryd02,ryd03,ryd04,ryd05,rydacti,ryduser,rydgrup,rydcrat)   #FUN-9C0168
           #INSERT INTO ryd_file(ryd01,ryd02,ryd03,ryd04,rydacti,ryduser,rydgrup,rydcrat,rydoriu,rydorig) #FUN-9C0168 #FUN-C50036 mark
           #INSERT INTO ryd_file(ryd01,ryd02,ryd06,ryd03,ryd04,rydpos,rydacti,ryduser,rydgrup,rydcrat,rydoriu,rydorig) #FUN-C50036 add #FUN-C60050 MARK 
           #INSERT INTO ryd_file(ryd01,ryd02,ryd06,ryd03,ryd04,ryd07,ryd08,ryd09,rydpos,rydacti,ryduser,rydgrup,rydcrat,rydoriu,rydorig) #FUN-C60050 add   #FUN-C80072 mark
           #INSERT INTO ryd_file(ryd01,ryd02,ryd06,ryd10,ryd04,ryd07,ryd08,ryd09,rydpos,rydacti,ryduser,rydgrup,rydcrat,rydoriu,rydorig)  #FUN-C80072 add    #FUN-CB0007 mark
                      #VALUES(g_ryd[l_ac].ryd01,g_ryd[l_ac].ryd02,g_ryd[l_ac].ryd03,                                  #FUN-C50036 mark
                      #VALUES(g_ryd[l_ac].ryd01,g_ryd[l_ac].ryd02,g_ryd[l_ac].ryd06,g_ryd[l_ac].ryd03,                #FUN-C50036 add    #FUN-C80072 mark
                      #VALUES(g_ryd[l_ac].ryd01,g_ryd[l_ac].ryd02,g_ryd[l_ac].ryd06,g_ryd[l_ac].ryd10,                 #FUN-C80072 add   #FUN-CB0007 mark
                         #g_ryd[l_ac].ryd04,g_ryd[l_ac].ryd05,g_ryd[l_ac].rydacti,  #FUN-9C0168
                      #  g_ryd[l_ac].ryd04,g_ryd[l_ac].rydacti,   #FUN-9C0168 #FUN-B80034 mark
                        #g_ryd[l_ac].ryd02,g_ryd[l_ac].rydacti, #FUN-B80034 add                                      #FUN-C50036 mark
                        #g_ryd[l_ac].ryd02,g_ryd[l_ac].rydpos,g_ryd[l_ac].rydacti,                                    #FUN-C50036 add     #FUN-C60050 MARK
                        #g_ryd[l_ac].ryd04,g_ryd[l_ac].ryd07,g_ryd[l_ac].ryd08,g_ryd[l_ac].ryd09,g_ryd[l_ac].rydpos,g_ryd[l_ac].rydacti,  #FUN-C60050 add   #FUN-CB0007 mark
           INSERT INTO ryd_file(ryd01,ryd02,ryd06,ryd10,ryd04,ryd07,ryd08,ryd11,ryd12,ryd13,ryd09,rydpos,rydacti,ryduser,rydgrup,rydcrat,rydoriu,rydorig) #FUN-CB0007 add  #FUN-CC0116 add ryd13
                       VALUES(g_ryd[l_ac].ryd01,g_ryd[l_ac].ryd02,g_ryd[l_ac].ryd06,g_ryd[l_ac].ryd10,g_ryd[l_ac].ryd04,g_ryd[l_ac].ryd07,          #FUN-CB0007 add
                              g_ryd[l_ac].ryd08,g_ryd[l_ac].ryd11,g_ryd[l_ac].ryd12,g_ryd[l_ac].ryd13,g_ryd[l_ac].ryd09,g_ryd[l_ac].rydpos,g_ryd[l_ac].rydacti,       #FUN-CB0007 add  #FUN-CC0116 add ryd13
                              g_user,g_grup,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","ryd_file",g_ryd[l_ac].ryd01,"",SQLCA.sqlcode,"","",1) 
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
       #FUN-C80072----mark----str
       #AFTER FIELD ryd01   
       #    IF NOT cl_null(g_ryd[l_ac].ryd01) THEN
       #       IF g_ryd[l_ac].ryd01 != g_ryd_t.ryd01 OR
       #          g_ryd_t.ryd01 IS NULL THEN
       #           SELECT COUNT(*) INTO l_n FROM ryd_file
       #               WHERE ryd01 = g_ryd[l_ac].ryd01
       #           IF l_n > 0 THEN
       #               CALL cl_err('',-239,0)
       #               LET g_ryd[l_ac].ryd01 = g_ryd_t.ryd01
       #               NEXT FIELD ryd01
       #           END IF
       #       END IF
       #    END IF
       #FUN-C80072----mark----add

        #FUN-C80072----add----str
        AFTER FIELD ryd01
           IF NOT cl_null(g_ryd[l_ac].ryd01) AND NOT cl_null(g_ryd[l_ac].ryd10) THEN
              IF g_ryd[l_ac].ryd01 != g_ryd_t.ryd01 
                 OR g_ryd_t.ryd01 IS NULL THEN
                 SELECT COUNT(*) INTO l_n FROM ryd_file
                  WHERE ryd01 = g_ryd[l_ac].ryd01
                    AND ryd10 = g_ryd[l_ac].ryd10
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_ryd[l_ac].ryd01 = g_ryd_t.ryd01
                    NEXT FIELD ryd01
                 END IF
              END IF 
           END IF

        AFTER FIELD ryd10
           IF NOT cl_null(g_ryd[l_ac].ryd10) THEN
              IF g_ryd[l_ac].ryd10 != g_ryd_t.ryd10 
                 OR g_ryd_t.ryd10 IS NULL THEN
                 SELECT COUNT(*) INTO l_n FROM ryd_file
                  WHERE ryd10 = g_ryd[l_ac].ryd10
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_ryd[l_ac].ryd10 = g_ryd_t.ryd10
                    NEXT FIELD ryd10
                 END IF
              END IF
           END IF
        #FUN-C80072----add----end

#FUN-C60050 add begin ---
        AFTER FIELD ryd02
            IF cl_null(g_ryd[l_ac].ryd04) THEN
               LET g_ryd[l_ac].ryd04 = g_ryd[l_ac].ryd02
            END IF 

        AFTER FIELD ryd09
            IF NOT cl_null(g_ryd[l_ac].ryd09) THEN
               IF g_ryd[l_ac].ryd09 < 0 THEN
                  LET g_ryd[l_ac].ryd09 = g_ryd_t.ryd09
                  CALL cl_err('','art1076',0)
                  NEXT FIELD ryd09
               END IF 
            END IF 
#FUN-C60050 add end ----
       #FUN-C80072----mark----str 
       #AFTER FIELD ryd03   
       #    IF NOT cl_null(g_ryd[l_ac].ryd03) THEN
       #       IF g_ryd[l_ac].ryd03 != g_ryd_t.ryd03 OR
       #          g_ryd_t.ryd03 IS NULL THEN
       #           SELECT COUNT(*) INTO l_n FROM ryd_file
       #               WHERE ryd03 = g_ryd[l_ac].ryd03
       #           IF l_n > 0 THEN
       #               CALL cl_err('',-239,0)
       #               LET g_ryd[l_ac].ryd03 = g_ryd_t.ryd03
       #               NEXT FIELD ryd03
       #           END IF
       #       END IF
       #    END IF
       #FUN-C80072----mark----end

      #FUN-C50036--start add-----------------------------------
      AFTER FIELD ryd06
         IF NOT cl_null(g_ryd[l_ac].ryd06) THEN
            CALL i105_ryd06(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_ryd[l_ac].ryd06 = g_ryd_t.ryd06
               NEXT FIELD ryd06
            END IF 
         END IF 

      AFTER FIELD rydpos
         IF NOT cl_null(g_ryd[l_ac].rydpos) THEN
            IF g_ryd[l_ac].rydpos NOT MATCHES '[123]' THEN
               NEXT FIELD rydpos
            END IF
         END IF
      #FUN-C50036--end add-------------------------------------
 
 
      #FUN-9C0168--mark--str--
      #AFTER FIELD ryd05
      #    IF NOT cl_null(g_ryd[l_ac].ryd05) THEN
      #       CALL i105_ryd05('a')
      #       IF NOT cl_null(g_errno)  THEN
      #          CALL cl_err('',g_errno,0) 
      #          LET g_ryd[l_ac].ryd05 = g_ryd_t.ryd05
      #          NEXT FIELD ryd05
      #       END IF
      #   END IF
      #FUN-9C0168--mark--end
                                                  	
       AFTER FIELD rydacti
          IF NOT cl_null(g_ryd[l_ac].rydacti) THEN
             IF g_ryd[l_ac].rydacti NOT MATCHES '[YN]' THEN
                LET g_ryd[l_ac].rydacti = g_ryd_t.rydacti
                NEXT FIELD rydacti
             END IF
          END IF
      
        BEFORE DELETE  
            IF g_ryd_t.ryd01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                     CANCEL DELETE
                END IF
                INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
                LET g_doc.column1 = "ryd01"               #No.FUN-9B0098 10/02/24
                LET g_doc.value1 = g_ryd[l_ac].ryd01      #No.FUN-9B0098 10/02/24
                CALL cl_del_doc()                                              #No.FUN-9B0098 10/02/24
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 

                #FUN-C50036--start add--------------------------
                IF g_aza.aza88 = 'Y' THEN
                   IF NOT ((l_rydpos='3' AND g_ryd_t.rydacti='N')
                          OR (l_rydpos ='1'))  THEN
                      CALL cl_err('','apc-139',0)
                      CANCEL DELETE
                   END IF
                END IF
                #FUN-C50036--end add----------------------------

                #DELETE FROM ryd_file WHERE ryd01 = g_ryd_t.ryd01                                        #FUN-C80072 mark
                DELETE FROM ryd_file WHERE ryd01 = g_ryd_t.ryd01 AND ryd10 = g_ryd_t.ryd10               #FUN-C80072 add
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","ryd_file",g_ryd_t.ryd01,"",SQLCA.sqlcode,"","",1) 
                    EXIT INPUT
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN     
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ryd[l_ac].* = g_ryd_t.*
              CLOSE i105_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF

           #FUN-C50036--start add-------------------
           IF g_aza.aza88 = 'Y' THEN
              IF l_rydpos <> '1' THEN
                 LET g_ryd[l_ac].rydpos = '2'
              ELSE
                 LET g_ryd[l_ac].rydpos = '1'
              END IF
           END IF
           #FUN-C50036--end add---------------------
  
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_ryd[l_ac].ryd01,-263,0)
               LET g_ryd[l_ac].* = g_ryd_t.*
           ELSE
               #LET g_ryd[l_ac].ryd03 = g_ryd[l_ac].ryd01      #FUN-B80034    #FUN-C80072 mark
               UPDATE ryd_file SET ryd01=g_ryd[l_ac].ryd01,
                                   ryd02=g_ryd[l_ac].ryd02,
                                   #ryd03=g_ryd[l_ac].ryd03,   #FUN-C80072 mark
                                   ryd10=g_ryd[l_ac].ryd10,    #FUN-C80072 add
                                   #ryd04=g_ryd[l_ac].ryd04,  #FUN-B80034 mark 
                                   #ryd04=g_ryd[l_ac].ryd02,   #FUN-B80034 add       #FUN-60050 MARK 
                                   #ryd05=g_ryd[l_ac].ryd05,   #FUN-9C0168
                                   ryd04=g_ryd[l_ac].ryd04,   #FUN-C60050 add
                                   ryd06= g_ryd[l_ac].ryd06,  #FUN-C50036 add  
                                   ryd07=g_ryd[l_ac].ryd07,   #FUN-C60050 add
                                   ryd08=g_ryd[l_ac].ryd08,   #FUN-C60050 add
                                   ryd11=g_ryd[l_ac].ryd11,   #FUN-CB0007 add
                                   ryd12=g_ryd[l_ac].ryd12,   #FUN-CB0007 add
                                   ryd13=g_ryd[l_ac].ryd13,   #FUN-CC0116 add
                                   ryd09=g_ryd[l_ac].ryd09,   #FUN-C60050 add
                                   rydpos= g_ryd[l_ac].rydpos,#FUN-C50036 add
                                   rydacti=g_ryd[l_ac].rydacti,
                                   rydmodu=g_user,
                                   ryddate=g_today
                WHERE ryd01 = g_ryd_t.ryd01 
                  AND ryd10 = g_ryd_t.ryd10      #FUN-C80072 add
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","ryd_file",g_ryd_t.ryd01,"",SQLCA.sqlcode,"","",1)
                  LET g_ryd[l_ac].* = g_ryd_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac      #FUN-D30033 Mark
 
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i105_bcl
              ROLLBACK WORK
              IF p_cmd='u' THEN
                 #FUN-C50036--start add-----------------------
                 IF g_aza.aza88 = 'Y' AND l_lock_sw <> 'Y' THEN
                    UPDATE ryd_file
                       SET rydpos = l_rydpos
                     WHERE ryd01 = g_ryd_t.ryd01
                       AND ryd10 = g_ryd_t.ryd10      #FUN-C80072 add
                    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                       CALL cl_err3("upd","ryd_file",g_ryd_t.ryd01,"",SQLCA.sqlcode,"","",1)
                    END IF
                    LET g_ryd[l_ac].rydpos = l_rydpos
                    DISPLAY BY NAME g_ryd[l_ac].rydpos
                 END IF
                 #FUN-C50036--end add------------------------- 
                
                 LET g_ryd[l_ac].* = g_ryd_t.*
              ELSE                                         #FUN-C50036 add
                 CALL g_ryd.deleteElement(l_ac)            #FUN-C50036 add
                 #FUN-D30033--add--str--
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
                 #FUN-D30033--add--end--
              END IF
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac      #FUN-D30033 Add
           CLOSE i105_bcl
           COMMIT WORK
 
      #FUN-9C0168--mark--str--
      #ON ACTION controlp
      #    CASE WHEN INFIELD(ryd05)
      #            CALL cl_init_qry_var()
      #            LET g_qryparam.form = "q_nma"
      #            LET g_qryparam.default1 = g_ryd[l_ac].ryd05
      #            CALL cl_create_qry() RETURNING g_ryd[l_ac].ryd05
      #            DISPLAY g_ryd[l_ac].ryd05 TO ryd05
      #            CALL i105_ryd05('a')
      #         OTHERWISE
      #            EXIT CASE
      #     END CASE
      #FUN-9C0168--mark--end

      #FUN-C50036--start add---------------------
      ON ACTION controlp
         CASE
            WHEN INFIELD(ryd06)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ryq01"
               LET g_qryparam.default1 = g_ryd[l_ac].ryd06
               LET g_qryparam.arg1 = g_lang
               CALL cl_create_qry() RETURNING g_ryd[l_ac].ryd06
               DISPLAY g_ryd[l_ac].ryd06 TO ryd06
               CALL i105_ryd06('a')
            OTHERWISE
               EXIT CASE       
         END CASE 
      #FUN-C50036--end add----------------------- 
 
        ON ACTION CONTROLO  
            IF INFIELD(ryd01) AND l_ac > 1 THEN
                LET g_ryd[l_ac].* = g_ryd[l_ac-1].*
                NEXT FIELD ryd01
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
 
     ON ACTION about         
        CALL cl_about()      
 
     ON ACTION help          
        CALL cl_show_help()  
 
        
        END INPUT
 
 
    CLOSE i105_bcl
    COMMIT WORK
END FUNCTION
 
#FUN-9C0168--mark--str--
#FUNCTION i105_ryd05(p_cmd)
#DEFINE
#   p_cmd           LIKE type_file.chr1, 
#   l_nmaacti       LIKE nma_file.nmaacti
#
#   LET g_errno = ' '
#   SELECT nma02,nmaacti INTO g_ryd[l_ac].ryd05_desc,l_nmaacti
#       FROM nma_file
#       WHERE nma01 = g_ryd[l_ac].ryd05
#   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'art-589'
#                           LET g_ryd[l_ac].ryd05 = NULL
#        WHEN l_nmaacti='N' LET g_errno = '9028'
#        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
#   END CASE
#END FUNCTION
#FUN-9C0168--mark-end
 
FUNCTION i105_b_askkey()
 
    CLEAR FORM
   CALL g_ryd.clear()
 
    #CONSTRUCT g_wc2 ON ryd01,ryd02,ryd03,ryd04,rydacti   #FUN-9C0168 del ryd05  #FUN-C50036 mark
    #CONSTRUCT g_wc2 ON ryd01,ryd02,ryd06,ryd03,ryd04,rydpos,rydacti              #FUN-C50036 add  #FUN-C60050 mark
    #CONSTRUCT g_wc2 ON ryd01,ryd02,ryd06,ryd03,ryd04,ryd07,ryd08,ryd09,rydpos,rydacti        #FUN-C60050 add              #FUN-C80072 mark
    CONSTRUCT g_wc2 ON ryd01,ryd02,ryd06,ryd10,ryd04,ryd07,ryd08,ryd11,ryd12,ryd13,ryd09,rydpos,rydacti                          #FUN-C80072 add  #FUN-CB0007 add ryd11,ryd12  #FUN-CC0116 add ryd13
         #FROM s_ryd[1].ryd01,s_ryd[1].ryd02,s_ryd[1].ryd03,s_ryd[1].ryd04,s_ryd[1].rydacti   #FUN-9C0168 del ryd05        #FUN-C50036 mark
         #FROM s_ryd[1].ryd01,s_ryd[1].ryd02,s_ryd[1].ryd06,s_ryd[1].ryd03,s_ryd[1].ryd04,s_ryd[1].rydpos,s_ryd[1].rydacti #FUN-C50036 add   #FUN-C60050 mark
         #FROM s_ryd[1].ryd01,s_ryd[1].ryd02,s_ryd[1].ryd06,s_ryd[1].ryd03,s_ryd[1].ryd04,s_ryd[1].ryd07,s_ryd[1].ryd08,   #FUN-C60050 add   #FUN-C80072 mark
         FROM s_ryd[1].ryd01,s_ryd[1].ryd02,s_ryd[1].ryd06,s_ryd[1].ryd10,s_ryd[1].ryd04,s_ryd[1].ryd07,s_ryd[1].ryd08,    #FUN-C80072 add
              s_ryd[1].ryd11,s_ryd[1].ryd12,s_ryd[1].ryd13,s_ryd[1].ryd09,s_ryd[1].rydpos,s_ryd[1].rydacti                                #FUN-C60050 add #FUN-CB0007 add ryd11,ryd12 #FUN-CC0116 add ryd13
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
        #FUN-9C0168--mark--str--
        #ON ACTION controlp
        #    CASE WHEN INFIELD(ryd05)
        #            CALL cl_init_qry_var()
        #            LET g_qryparam.form = "q_ryd05"
        #            LET g_qryparam.state = "c"
        #            CALL cl_create_qry() RETURNING g_qryparam.multiret
        #            DISPLAY g_qryparam.multiret TO s_ryd[1].ryd05            
        #            CALL i105_ryd05('a')
        #         OTHERWISE
        #            EXIT CASE
        #     END CASE
        #FUN-9C0168--mark--end
 
       #FUN-C50036--start add----------------------
       ON ACTION controlp
          CASE 
             WHEN INFIELD(ryd06)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ryd06"
                LET g_qryparam.state = "c"
                LET g_qryparam.arg1 = g_lang 
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO s_ryd[1].ryd06
                CALL i105_ryd06('d')
             OTHERWISE
                EXIT CASE
          END CASE     
       #FUN-C50036--end add------------------------

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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('ryduser', 'rydgrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
 
    CALL i105_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i105_b_fill(p_wc2)            
   DEFINE p_wc2           LIKE type_file.chr1000
 
    LET g_sql =
        #FUN-9C0168--mod--str--
        #"SELECT ryd01,ryd02,ryd03,ryd04,ryd05,nma02,rydacti",
        #" FROM ryd_file,OUTER nma_file",
        #" WHERE ryd05 = nma01 AND ", p_wc2 CLIPPED,
        #"SELECT ryd01,ryd02,ryd03,ryd04,rydacti",                 #FUN-C50036 mark
        #"SELECT ryd01,ryd02,ryd06,'',ryd03,ryd04,rydpos,rydacti",  #FUN-C50036 add  #FUN-C60050 mark
        #"SELECT ryd01,ryd02,ryd06,'',ryd03,ryd04,ryd07,ryd08,ryd09,rydpos,rydacti",   #FUN-C60050 add   #FUN-C80072 mark
        "SELECT ryd01,ryd02,ryd06,'',ryd10,ryd04,ryd07,ryd08,ryd11,ryd12,ryd13,ryd09,rydpos,rydacti",    #FUN-C80072 add  #FUN-CB0007 add ryd11,ryd12 #FUN-CC0116 add ryd13
        " FROM ryd_file",
        " WHERE ", p_wc2 CLIPPED, 
        " ORDER BY 1"
        #FUN-9C0168--mod--end
    PREPARE i105_pb FROM g_sql
    DECLARE ryd_curs CURSOR FOR i105_pb
 
    CALL g_ryd.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH ryd_curs INTO g_ryd[g_cnt].* 
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF

        #FUN-C50036--start add-------------------------
        SELECT ryx05 INTO g_ryd[g_cnt].ryd06_desc 
          FROM ryx_file
         WHERE ryx01 = 'ryq_file'
           AND ryx02 = 'ryq01'
           AND ryx03 = g_ryd[g_cnt].ryd06
           AND ryx04 = g_lang

        DISPLAY g_ryd[g_cnt].ryd06_desc TO s_ryd[l_ac].ryd06_desc
        #FUN-C50036--end add---------------------------

        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_ryd.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i105_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ryd TO s_ryd.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()     
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         LET l_ac = 1
         EXIT DISPLAY
  #TQC-B60305 mark --begin
  #    ON ACTION output
  #       LET g_action_choice="output"
  #       EXIT DISPLAY
  #TQC-B60305 mark --end
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

#FUN-C50036--start add----------------------------
FUNCTION i105_ryd06(p_cmd)
   DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_ryqacti     LIKE ryq_file.ryqacti
   DEFINE l_ryq03       LIKE ryq_file.ryq03      #FUN-CB0007 add
   
   LET g_errno = ''
   
   #SELECT ryqacti INTO l_ryqacti                #FUN-CB0007 mark
   SELECT ryqacti,ryq03 INTO l_ryqacti,l_ryq03
     FROM ryq_file
    WHERE ryq01 = g_ryd[l_ac].ryd06

   CASE
       WHEN SQLCA.SQLCODE = 100
          LET g_errno = 'apc-190'
       WHEN l_ryqacti <> 'Y'
          LET g_errno = 'apc-191'
       WHEN l_ryq03 <> 'Y'                       #FUN-CB0007 add
          LET g_errno = 'apc1057'                #FUN-CB0007 add
       OTHERWISE
          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      SELECT ryx05 INTO g_ryd[l_ac].ryd06_desc 
        FROM ryx_file
       WHERE ryx01 = 'ryq_file'
         AND ryx02 = 'ryq01'
         AND ryx03 = g_ryd[l_ac].ryd06
         AND ryx04 = g_lang
      
      DISPLAY g_ryd[l_ac].ryd06_desc TO s_ryd[l_ac].ryd06_desc 
   END IF 
END FUNCTION 
#FUN-C50036--end add------------------------------

#
#UNCTION i105_out()
#   DEFINE
#       l_ryd           RECORD LIKE ryd_file.*,
#       l_i             LIKE type_file.num5,     
#       l_name          LIKE type_file.chr20,    
#       l_za05          LIKE za_file.za05        
#  
#   IF g_wc2 IS NULL THEN 
#    # CALL cl_err('',-400,0) 
#      CALL cl_err('','9057',0)
#   RETURN END IF
#   CALL cl_wait()
#   CALL cl_outnam('arti105') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT * FROM ryd_file ",   
#             " WHERE ",g_wc2 CLIPPED
#   PREPARE i105_p1 FROM g_sql           
#   DECLARE i105_co              
#        CURSOR FOR i105_p1
#
#   START REPORT i105_rep TO l_name
#
#   FOREACH i105_co INTO l_ryd.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)    
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i105_rep(l_ryd.*)
#   END FOREACH
#
#   FINISH REPORT i105_rep
#
#   CLOSE i105_co
#   ERROR ""
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#ND FUNCTION
#
#EPORT i105_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1, 
#       sr RECORD LIKE ryd_file.*,
#       l_nma02   LIKE nma_file.nma02,
#       l_chr           LIKE type_file.chr1, 
#       l_area          LIKE type_file.chr20 
#
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#
#   ORDER BY sr.ryd01
#
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno=g_pageno+1
#           LET pageno_total=PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED,pageno_total
#           PRINT g_dash[1,g_len]
#           PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
#       ON EVERY ROW
#           SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01 = sr.ryd03
#           LET l_area=sr.ryd03,'   ',l_nma02
#           IF sr.rydacti = 'N' 
#               THEN PRINT g_c[31],'* ';
#           END IF
#           PRINT COLUMN g_c[32],sr.ryd01,
#                 COLUMN g_c[33],sr.ryd02,
#                 COLUMN g_c[34],l_area
#       ON LAST ROW
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#ND REPORT
#
#FUN-870007 PASS NO.
