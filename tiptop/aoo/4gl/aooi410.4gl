# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
#Pattern name..:"aooi410.4gl"
#Descriptions..:默認單別維護作業
#Date & Author..:08/07/07 By lala
#Modify.........: 09/06/04 By Zhangyajun 增加alm模
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0025 09/11/30 By cockroach PASS no.
# Modify.........: No.TQC-A10112 10/01/13 By Cockroach rye02查詢開窗修改
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A10109 10/03/12 by rainy 單據性質改抓 aooi800 設定
# Modify.........: No.FUN-A50065 10/05/17 By Cockroach 添加POS默認單別字段:rye04
# Modify.........: No.FUN-A70130 10/08/05 By huangtao 程式中所有 判斷 alm 系統，抓 lrk_file 的部份，全部改成抓 oay_file 
# Modify.........: No.TQC-A90052 10/10/13 By houlia rye02查詢開窗修改
# Modify.........: No.TQC-AB0241 10/11/29 By shenyang GP5.2 SOP流程修改 
# Modify.........: No.TQC-B30053 11/03/10 By destiny 增加atm模组 
# Modify.........: No.FUN-C90050 12/10/23 By Loei 增加歸屬營運中心欄位rye05
# Modify.........: No.FUN-D20097 13/03/14 By pauline 相同營運中心不可針對同系統+單據性質設定不同預設單別
# Modify.........: No:FUN-D40030 13/04/08 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_rye           DYNAMIC ARRAY OF RECORD
        rye01       LIKE rye_file.rye01,
        rye02       LIKE rye_file.rye02,
        rye03       LIKE rye_file.rye03,
        rye03_desc  LIKE aag_file.aag02,
        rye04       LIKE rye_file.rye04,    #FUN-A50065 ADD
        rye04_desc  LIKE aag_file.aag02,    #FUN-A50065 ADD
        rye05       LIKE rye_file.rye05,    #FUN-C90050 add
        ryeacti     LIKE rye_file.ryeacti
                    END RECORD,
    g_rye_t         RECORD
        rye01       LIKE rye_file.rye01,
        rye02       LIKE rye_file.rye02,
        rye03       LIKE rye_file.rye03,
        rye03_desc  LIKE aag_file.aag02,
        rye04       LIKE rye_file.rye04,    #FUN-A50065 ADD
        rye04_desc  LIKE aag_file.aag02,    #FUN-A50065 ADD
        rye05       LIKE rye_file.rye05,    #FUN-C90050 add
        ryeacti     LIKE rye_file.ryeacti
                    END RECORD,
    g_wc2,g_sql     LIKE type_file.chr1000,
    g_rec_b         LIKE type_file.num5,
    l_ac            LIKE type_file.num5
 
DEFINE g_forupd_sql STRING
DEFINE   g_cnt           LIKE type_file.num10
DEFINE   g_i             LIKE type_file.num5
DEFINE g_before_input_done   LIKE type_file.num5
DEFINE p_row,p_col       LIKE type_file.num5
DEFINE l_cmd               LIKE type_file.chr1000
 
MAIN
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)  
         RETURNING g_time  
    LET p_row = 4 LET p_col = 15
    OPEN WINDOW aooi410_w AT p_row,p_col WITH FORM "aoo/42f/aooi410"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL aooi410_b_fill(g_wc2)
    CALL aooi410_menu()
    CLOSE WINDOW aooi410_w     
      CALL  cl_used(g_prog,g_time,2) 
         RETURNING g_time 
END MAIN
 
FUNCTION aooi410_menu()
 DEFINE l_cmd   LIKE type_file.chr1000   
   WHILE TRUE
      CALL aooi410_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL aooi410_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL aooi410_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL aooi410_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document" 
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_rye[l_ac].rye01 IS NOT NULL THEN
                  LET g_doc.column1 = "rye01"
                  LET g_doc.value1 = g_rye[l_ac].rye01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"  
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rye),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION aooi410_q()
   CALL aooi410_b_askkey()
END FUNCTION
 
FUNCTION aooi410_rye03(p_cmd)
DEFINE    l_rye03_desc  LIKE aag_file.aag02,  
          p_cmd         LIKE type_file.chr1
#FUN-A70130 -----------------start-------------------------------------------------
#  IF g_rye[l_ac].rye01='axm' THEN
#     SELECT oaydesc INTO l_rye03_desc FROM oay_file WHERE oayslip = g_rye[l_ac].rye03 AND oayacti='Y'
#  ELSE
#     IF g_rye[l_ac].rye01='alm' THEN
#        SELECT lrkdesc INTO l_rye03_desc FROM lrk_file WHERE lrkslip=g_rye[l_ac].rye03
#     ELSE
#     SELECT smydesc INTO l_rye03_desc FROM smy_file WHERE smyslip = g_rye[l_ac].rye03 AND smyacti='Y'
#     END IF
#  END IF
  #IF g_rye[l_ac].rye01='axm'  or  g_rye[l_ac].rye01='alm'  or  g_rye[l_ac].rye01='art' THEN                        #TQC-B30053
  IF g_rye[l_ac].rye01='axm' OR g_rye[l_ac].rye01='alm' OR g_rye[l_ac].rye01='art' OR g_rye[l_ac].rye01='atm' THEN  #TQC-B30053
     SELECT oaydesc INTO l_rye03_desc FROM oay_file WHERE oayslip = g_rye[l_ac].rye03 AND oayacti='Y'
                                                      AND oaysys = g_rye[l_ac].rye01 
   ELSE
     SELECT smydesc INTO l_rye03_desc FROM smy_file WHERE smyslip = g_rye[l_ac].rye03 AND smyacti='Y'
  END IF  

  
#FUN-A70130 ------------------------end-------------------------------------------- 

  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_rye[l_ac].rye03_desc = l_rye03_desc
     DISPLAY BY NAME g_rye[l_ac].rye03_desc
  END IF
 
END FUNCTION
 
#-------FUN-A50065 ADD--------------------------------------------#
FUNCTION aooi410_rye04(p_cmd)
DEFINE    l_rye04_desc  LIKE aag_file.aag02,  
          p_cmd         LIKE type_file.chr1
#FUN-A70130 -----------------start------------------------------------------------- 
#  IF g_rye[l_ac].rye01='axm' THEN
#     SELECT oaydesc INTO l_rye04_desc FROM oay_file WHERE oayslip = g_rye[l_ac].rye04 AND oayacti='Y'
#  ELSE
#     IF g_rye[l_ac].rye01='alm' THEN
#        SELECT lrkdesc INTO l_rye04_desc FROM lrk_file WHERE lrkslip=g_rye[l_ac].rye04
#     ELSE
#     SELECT smydesc INTO l_rye04_desc FROM smy_file WHERE smyslip = g_rye[l_ac].rye04 AND smyacti='Y'
#     END IF
#  END IF
  #IF g_rye[l_ac].rye01='axm'  or  g_rye[l_ac].rye01='alm'  or  g_rye[l_ac].rye01='art' THEN          #TQC-B30053
  IF g_rye[l_ac].rye01='axm'  OR g_rye[l_ac].rye01='alm'  OR g_rye[l_ac].rye01='art' OR g_rye[l_ac].rye01='atm' THEN  #TQC-B30053
     SELECT oaydesc INTO l_rye04_desc FROM oay_file WHERE oayslip = g_rye[l_ac].rye04 AND oayacti='Y'
                                                      AND oaysys = g_rye[l_ac].rye01
  ELSE
    SELECT smydesc INTO l_rye04_desc FROM smy_file WHERE smyslip = g_rye[l_ac].rye04 AND smyacti='Y'
  END IF


#FUN-A70130 ------------------------end--------------------------------------------  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_rye[l_ac].rye04_desc = l_rye04_desc
     DISPLAY BY NAME g_rye[l_ac].rye04_desc
  END IF
 
END FUNCTION
#-------FUN-A50065 END--------------------------------------------#
 
FUNCTION aooi410_b()
DEFINE
   l_ac_t          LIKE type_file.num5, 
   l_n             LIKE type_file.num5, 
   l_lock_sw       LIKE type_file.chr1, 
   p_cmd           LIKE type_file.chr1, 
   l_allow_insert  LIKE type_file.chr1, 
   l_allow_delete  LIKE type_file.chr1   
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT rye01,rye02,rye03,'',rye04,'',rye05,ryeacti",                 #FUN-A50065    #UFN-C90050 add rye05
                      "  FROM rye_file WHERE rye01=? AND rye02=? AND rye03=? FOR UPDATE"    #FUN-C90050 add rye03=?
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE aooi410_bcl CURSOR FROM g_forupd_sql 
 
   INPUT ARRAY g_rye WITHOUT DEFAULTS FROM s_rye.*
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
             LET p_cmd='u'
             LET g_rye_t.* = g_rye[l_ac].*
 
             LET g_before_input_done = FALSE                                                                                      
             CALL aooi410_set_entry(p_cmd)                                                                                           
             CALL aooi410_set_no_entry(p_cmd)                                                                                        
             LET g_before_input_done = TRUE
             BEGIN WORK
             OPEN aooi410_bcl USING g_rye_t.rye01,g_rye_t.rye02,g_rye_t.rye03          #FUN-C90050 add rye03
             IF STATUS THEN
                CALL cl_err("OPEN aooi410_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH aooi410_bcl INTO g_rye[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_rye_t.rye01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
                CALL aooi410_rye03('a')
                CALL aooi410_rye04('a')    #FUN-A50065 ADD
             END IF
             CALL cl_show_fld_cont()  
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                       
          LET g_before_input_done = FALSE                                                                                         
          CALL aooi410_set_entry(p_cmd)                                                                                              
          CALL aooi410_set_no_entry(p_cmd)                                                                                           
          LET g_before_input_done = TRUE
          INITIALIZE g_rye[l_ac].* TO NULL 
          LET g_rye[l_ac].ryeacti = 'Y'
          LET g_rye_t.* = g_rye[l_ac].*   
          CALL cl_show_fld_cont()   
          NEXT FIELD rye01
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE aooi410_bcl
             CANCEL INSERT
          END IF
          INSERT INTO rye_file(rye01,rye02,rye03,rye04,rye05,ryeacti,ryeoriu,ryeorig)                           #FUN-A50065 ADD rye04    #FUN-C90050 add rye05
         #VALUES(g_rye[l_ac].rye01,g_rye[l_ac].rye02,g_rye[l_ac].rye03,g_rye[l_ac].ryeacti, g_user, g_grup)     #FUN-A50065 MARK   #No.FUN-980030 10/01/04  insert columns oriu, orig
          VALUES(g_rye[l_ac].rye01,g_rye[l_ac].rye02,g_rye[l_ac].rye03,g_rye[l_ac].rye04,                       #FUN-A50065 ADD rye04
                 g_rye[l_ac].rye05,g_rye[l_ac].ryeacti, g_user, g_grup)                                         #FUN-C90050 add rye05
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","rye_file",g_rye[l_ac].rye01,"",SQLCA.sqlcode,"","",1)
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       AFTER FIELD rye01
          IF NOT cl_null(g_rye[l_ac].rye01) AND NOT cl_null(g_rye[l_ac].rye02) THEN
             IF p_cmd = 'a' OR (p_cmd = 'u' AND g_rye[l_ac].rye01!=g_rye_t.rye01) THEN
                SELECT COUNT(*) INTO l_n FROM rye_file WHERE rye01 = g_rye[l_ac].rye01 AND rye02 = g_rye[l_ac].rye02 
                                                         AND rye03 = g_rye[l_ac].rye03                                       #FUN-C90050 add
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_rye[l_ac].rye01 = g_rye_t.rye01
                   DISPLAY BY NAME g_rye[l_ac].rye01
                   NEXT FIELD rye01
                END IF
             END IF
          END IF
 
        AFTER FIELD rye02
           IF NOT cl_null(g_rye[l_ac].rye02) THEN
 #FUN-A70130--------------------------------start----------------------------------------          
 #             IF g_rye[l_ac].rye01='axm' THEN
 #                SELECT COUNT(*) INTO l_n FROM oay_file WHERE oaytype=g_rye[l_ac].rye02
 #             ELSE
 #                IF g_rye[l_ac].rye01='alm' THEN
 #                   SELECT COUNT(*) INTO l_n FROM lrk_file WHERE lrkkind=g_rye[l_ac].rye02
 #                ELSE
 #                   SELECT COUNT(*) INTO l_n FROM smy_file WHERE smysys=g_rye[l_ac].rye01 AND smykind=g_rye[l_ac].rye02 AND smyacti='Y'
 #                END IF
 #             END IF  
          #IF g_rye[l_ac].rye01='axm'  or  g_rye[l_ac].rye01='alm'  or  g_rye[l_ac].rye01='art' THEN   #TQC-B30053
          IF g_rye[l_ac].rye01='axm'  OR g_rye[l_ac].rye01='alm'  OR g_rye[l_ac].rye01='art' OR g_rye[l_ac].rye01='atm' THEN  #TQC-B30053
             SELECT COUNT(*) INTO l_n FROM oay_file WHERE oaytype=g_rye[l_ac].rye02 AND oaysys = g_rye[l_ac].rye01
          ELSE
             SELECT COUNT(*) INTO l_n FROM smy_file WHERE smysys=g_rye[l_ac].rye01 AND smykind=g_rye[l_ac].rye02 AND smyacti='Y'
          END IF
 #FUN-A70130---------------------------------------end----------------------------------------- 
 
                 IF l_n=0 THEN
                    CALL cl_err('','art-314',0)
                    LET g_rye[l_ac].rye02=g_rye_t.rye02
                    DISPLAY BY NAME g_rye[l_ac].rye02
                    NEXT FIELD rye02
                 ELSE
                    IF p_cmd = 'a' OR (p_cmd = 'u' AND g_rye[l_ac].rye02!=g_rye_t.rye02) THEN
                       IF NOT cl_null(g_rye[l_ac].rye01) THEN
                          SELECT COUNT(*) INTO l_n FROM rye_file WHERE rye01 = g_rye[l_ac].rye01 AND rye02=g_rye[l_ac].rye02
                                                                   AND rye03 = g_rye[l_ac].rye03                                 #UFN-C90050 add
                          IF l_n>0 THEN
                             CALL cl_err('',-239,0)
                             LET g_rye[l_ac].rye02=g_rye_t.rye02
                             DISPLAY BY NAME g_rye[l_ac].rye02
                             NEXT FIELD rye02
                          END IF
                       END IF
                    END IF
                 END IF
           END IF
 
        AFTER FIELD rye03
           IF NOT cl_null(g_rye[l_ac].rye03) THEN
              #FUN-A50065 ADD----------------------------
              IF NOT cl_null(g_rye[l_ac].rye04) THEN
                 IF g_rye[l_ac].rye04=g_rye[l_ac].rye03 THEN
                    CALL cl_err('','apc-121',0)
                    LET g_rye[l_ac].rye03=g_rye_t.rye03
                    DISPLAY BY NAME g_rye[l_ac].rye03
                    NEXT FIELD rye03
                 END IF
              END IF
              #FUN-A50065 END----------------------------
#FUN-A70130---------------------------start----------------------------------------
#              IF g_rye[l_ac].rye01='axm' THEN
#                 SELECT COUNT(*) INTO l_n FROM oay_file WHERE oayslip=g_rye[l_ac].rye03 AND oaytype=g_rye[l_ac].rye02 AND oayacti='Y'
#              ELSE
#                 IF g_rye[l_ac].rye01='alm' THEN
#                    SELECT COUNT(*) INTO l_n FROM lrk_file WHERE lrkkind=g_rye[l_ac].rye02 AND lrkslip=g_rye[l_ac].rye03
#                 ELSE
#                    SELECT COUNT(*) INTO l_n FROM smy_file WHERE smyslip=g_rye[l_ac].rye03 AND smysys=g_rye[l_ac].rye01 AND smykind=g_rye[l_ac].rye02 AND smyacti='Y'
#                 END IF
#              END IF
              #IF g_rye[l_ac].rye01='axm'  or  g_rye[l_ac].rye01='alm'  or  g_rye[l_ac].rye01='art' THEN     #TQC-B30053
              IF g_rye[l_ac].rye01='axm'  OR g_rye[l_ac].rye01='alm'  OR g_rye[l_ac].rye01='art' OR g_rye[l_ac].rye01='atm' THEN  #TQC-B30053
                 SELECT COUNT(*) INTO l_n FROM oay_file WHERE oayslip=g_rye[l_ac].rye03 AND oaytype=g_rye[l_ac].rye02 AND oayacti='Y'
                                                                                         AND oaysys= g_rye[l_ac].rye01
              ELSE
                 SELECT COUNT(*) INTO l_n FROM smy_file WHERE smyslip=g_rye[l_ac].rye03 AND smysys=g_rye[l_ac].rye01 AND smykind=g_rye[l_ac].rye02 AND smyacti='Y'         
              END IF
#FUN-A70130----------------------------end-------------------------------------------
                 IF l_n>0 THEN
                    CALL aooi410_rye03('a')
                 ELSE
                    CALL cl_err('','art-315',0)
                    LET g_rye[l_ac].rye03=g_rye_t.rye03
                    DISPLAY BY NAME g_rye[l_ac].rye03
                    NEXT FIELD rye03
                 END IF
           END IF
 
       #---------------FUN-A50065 ADD---------------------------------------#
        AFTER FIELD rye04
           IF NOT cl_null(g_rye[l_ac].rye04) THEN
              IF NOT cl_null(g_rye[l_ac].rye03) THEN
                 IF g_rye[l_ac].rye04=g_rye[l_ac].rye03 THEN
                    CALL cl_err('','apc-121',0)
                    LET g_rye[l_ac].rye04=g_rye_t.rye04
                    LET g_rye[l_ac].rye04_desc=' '
                    DISPLAY BY NAME g_rye[l_ac].rye04
                    DISPLAY BY NAME g_rye[l_ac].rye04_desc 
                    NEXT FIELD rye04
                 END IF
              END IF
#FUN-A70130----------------------------start-------------------------------------------
#              IF g_rye[l_ac].rye01='axm' THEN
#                 SELECT COUNT(*) INTO l_n FROM oay_file WHERE oayslip=g_rye[l_ac].rye04 AND oaytype=g_rye[l_ac].rye02 AND oayacti='Y'
#              ELSE
#                 IF g_rye[l_ac].rye01='alm' THEN
#                    SELECT COUNT(*) INTO l_n FROM lrk_file WHERE lrkkind=g_rye[l_ac].rye02 AND lrkslip=g_rye[l_ac].rye04
#                 ELSE
#                    SELECT COUNT(*) INTO l_n FROM smy_file WHERE smyslip=g_rye[l_ac].rye04 AND smysys=g_rye[l_ac].rye01
#                                                             AND smykind=g_rye[l_ac].rye02 AND smyacti='Y'
#                 END IF
#              END IF
              #IF g_rye[l_ac].rye01='axm'  or  g_rye[l_ac].rye01='alm'  or  g_rye[l_ac].rye01='art' THEN                        #TQC-B30053
              IF g_rye[l_ac].rye01='axm' OR g_rye[l_ac].rye01='alm' OR g_rye[l_ac].rye01='art' OR g_rye[l_ac].rye01='atm' THEN  #TQC-B30053
                 SELECT COUNT(*) INTO l_n FROM oay_file WHERE oayslip=g_rye[l_ac].rye04 AND oaytype=g_rye[l_ac].rye02 AND oayacti='Y'
                                                                                        AND oaysys=g_rye[l_ac].rye01
              ELSE 
                  SELECT COUNT(*) INTO l_n FROM smy_file WHERE smyslip=g_rye[l_ac].rye04 AND smysys=g_rye[l_ac].rye01
                                                             AND smykind=g_rye[l_ac].rye02 AND smyacti='Y'              
              END IF

#FUN-A70130-----------------------------------end------------------------------------------
              IF l_n>0 THEN
                 CALL aooi410_rye04('a')
              ELSE
                 CALL cl_err('','art-315',0)
                 LET g_rye[l_ac].rye04=g_rye_t.rye04
                 LET g_rye[l_ac].rye04_desc=' '
                 DISPLAY BY NAME g_rye[l_ac].rye04
                 DISPLAY BY NAME g_rye[l_ac].rye04_desc 
                 NEXT FIELD rye04
              END IF
           END IF
       #---------------FUN-A50065 END---------------------------------------# 

       #FUN-C90050 add begin---
       AFTER FIELD rye05
          LET l_n = 0 
         #IF p_cmd = 'a' OR (p_cmd = 'u' AND g_rye[l_ac].rye05 <> g_rye_t.rye05) THEN  #FUN-D20097 mark 
          IF NOT cl_null(g_rye[l_ac].rye05) THEN
             SELECT COUNT(*) INTO l_n FROM azp_file WHERE azp01 = g_rye[l_ac].rye05
             IF l_n = 0 THEN
                CALL cl_err('','art-044',0)
                NEXT FIELD rye05
             ELSE
                SELECT COUNT(*) INTO l_n FROM rye_file WHERE rye01 = g_rye[l_ac].rye01 AND rye02 = g_rye[l_ac].rye02 AND rye05 = g_rye[l_ac].rye05
                IF l_n > 0 THEN 
                   CALL cl_err('','aoo-429',0) 
                   NEXT FIELD rye05
                END IF
             END IF
          ELSE
              SELECT COUNT(*) INTO l_n  FROM rye_file WHERE rye01 = g_rye[l_ac].rye01 AND rye02 = g_rye[l_ac].rye02 AND rtrim(rye05) IS NULL
              IF l_n > 0 THEN 
                 CALL cl_err('','aoo-430',0) 
                 NEXT FIELD rye05
              END IF
          END IF
         #END IF  #FUN-D20097 mark 
       #FUN-C90050 add end-----

       BEFORE DELETE
          IF g_rye_t.rye01 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "rye01"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_rye[l_ac].rye01      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM rye_file WHERE rye01 = g_rye_t.rye01 AND rye02 = g_rye_t.rye02 AND rye03 = g_rye_t.rye03     #FUN-C90050 add rye03
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","rye_file",g_rye_t.rye01,"",SQLCA.sqlcode,"","",1) 
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
             LET g_rye[l_ac].* = g_rye_t.*
             CLOSE aooi410_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_rye[l_ac].rye01,-263,0)
             LET g_rye[l_ac].* = g_rye_t.*
          ELSE
             UPDATE rye_file SET rye01=g_rye[l_ac].rye01,
                                 rye02=g_rye[l_ac].rye02,
                                 rye03=g_rye[l_ac].rye03,
                                 rye04=g_rye[l_ac].rye04,              #FUN-A50065 add
                                 rye05=g_rye[l_ac].rye05,              #FUN-C90050 add
                                 ryeacti=g_rye[l_ac].ryeacti
              WHERE rye01 = g_rye_t.rye01 AND rye02 = g_rye_t.rye02
                AND rye03 = g_rye_t.rye03                              #FUN-C90050 add rye03
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","rye_file",g_rye_t.rye01,"",SQLCA.sqlcode,"","",1)
                LET g_rye[l_ac].* = g_rye_t.*
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
                LET g_rye[l_ac].* = g_rye_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_rye.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
             END IF
             CLOSE aooi410_bcl    
             ROLLBACK WORK   
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac  #FUN-D40030       
 
          CLOSE aooi410_bcl    
          COMMIT WORK
 
       ON ACTION CONTROLO            
          IF INFIELD(rye01) AND l_ac > 1 THEN
             LET g_rye[l_ac].* = g_rye[l_ac-1].*
             NEXT FIELD rye01
          END IF
 
       ON ACTION controlp
        CASE
           WHEN INFIELD(rye02)
              CALL cl_init_qry_var()
            #FUN-A10109 modify begin
              #IF g_rye[l_ac].rye01='axm' THEN
              #   LET g_qryparam.form = "q_oaytype"
              #   LET g_qryparam.arg1 = g_lang 
              #   LET g_qryparam.default1 = g_rye[l_ac].rye02
              #   CALL cl_create_qry() RETURNING g_rye[l_ac].rye02
              #ELSE
              #   IF g_rye[l_ac].rye01='alm' THEN
              #      LET g_qryparam.form = "q_lrkkind"
              #      LET g_qryparam.arg1 = g_lang
              #      LET g_qryparam.default1 = g_rye[l_ac].rye02
              #      CALL cl_create_qry() RETURNING g_rye[l_ac].rye02
              #   ELSE
              #      CALL q_kind(FALSE, FALSE, g_rye[l_ac].rye01,g_rye[l_ac].rye02)
              #      RETURNING g_rye[l_ac].rye02
              #   END IF
              #END IF
              LET g_qryparam.form = "q_gee02"      
              LET g_qryparam.arg1 = g_rye[l_ac].rye01   #模組別
              LET g_qryparam.arg2 =  g_lang             #語言別
              LET g_qryparam.default1 = g_rye[l_ac].rye02
              CALL cl_create_qry() RETURNING g_rye[l_ac].rye02
             #FUN-A10109 modify end 

              DISPLAY BY NAME g_rye[l_ac].rye02
              NEXT FIELD rye02
           WHEN INFIELD(rye03)
              CALL cl_init_qry_var()
#FUN-A70130 -------------------------start-------------------------------
#              IF g_rye[l_ac].rye01='axm' THEN
#                 LET g_qryparam.form = "q_oayslip"
#                 LET g_qryparam.arg1 = g_rye[l_ac].rye02
#              ELSE
#                 IF g_rye[l_ac].rye01='alm' THEN
#                    LET g_qryparam.form="q_lrkslip"
#                    LET g_qryparam.arg1=g_rye[l_ac].rye02
#                 ELSE
#                    LET g_qryparam.form = "q_smyslip1"
#                    LET g_qryparam.arg1 = g_rye[l_ac].rye01
#                    LET g_qryparam.arg2 = g_rye[l_ac].rye02
#                 END IF
#              END IF
            #IF g_rye[l_ac].rye01='axm'  or  g_rye[l_ac].rye01='alm'  or  g_rye[l_ac].rye01='art' THEN                        #TQC-B30053
            IF g_rye[l_ac].rye01='axm' OR g_rye[l_ac].rye01='alm' OR g_rye[l_ac].rye01='art' OR g_rye[l_ac].rye01='atm' THEN  #TQC-B30053
               LET g_qryparam.form = "q_oayslip"
               LET g_qryparam.arg1 = g_rye[l_ac].rye02
               LET g_qryparam.arg2 = g_rye[l_ac].rye01
            ELSE
               LET g_qryparam.form = "q_smyslip1"
               LET g_qryparam.arg1 = g_rye[l_ac].rye01
               LET g_qryparam.arg2 = g_rye[l_ac].rye02
            END IF

#FUN-A70130-----------------------------end-----------------------------
              LET g_qryparam.default1 = g_rye[l_ac].rye03
              CALL cl_create_qry() RETURNING g_rye[l_ac].rye03
              DISPLAY BY NAME g_rye[l_ac].rye03
              CALL aooi410_rye03('a')
              NEXT FIELD rye03
           #FUN-A50065 ADD------------------------#
           WHEN INFIELD(rye04)
              CALL cl_init_qry_var()
#FUN-A70130--------------------start--------------------------
#              IF g_rye[l_ac].rye01='axm' THEN
#                 LET g_qryparam.form = "q_oayslip"
#                 LET g_qryparam.arg1 = g_rye[l_ac].rye02
#              ELSE
#                 IF g_rye[l_ac].rye01='alm' THEN
#                    LET g_qryparam.form="q_lrkslip"
#                    LET g_qryparam.arg1=g_rye[l_ac].rye02
#               ELSE
#                    LET g_qryparam.form = "q_smyslip1"
#                    LET g_qryparam.arg1 = g_rye[l_ac].rye01
#                    LET g_qryparam.arg2 = g_rye[l_ac].rye02
#                 END IF
#              END IF
               #IF g_rye[l_ac].rye01='axm'  or  g_rye[l_ac].rye01='alm'  or  g_rye[l_ac].rye01='art' THEN
               IF g_rye[l_ac].rye01='axm' OR g_rye[l_ac].rye01='alm' OR g_rye[l_ac].rye01='art' OR g_rye[l_ac].rye01='atm' THEN  #TQC-B30053
                 LET g_qryparam.form = "q_oayslip"
                 LET g_qryparam.arg1 = g_rye[l_ac].rye02
                 LET g_qryparam.arg2 = g_rye[l_ac].rye01
               ELSE
                 LET g_qryparam.form = "q_smyslip1"
                 LET g_qryparam.arg1 = g_rye[l_ac].rye01
                 LET g_qryparam.arg2 = g_rye[l_ac].rye02
               END IF
#FUN-A70130------------------------end-------------------------------
              LET g_qryparam.default1 = g_rye[l_ac].rye04
              CALL cl_create_qry() RETURNING g_rye[l_ac].rye04
              DISPLAY BY NAME g_rye[l_ac].rye04
              CALL aooi410_rye04('a')
              NEXT FIELD rye04
           #FUN-A50065 END-------------------------#
           #FUN-C90050 begin---
           WHEN INFIELD(rye05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azp"
              LET g_qryparam.default1 = g_rye[l_ac].rye05
              CALL cl_create_qry() RETURNING g_rye[l_ac].rye05
              DISPLAY BY NAME g_rye[l_ac].rye05
              NEXT FIELD rye05
           OTHERWISE
              EXIT CASE
        END CASE
 
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
 
       
   END INPUT
 
   CLOSE aooi410_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION aooi410_b_askkey()
 
   CLEAR FORM
   CALL g_rye.clear()
   CONSTRUCT g_wc2 ON rye01,rye02,rye03,rye04,rye05,ryeacti                                                   #FUN-A50065 ADD   #FUN-C90050 add rye05
        FROM s_rye[1].rye01,s_rye[1].rye02,s_rye[1].rye03,s_rye[1].rye04,s_rye[1].rye05,s_rye[1].ryeacti      #FUN-C90050 add rye05
 
 
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
 
      ON ACTION controlp
        CASE
           WHEN INFIELD(rye02)
              CALL cl_init_qry_var()
             #LET g_qryparam.form = "q_oaytype"    #TQC-A10112 MARK
            #FUN-A10109 modify begin
              #LET g_qryparam.form = "q_rye02"      #TQC-A10112 ADD
         #    LET g_qryparam.form = "q_gee02"       #TQC-A90052 mark
              LET g_qryparam.form = "q_gee02"       #TQC-AB0241
              LET g_qryparam.arg1 = GET_FLDBUF(rye01) #模組別
              LET g_qryparam.arg2 =  g_lang           #語言別
            #FUN-A10109 modify end
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO rye02
              NEXT FIELD rye02
           WHEN INFIELD(rye03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_oayslip"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO rye03
              CALL aooi410_rye03('a')
              NEXT FIELD rye03
           #FUN-A50065 ADD-----------------------------#
           WHEN INFIELD(rye04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_oayslip"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO rye04
              CALL aooi410_rye04('a')
              NEXT FIELD rye04
           #FUN-A50065 END-----------------------------#
           #FUN-C90050 add begin---
           WHEN INFIELD(rye05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azp"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO rye05
              NEXT FIELD rye05           
           #FUN-C90050 add end-----
           OTHERWISE
              EXIT CASE
        END CASE
 
      ON ACTION qbe_select
         CALL cl_qbe_select() 
      ON ACTION qbe_save
	 CALL cl_qbe_save()
 
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('ryeuser', 'ryegrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
 
   CALL aooi410_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION aooi410_b_fill(p_wc2)   
DEFINE
    p_wc2           LIKE type_file.chr1000 
 
    LET g_sql =
        "SELECT rye01,rye02,rye03,'',rye04,'',rye05,ryeacti",     #FUN-A50065 ADD rye04    #FUN-C90050 add rye05
        " FROM rye_file ",
        " WHERE ", p_wc2 CLIPPED,      
       #" ORDER BY 1"        #FUN-A50065 MARK
        " ORDER BY rye01"
    PREPARE aooi410_pb FROM g_sql
    DECLARE rye_curs CURSOR FOR aooi410_pb
 
    CALL g_rye.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH rye_curs INTO g_rye[g_cnt].* 
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#FUN-A70130-------------------------------------start---------------------------
#        IF g_rye[g_cnt].rye01='axm' THEN
#           SELECT oaydesc INTO g_rye[g_cnt].rye03_desc FROM oay_file WHERE oayslip = g_rye[g_cnt].rye03 AND oayacti = 'Y'
#        ELSE
#           IF g_rye[g_cnt].rye01='alm' THEN
#              SELECT lrkdesc INTO g_rye[g_cnt].rye03_desc FROM lrk_file 
#               WHERE lrkslip=g_rye[g_cnt].rye03 
#           ELSE
#           SELECT smydesc INTO g_rye[g_cnt].rye03_desc FROM smy_file WHERE smyslip = g_rye[g_cnt].rye03 AND smyacti = 'Y'
#           END IF
#        END IF
      #IF g_rye[g_cnt].rye01='axm'  or  g_rye[g_cnt].rye01='alm'  or  g_rye[g_cnt].rye01='art' THEN                        #TQC-B30053
      IF g_rye[g_cnt].rye01='axm' OR g_rye[g_cnt].rye01='alm' OR g_rye[g_cnt].rye01='art' OR g_rye[g_cnt].rye01='atm' THEN  #TQC-B30053
         SELECT oaydesc INTO g_rye[g_cnt].rye03_desc FROM oay_file WHERE oayslip = g_rye[g_cnt].rye03 AND oayacti = 'Y'
                                                                    AND oaysys = g_rye[g_cnt].rye01
      ELSE
          SELECT smydesc INTO g_rye[g_cnt].rye03_desc FROM smy_file WHERE smyslip = g_rye[g_cnt].rye03 AND smyacti = 'Y'
      END IF

#FUN-A70130-------------------------------------end---------------------------------
#FUN-A70130-------------------------------------start--------------------------------------
        #------------------FUN-A50065 ADD--------------------------------------------------#
#        IF g_rye[g_cnt].rye01='axm' THEN
#           SELECT oaydesc INTO g_rye[g_cnt].rye04_desc FROM oay_file WHERE oayslip = g_rye[g_cnt].rye04 AND oayacti = 'Y'
#        ELSE
#           IF g_rye[g_cnt].rye01='alm' THEN
#              SELECT lrkdesc INTO g_rye[g_cnt].rye04_desc FROM lrk_file 
#               WHERE lrkslip=g_rye[g_cnt].rye04 
#           ELSE
#           SELECT smydesc INTO g_rye[g_cnt].rye04_desc FROM smy_file WHERE smyslip = g_rye[g_cnt].rye04 AND smyacti = 'Y'
#           END IF
#        END IF
        #------------------FUN-A50065 END--------------------------------------------------#
       #IF g_rye[g_cnt].rye01='axm'  or  g_rye[g_cnt].rye01='alm'  or  g_rye[g_cnt].rye01='art' THEN
       IF g_rye[g_cnt].rye01='axm' OR g_rye[g_cnt].rye01='alm' OR g_rye[g_cnt].rye01='art' OR g_rye[g_cnt].rye01='atm' THEN  #TQC-B30053
          SELECT oaydesc INTO g_rye[g_cnt].rye04_desc FROM oay_file WHERE oayslip = g_rye[g_cnt].rye04 AND oayacti = 'Y'
                                                                    AND oaysys =  g_rye[g_cnt].rye01
       ELSE
          SELECT smydesc INTO g_rye[g_cnt].rye04_desc FROM smy_file WHERE smyslip = g_rye[g_cnt].rye04 AND smyacti = 'Y'
       END IF
   
##FUN-A70130------------------------------------------end----------------------------------------
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_rye.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION aooi410_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rye TO s_rye.* ATTRIBUTE(COUNT=g_rec_b)
 
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
      ON ACTION output
         LET g_action_choice="output"
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
 
FUNCTION aooi410_set_entry(p_cmd)
        DEFINE p_cmd LIKE type_file.chr1
        IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
           CALL cl_set_comp_entry("rye01,rye02",TRUE)
        END IF
END FUNCTION
 
FUNCTION aooi410_set_no_entry(p_cmd)
        DEFINE p_cmd LIKE type_file.chr1
        IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("rye01,rye02",FALSE)
        END IF
END FUNCTION
 
FUNCTION aooi410_out()
#p_query
DEFINE l_cmd  STRING
 
    IF cl_null(g_wc2) THEN
       CALL cl_err('','9057',0) RETURN
    END IF
    LET l_cmd = 'p_query "aooi410" "',g_wc2 CLIPPED,'"'
    CALL cl_cmdrun(l_cmd)
 
END FUNCTION
#No.FUN-9B0025 PASS NO.
