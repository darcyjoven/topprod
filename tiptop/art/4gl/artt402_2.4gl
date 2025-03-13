# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
#Pattern name..:"artt402_2.4gl"
#Descriptions..:會員等級促銷變更維護作業
#Date & Author...: No.FUN-A70048 10/07/25 By Cockroach 
# Modify.........: No.MOD-AC0176 10/12/18 By shenyang 修改5.25CT1 bug
# Modify.........: No.MOD-AC0189 10/12/20 By shenyang 修改5.25CT1 bug
# Modify.........: No.TQC-B30183 11/03/25 By huangtao 組合促銷時，不顯示組別 
# Modify.........: No.FUN-BC0058 11/12/22 By yangxf lpf_file 改用 lpc_file,q_lpf改用q_lpc01_1
# Modify.........: No.FUN-BC0072 11/12/20 By pauline GP5.3 artt402 一般促銷變更單促銷功能優化
# Modify.........: No.TQC-C20328 12/02/21 By pauline 增加artt402_2參數,增加傳入組別,AFTER FIELD rbp07時判斷輸入組別不同時才進入SELECT COUNT
#                                                    判斷是輸入的組別是否為相同的會員促銷方式
# Modify.........: No.TQC-C20398 12/02/22 By pauline 會員類型/會員等級/會員卡種 開放可修改
# Modify.........: No.TQC-C20427 12/02/23 By pauline 新增rap09當key值 
# Modify.........: No:FUN-D30033 13/04/18 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_rbp   DYNAMIC ARRAY OF RECORD 
                type            LIKE type_file.chr1,

                before          LIKE rbp_file.rbp06,
                rbp07_1         LIKE rbp_file.rbp07,
                rbp08_1         LIKE rbp_file.rbp08,
#               rbp08_1_desc    LIKE lpf_file.lpf02,      #FUN-BC0058 mark
                rbp08_1_desc    LIKE lpc_file.lpc02,      #FUN-BC0058        
                rbp09_1         LIKE rbp_file.rbp09,
                rbp10_1         LIKE rbp_file.rbp10,
                rbp11_1         LIKE rbp_file.rbp11,
                rbpacti_1       LIKE rbp_file.rbpacti,

                after           LIKE rbp_file.rbp06,
                rbp07           LIKE rbp_file.rbp07,
                rbp08           LIKE rbp_file.rbp08,
#               rbp08_desc      LIKE lpf_file.lpf02,      #FUN-BC0058 mark      
                rbp08_desc      LIKE lpc_file.lpc02,      #FUN-BC0058   
                rbp09           LIKE rbp_file.rbp09,
                rbp10           LIKE rbp_file.rbp10,
                rbp11           LIKE rbp_file.rbp11,
                rbpacti         LIKE rbp_file.rbpacti
                        END RECORD,
        g_rbp_t RECORD
                type            LIKE type_file.chr1,

                before          LIKE rbp_file.rbp06,
                rbp07_1         LIKE rbp_file.rbp07,
                rbp08_1         LIKE rbp_file.rbp08,
#               rbp08_1_desc    LIKE lpf_file.lpf02,        #FUN-BC0058 mark
                rbp08_1_desc    LIKE lpc_file.lpc02,        #FUN-BC0058       
                rbp09_1         LIKE rbp_file.rbp09,
                rbp10_1         LIKE rbp_file.rbp10,
                rbp11_1         LIKE rbp_file.rbp11,
                rbpacti_1       LIKE rbp_file.rbpacti,

                after           LIKE rbp_file.rbp06,
                rbp07           LIKE rbp_file.rbp07,
                rbp08           LIKE rbp_file.rbp08,
#               rbp08_desc      LIKE lpf_file.lpf02,         #FUN-BC0058 mark
                rbp08_desc      LIKE lpc_file.lpc02,         #FUN-BC0058     
                rbp09           LIKE rbp_file.rbp09,
                rbp10           LIKE rbp_file.rbp10,
                rbp11           LIKE rbp_file.rbp11,
                rbpacti         LIKE rbp_file.rbpacti
                        END RECORD
DEFINE   g_sql   STRING,
         g_wc    STRING,
         g_rec_b LIKE type_file.num5,
         l_ac    LIKE type_file.num5
DEFINE  p_row,p_col     LIKE type_file.num5
DEFINE  g_forupd_sql    STRING
DEFINE  g_cnt           LIKE type_file.num10
DEFINE  g_argv1         LIKE rbp_file.rbp01,
        g_argv2         LIKE rbp_file.rbp02,
        g_argv3         LIKE rbp_file.rbp03,
        g_argv4         LIKE rbp_file.rbp04,
        g_argv5         LIKE rbp_file.rbpplant,
        g_argv6         LIKE rbb_file.rbbconf,
        g_argv7         LIKE rah_file.rah10, #促銷方式
        g_argv8         LIKE rbc_file.rbc11, #FUN-BC0072 add
        g_argv9         LIKE rbc_file.rbc06  #TQC-C20328 add
DEFINE g_legal LIKE azw_file.azw01
 
#FUNCTION t402_2(p_argv1,p_argv2,p_argv3,p_argv4,p_argv5,p_argv6,p_argv7)  #FUN-BC0072 mark
FUNCTION t402_2(p_argv1,p_argv2,p_argv3,p_argv4,p_argv5,p_argv6,p_argv7,p_argv8,p_argv9)  #FUN-BC0072 add   #TQC-C20328 add p_argv9
DEFINE  p_argv1         LIKE rbp_file.rbp01,    #制定機構
        p_argv2         LIKE rbp_file.rbp02,    #促銷單號
        p_argv3         LIKE rbp_file.rbp03,    #異動序號
        p_argv4         LIKE rbp_file.rbp04,    #促銷類型
        p_argv5         LIKE rbp_file.rbpplant, #所屬機構
        p_argv6         LIKE rbb_file.rbbconf,  #審核碼
        p_argv7         LIKE rah_file.rah10,    #促銷方式
        p_argv8         LIKE rbc_file.rbc11,    #FUN-BC0072 add  #會員促銷方式 
        p_argv9         LIKE rbc_file.rbc06     #TQC-C20328 add  #組別
#FUN-BC0072 add START
DEFINE  l_title         LIKE ze_file.ze03
#FUN-BC0072 add END
    WHENEVER ERROR CALL cl_err_msg_log
    LET g_argv1 = p_argv1
    LET g_argv2 = p_argv2
    LET g_argv3 = p_argv3
    LET g_argv4 = p_argv4
    LET g_argv5 = p_argv5
    LET g_argv6 = p_argv6
    LET g_argv7 = p_argv7
    LET g_argv8 = p_argv8   #FUN-BC0072 add
    LET g_argv9 = p_argv9   #TQC-C20328 add
    SELECT azw02 INTO g_legal FROM azw_file WHERE azw01=g_argv5
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW t402_2_w AT p_row,p_col WITH FORM "art/42f/artt402_2"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_locale("artt402_2")
#TQC-B30183 ----------------STA
    IF g_argv4 = '2' THEN
      CALL cl_set_comp_visible("dummy02,rbp07,rbp07_1",FALSE)
    END IF
#TQC-B30183 ----------------END
    #bnl add beg
    IF NOT cl_null(g_argv7) THEN
     # IF g_argv7 = '1' THEN
     #    CALL cl_set_comp_visible("rbp10,rbp11",FALSE)
     #    CALL cl_set_comp_visible("rbp09",TRUE)
     # END IF   
     # IF g_argv7 = '2' THEN
     #    CALL cl_set_comp_visible("rbp09,rbp11",FALSE)
     #    CALL cl_set_comp_visible("rbp10",TRUE)
     # END IF   
     # IF g_argv7 = '3' THEN
     #    CALL cl_set_comp_visible("rbp09,rbp10",FALSE)
     #    CALL cl_set_comp_visible("rbp11",TRUE)
     # END IF   
    END IF
    #bnl add end
#FUN-BC0072 add START
    LET l_title = ' '
    CASE g_argv8
       WHEN '1'
          SELECT ze03 INTO l_title FROM ze_file WHERE ze01= 'art-774' AND ze02= g_lang
       WHEN '2'
          SELECT ze03 INTO l_title FROM ze_file WHERE ze01= 'art-775' AND ze02= g_lang
       WHEN '3'
          SELECT ze03 INTO l_title FROM ze_file WHERE ze01= 'art-776' AND ze02= g_lang
    END CASE
    CALL cl_set_comp_lab_text("dummy03",l_title)
    IF NOT cl_null(g_argv7) THEN
       IF g_argv7 = '1' THEN
          CALL cl_set_comp_entry("rbp10,rbp11",FALSE)
          CALL cl_set_comp_entry("rbp09",TRUE)
       END IF
       IF g_argv7 = '2' THEN
          CALL cl_set_comp_entry("rbp09,rbp11",FALSE)
          CALL cl_set_comp_entry("rbp10",TRUE)
       END IF
       IF g_argv7 = '3' THEN
          CALL cl_set_comp_entry("rbp09,rbp10",FALSE)
          CALL cl_set_comp_entry("rbp11",TRUE)
       END IF
       IF g_argv7 = '4' THEN
          CALL cl_set_comp_entry("rbp09,rbp10",FALSE)
          CALL cl_set_comp_entry("rbp11",TRUE)
       END IF
    END IF
#FUN-BC0072 add END
    LET g_wc = " 1=1"
    CALL t402_2_b_fill(g_wc)
    IF g_argv6='N' THEN
    LET l_ac=g_rec_b+1
    CALL t402_2_b()
    END IF
    CALL t402_2_menu()
 
    CLOSE WINDOW t402_2_w
END FUNCTION
 
FUNCTION t402_2_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_rbp TO s_rbp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
        CALL cl_navigator_setting(0,0)
        
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
            
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      AFTER DISPLAY
         CONTINUE DISPLAY
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t402_2_menu()
 
   WHILE TRUE
      CALL t402_2_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t402_2_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t402_2_b()
            ELSE
               LET g_action_choice = NULL
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
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_rbp),'','')
             END IF        
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t402_2_q()
 
   CALL t402_2_b_askkey()
   
END FUNCTION
 
FUNCTION t402_2_b_askkey()
 
    CLEAR FORM
  
    CONSTRUCT g_wc ON b.rbp07,b.rbp08,b.rbp09,b.rbp10,b.rbp11,b.rbpacti
                    FROM s_rbp[1].rbp07,s_rbp[1].rbp08,s_rbp[1].rbp09,
                         s_rbp[1].rbp10,s_rbp[1].rbp11,s_rbp[1].rbpacti
 
           ON ACTION controlp
           CASE
              WHEN INFIELD(rbp08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rbp08"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rbp08
                 NEXT FIELD rbp08
 
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) 
    
    IF INT_FLAG THEN 
        RETURN
    END IF
 
    CALL t402_2_b_fill(g_wc)
    
END FUNCTION

FUNCTION t402_2_rbp_entry(p_rbp07)
DEFINE p_rbp07    LIKE rbp_file.rbp07
DEFINE l_rac04    LIKE rac_file.rac04


  CASE g_argv4
     WHEN '1'
        SELECT rac04 INTO l_rac04 FROM rac_file
         WHERE rac01=g_argv1 AND rac02=g_argv2
           AND racplant=g_argv5 AND rac03 = p_rbp07
           AND racacti='Y' AND rac08='Y'
    #WHEN '2'
     OTHERWISE
        LET l_rac04=' '
  END CASE

          CASE l_rac04
             WHEN '1'
                CALL cl_set_comp_entry("rbp09",TRUE)
                CALL cl_set_comp_entry("rbp10",FALSE)
                CALL cl_set_comp_entry("rbp11",FALSE)
                CALL cl_set_comp_required("rbp09",TRUE)
             WHEN '2'
                CALL cl_set_comp_entry("rbp09",FALSE)
                CALL cl_set_comp_entry("rbp10",TRUE)
                CALL cl_set_comp_entry("rbp11",FALSE)
                CALL cl_set_comp_required("rbp10",TRUE)
             WHEN '3'
                CALL cl_set_comp_entry("rbp09",FALSE)
                CALL cl_set_comp_entry("rbp10",FALSE)
                CALL cl_set_comp_entry("rbp11",TRUE)
                CALL cl_set_comp_required("rbp11",TRUE)
             OTHERWISE
                CALL cl_set_comp_entry("rbp09",TRUE)
                CALL cl_set_comp_entry("rbp10",TRUE)
                CALL cl_set_comp_entry("rbp11",TRUE)
                CALL cl_set_comp_required("rbp09",TRUE)
                CALL cl_set_comp_required("rbp10",TRUE)
                CALL cl_set_comp_required("rbp11",TRUE)
          END CASE
END FUNCTION 

FUNCTION t402_2_rbp07()         
DEFINE l_n     LIKE type_file.num5
DEFINE l_racacti     LIKE rac_file.racacti
DEFINE l_rac04       LIKE rac_file.rac04   #組別
DEFINE l_rac08       LIKE rac_file.rac08   #依會員等級促銷否

   LET g_errno = ' '
   LET l_n=0

   CASE g_argv4
      WHEN '1'
         SELECT rbc07,rbc11,rbcacti INTO l_rac04,l_rac08,l_racacti FROM rbc_file
          WHERE rbc01 = g_argv1 AND rbc02 = g_argv2
            AND rbc03 = g_argv3 AND rbcplant=g_argv5
            AND rbc06 = g_rbp[l_ac].rbp07 AND rbc05='1'

        IF SQLCA.sqlcode=100 THEN
           SELECT rac04,rac08,racacti INTO l_rac04,l_rac08,l_racacti FROM rac_file
            WHERE rac01=g_argv1 AND rac02=g_argv2
              AND racplant=g_argv5 AND rac03 = g_rbp[l_ac].rbp07
        END IF

    # WHEN '2'
    #    SELECT rae10,rae12,rafacti INTO l_rac04,l_rac08,l_racacti FROM rae_file,raf_file
    #     WHERE rae01=g_argv1 AND rae02=g_argv2
    #       AND rae01 =raf01  AND rae02 = raf02 
    #       AND raeplant = rafplant
    #       AND raeplant=g_argv5 AND raf03 = g_rbp[l_ac].rbp07
    # WHEN '3'    
    #    SELECT rah10,rai07,raiacti INTO l_rac04,l_rac08,l_racacti FROM rai_file,rah_file
    #     WHERE rah01 = rai01 AND rah02 = rai02 AND rahplant = raiplant AND rai01=g_argv1 AND rai02=g_argv2
    #       AND raiplant=g_argv5 AND rai03 = g_rbp[l_ac].rbp07
#MOD-AC0189--add--begin 
     WHEN '2'
        SELECT rbe10t,rbe12t,rbeacti INTO l_rac04,l_rac08,l_racacti FROM rbe_file
         WHERE rbe01=g_argv1 AND rbe02=g_argv2  AND rbe03 = g_argv3
           AND rbeplant=g_argv5 
    WHEN '3'
       SELECT rbh10t,rbi07,rbiacti INTO l_rac04,l_rac08,l_racacti FROM rbi_file,rbh_file
        WHERE rbh01 = rbi01 AND rbh02 = rbi02 AND rbhplant = rbiplant AND rbi01=g_argv1 AND rbh03 = g_argv3 AND rbi03 = g_argv3
        AND rbi02=g_argv2 AND rbiplant=g_argv5 AND rbi06 = g_rbp[l_ac].rbp07 AND rbi05='1'
      IF SQLCA.sqlcode=100 THEN
         SELECT rah10,rai07,raiacti INTO l_rac04,l_rac08,l_racacti FROM rai_file,rah_file
        WHERE rah01 = rai01 AND rah02 = rai02 AND rahplant = raiplant AND rai01=g_argv1
        AND rai02=g_argv2 AND raiplant=g_argv5 AND rai03 = g_rbp[l_ac].rbp07
      END IF
#MOD-AC0189--add--end
   END CASE
   CASE                          
         WHEN SQLCA.sqlcode=100   LET g_errno = 'art-654' 
         WHEN l_rac08='N'         LET g_errno = 'art-655' 
         WHEN l_racacti='N'       LET g_errno = '9028' 
         OTHERWISE   
         LET g_errno=SQLCA.sqlcode USING '------' 
   END CASE   
   IF l_rac04 = '1' THEN
      CALL cl_set_comp_entry("rbp10,rbp11",FALSE)
      CALL cl_set_comp_entry("rbp09",TRUE)
      CALL cl_set_comp_required("rbp09",TRUE)
      LET g_rbp[l_ac].rbp10=100              #NO.MOD-AC0176
      LET g_rbp[l_ac].rbp11=0                #NO.MOD-AC0176
   END IF   
   IF l_rac04 = '2' THEN
      CALL cl_set_comp_entry("rbp09,rbp11",FALSE)
      CALL cl_set_comp_entry("rbp10",TRUE)
      CALL cl_set_comp_required("rbp10",TRUE) 
      LET g_rbp[l_ac].rbp09=0                #NO.MOD-AC0176
      LET g_rbp[l_ac].rbp11=0                #NO.MOD-AC0176
   END IF   
   IF l_rac04 = '3' THEN
      CALL cl_set_comp_entry("rbp09,rbp10",FALSE)
      CALL cl_set_comp_entry("rbp11",TRUE)
      CALL cl_set_comp_required("rbp11",TRUE)
      LET g_rbp[l_ac].rbp09=0                #NO.MOD-AC0176
      LET g_rbp[l_ac].rbp10=100              #NO.MOD-AC0176
   END IF   
  #FUN-BC0072 add START
   IF l_rac04 = '4' THEN
      CALL cl_set_comp_entry("rbp09,rbp10",FALSE)
      CALL cl_set_comp_entry("rbp11",TRUE)
      CALL cl_set_comp_required("rbp11",TRUE)
      LET g_rbp[l_ac].rbp09=0                #NO.MOD-AC0176
      LET g_rbp[l_ac].rbp10=100              #NO.MOD-AC0176
   END IF
  #FUN-BC0072 add END
  #bnl add end
END FUNCTION

FUNCTION t402_2_rbp08(p_cmd)         
DEFINE    p_cmd   STRING,
#         l_rbp08_desc LIKE lpf_file.lpf02      #FUN-BC0058 mark
          l_rbp08_desc LIKE lpc_file.lpc02      #FUN-BC0058
DEFINE l_n LIKE type_file.num5
          
   LET g_errno = ' '
#FUN-BC0058 mark---   
#  SELECT lpf02 INTO l_rbp08_desc FROM lpf_file
#   WHERE lpf01 = g_rbp[l_ac].rbp08 AND lpf05='Y'
#FUN-BC0058 mark---
#FUN-BC0058 ---begin---
#FUN-BC0072 mark START
#  SELECT lpc02 INTO l_rbp08_desc FROM lpc_file
#   WHERE lpc01 = g_rbp[l_ac].rbp08 AND lpcacti = 'Y' AND lpc00 = '6'
#FUN-BC0072 mark END
#FUN-BC0072 add START
   CASE g_argv8
      WHEN '1'
         SELECT lpc02 INTO l_rbp08_desc FROM lpc_file
          WHERE lpc01 = g_rbp[l_ac].rbp08 AND lpc00 = '6'
      WHEN '2'
         SELECT lpc02 INTO l_rbp08_desc FROM lpc_file
          WHERE lpc01 = g_rbp[l_ac].rbp08 AND lpc00 = '7'
      WHEN '3'
         SELECT lph02 INTO l_rbp08_desc FROM lph_file
          WHERE lph01 = g_rbp[l_ac].rbp08 AND lph24 = 'Y'  AND lphacti = 'Y'
   END CASE
#FUN-BC0072 add END
#FUN-BC0058 ---end---
  CASE                          
       #WHEN SQLCA.sqlcode=100   LET g_errno = 'art-002'  #FUN-BC0072 mark
        WHEN SQLCA.sqlcode=100   LET g_errno = 'art-138'  #FUN-BC0072 add
  
                                 LET l_rbp08_desc = NULL 
        OTHERWISE   
        LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
 #IF cl_null(g_errno) THEN
 #   SELECT COUNT(*) INTO l_n FROM lpf_file
 #    WHERE azp01 IN (SELECT azw01 FROM azw_file WHERE azw07=g_argv5 OR azw01=g_argv5)
 #      AND azp01 = g_rbp[l_ac].rbp07
 #   IF l_n=0 THEN
 #      LET g_errno='art-500'
 #   END IF
 #END IF 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_rbp[l_ac].rbp08_desc=l_rbp08_desc
     DISPLAY BY NAME g_rbp[l_ac].rbp08_desc
  END IF
 
END FUNCTION
 
FUNCTION t402_2_b_fill(p_wc)              
DEFINE   p_wc       STRING        
 
    LET g_sql = "SELECT '',a.rbp06,a.rbp07,a.rbp08,'',a.rbp09,a.rbp10,a.rbp11,a.rbpacti,",
                "          b.rbp06,b.rbp07,b.rbp08,'',b.rbp09,b.rbp10,b.rbp11,b.rbpacti ",
                "  FROM rbp_file b LEFT OUTER JOIN rbp_file a ON                        ",
                "                  (b.rbp01=a.rbp01 AND b.rbp02=a.rbp02 AND b.rbp03=a.rbp03 AND ",
                "                   b.rbp04=a.rbp04 AND b.rbp05=a.rbp05 AND b.rbp07=a.rbp07 AND ",
                "                   b.rbp08=a.rbp08 AND b.rbpplant=a.rbpplant AND b.rbp06<>a.rbp06 ",
                "                   AND b.rbp12=a.rbp12 )  ", #TQC-C20427 add
                " WHERE b.rbp01='",g_argv1 CLIPPED,"' AND b.rbp02='",g_argv2 CLIPPED,
                "'  AND b.rbp03='",g_argv3 CLIPPED,"' AND b.rbp04='",g_argv4 CLIPPED,
                "'  AND b.rbpplant='",g_argv5 CLIPPED,"'",
                "   AND b.rbp06='1'"     #add by lixia

#FUN-BC0072 add START
    IF NOT cl_null(g_argv8) THEN
       LET g_sql = g_sql ," AND b.rbp12 = ",g_argv8
    END IF
#FUN-BC0072 add END
                
    IF NOT cl_null(p_wc) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc CLIPPED
    END IF

    LET g_sql = g_sql," ORDER BY b.rbp05"
    PREPARE t402_2_pb FROM g_sql
    DECLARE rbp_cs CURSOR FOR t402_2_pb
 
    CALL g_rbp.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH rbp_cs INTO g_rbp[g_cnt].*  
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
        EXIT FOREACH
        END IF
        IF g_rbp[g_cnt].before='0' THEN
           LET g_rbp[g_cnt].type='1'
        ELSE
           LET g_rbp[g_cnt].type='0'
        END IF
#FUN-BC0058 MARK---
#        SELECT lpf02 INTO g_rbp[g_cnt].rbp08_desc FROM lpf_file
#         WHERE lpf01 = g_rbp[g_cnt].rbp08
#        SELECT lpf02 INTO g_rbp[g_cnt].rbp08_1_desc FROM lpf_file
#         WHERE lpf01 = g_rbp[g_cnt].rbp08_1
#FUN-BC0058 MARK---
#FUN-BC0058 begin---
#FUN-BC0072 mark START
#        SELECT lpc02 INTO g_rbp[g_cnt].rbp08_desc FROM lpc_file
#         WHERE lpc01 = g_rbp[g_cnt].rbp08 AND lpc00 = '6'
#        SELECT lpc02 INTO g_rbp[g_cnt].rbp08_1_desc FROM lpc_file
#         WHERE lpc01 = g_rbp[g_cnt].rbp08_1 AND lpc00 = '6'
#FUN-BC0072 mark END
#FUN-BC0072 add START
        CASE g_argv8
          WHEN '1'
             SELECT lpc02 INTO g_rbp[g_cnt].rbp08_desc FROM lpc_file
                WHERE lpc01 = g_rbp[g_cnt].rbp08 AND lpc00 = '6'
             SELECT lpc02 INTO g_rbp[g_cnt].rbp08_1_desc FROM lpc_file
                WHERE lpc01 = g_rbp[g_cnt].rbp08 AND lpc00 = '6'
          WHEN '2'
             SELECT lpc02 INTO g_rbp[g_cnt].rbp08_desc FROM lpc_file
                WHERE lpc01 = g_rbp[g_cnt].rbp08 AND lpc00 = '7'
             SELECT lpc02 INTO g_rbp[g_cnt].rbp08_1_desc FROM lpc_file
                WHERE lpc01 = g_rbp[g_cnt].rbp08_1 AND lpc00 = '7'
          WHEN '3'
             SELECT lph02 INTO g_rbp[g_cnt].rbp08_desc FROM lph_file
                WHERE lph01 = g_rbp[g_cnt].rbp08 AND lph24 = 'Y'  AND lphacti = 'Y'
             SELECT lph02 INTO g_rbp[g_cnt].rbp08_1_desc FROM lph_file
                WHERE lph01 = g_rbp[g_cnt].rbp08_1 AND lph24 = 'Y'  AND lphacti = 'Y'
        END CASE
#FUN-BC0072 add END
#FUN-BC0058 end---
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_rbp.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t402_2_b()
DEFINE l_ac_t          LIKE type_file.num5,
       l_n             LIKE type_file.num5,
       l_cnt           LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd           LIKE type_file.chr1,
       l_allow_insert  LIKE type_file.num5,
       l_allow_delete  LIKE type_file.num5
 
DEFINE l_price         LIKE rbp_file.rbp09,
       l_discount      LIKE rbp_file.rbp10
 
DEFINE l_rbp05_curr    LIKE rbp_file.rbp05
DEFINE l_rac08         LIKE rac_file.rac08   #FUN-BC0072 add
   LET g_action_choice=""
   IF s_shut(0) THEN 
      RETURN
   END IF
   IF g_argv6<>'N' THEN
      CALL cl_err('','apm-267',0)
      RETURN 
   END IF

  #FUN-BC0072 add START
   IF g_argv1 <> g_plant THEN
      CALL cl_err( '','art-977',0 )
      RETURN
   END IF
  #FUN-BC0072 add END
   
   CALL cl_opmsg('b')
#modify by lixia ---start---    
#   LET g_forupd_sql= "SELECT b.rbp05,'',a.rbp06,a.rbp07,a.rbp08,'',a.rbp09,a.rbp10,a.rbp11,a.rbpacti,",
#                     "                  b.rbp06,b.rbp07,b.rbp08,'',b.rbp09,b.rbp10,b.rbp11,b.rbpacti ",
#                     "  FROM rbp_file b LEFT OUTER JOIN rbp_file a ON                        ",
#                     "                  (b.rbp01=a.rbp01 AND b.rbp02=a.rbp02 AND b.rbp03=a.rbp03 AND ",
#                     "                   b.rbp04=a.rbp04 AND b.rbp05=a.rbp05 AND b.rbp07=a.rbp07 AND ",
#                     "                   b.rbp08=a.rbp08 AND b.rbpplant=a.rbpplant AND b.rbp06<>a.rbp06 )  ",
#                     " WHERE b.rbp01='",g_argv1 CLIPPED,"' AND b.rbp02='",g_argv2 CLIPPED,"'",
#                     "   AND b.rbp03='",g_argv3 CLIPPED,"' AND b.rbp04='",g_argv4 CLIPPED,"'",
#                     "   AND b.rbpplant='",g_argv5 CLIPPED,"'",
#                     "   AND rbp07=? ",
#                     "   AND rbp08=? ",
#                     "   FOR UPDATE"
   LET g_forupd_sql= "SELECT * ",
                     "  FROM rbp_file   ",
                     " WHERE rbp01='",g_argv1 CLIPPED,"' AND rbp02='",g_argv2 CLIPPED,"'",
                     "   AND rbp03='",g_argv3 CLIPPED,"' AND rbp04='",g_argv4 CLIPPED,"'",
                     "   AND rbpplant='",g_argv5 CLIPPED,"'",
                     "   AND rbp07=? ",
                     "   AND rbp08=? ",
                     "   AND rbp12=? ", #FUN-BC0072 add
                     "   AND rbp06 = '1'", #TQC-C20427 add  
                     "   FOR UPDATE"
#modify by lixia ---end---                      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t402_2_bcl CURSOR FROM g_forupd_sql
   
   LET l_allow_insert=cl_detail_input_auth("insert")
   LET l_allow_delete=cl_detail_input_auth("delete")
   
   INPUT ARRAY g_rbp WITHOUT DEFAULTS FROM s_rbp.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
              INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
              APPEND ROW= l_allow_insert)
   BEFORE INPUT
      IF g_rec_b !=0 THEN 
         CALL fgl_set_arr_curr(l_ac)
      END IF
   BEFORE ROW
      LET p_cmd =''
      LET l_ac =ARR_CURR()
      LET l_lock_sw ='N'
      LET l_n =ARR_COUNT()
#TQC-B30183 -------------STA
      IF g_argv4 = '2' THEN
         CALL t402_2_rbp07()
      END IF
#TQC-B30183 -------------END
      BEGIN WORK 
                  
      IF g_rec_b>=l_ac THEN 
         LET p_cmd ='u'
         LET g_rbp_t.*=g_rbp[l_ac].*
         CALL t402_2_rbp07()             #TQC-B30183
         IF p_cmd ='u' THEN
           #CALL cl_set_comp_entry("rbp07,rbp08",FALSE)  #TQC-C20398 mark
            CALL cl_set_comp_entry("rbp07",FALSE)  #TQC-C20398 add
         ELSE
           #CALL cl_set_comp_entry("rbp07,rbp08",TRUE)  #TQC-C20398 mark
            CALL cl_set_comp_entry("rbp07",TRUE)  #TQC-C20398 add
         END IF
         
        #OPEN t402_2_bcl USING g_argv1,g_argv2,g_argv4,
        #                      g_rbp_t.rbp07,g_rbp_t.rbp08,g_argv5
         OPEN t402_2_bcl USING g_rbp_t.rbp07,g_rbp_t.rbp08,g_argv8   #FUN-BC0072 add g_argv8
         IF STATUS THEN
            CALL cl_err("OPEN t402_2_bcl:",STATUS,1)
            LET l_lock_sw='Y'
         ELSE
#modify by lixia ---start---  
         #FETCH t402_2_bcl INTO l_rbp05_curr,g_rbp[l_ac].*
         SELECT b.rbp05,'',a.rbp06,a.rbp07,a.rbp08,'',a.rbp09,a.rbp10,a.rbp11,a.rbpacti,
                b.rbp06,b.rbp07,b.rbp08,'',b.rbp09,b.rbp10,b.rbp11,b.rbpacti
           INTO l_rbp05_curr,g_rbp[l_ac].*     
           FROM rbp_file b LEFT OUTER JOIN rbp_file a ON  
                (b.rbp01=a.rbp01 AND b.rbp02=a.rbp02 AND b.rbp03=a.rbp03 AND 
                 b.rbp04=a.rbp04 AND b.rbp05=a.rbp05 AND b.rbp07=a.rbp07 AND 
                 b.rbp08=a.rbp08 AND b.rbpplant=a.rbpplant AND b.rbp06<>a.rbp06 
                 AND b.rbp12=a.rbp12)
          WHERE b.rbp01=g_argv1  AND b.rbp02=g_argv2 
            AND b.rbp03=g_argv3  AND b.rbp04=g_argv4
            AND b.rbpplant=g_argv5
            AND b.rbp07=g_rbp_t.rbp07 
            AND b.rbp08=g_rbp_t.rbp08
            AND b.rbp06='1'           
            AND b.rbp12 = g_argv8
#modify by lixia ---end---             
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_rbp_t.rbp07,SQLCA.sqlcode,1)
               LET l_lock_sw="Y"
            END IF
            IF g_rbp[l_ac].before='0' THEN
               LET g_rbp[l_ac].type ='1'
            ELSE
               LET g_rbp[l_ac].type ='0'
            END IF
#FUN-BC0058 MARK----
#            SELECT lpf02 INTO g_rbp[l_ac].rbp08_desc FROM lpf_file
#             WHERE lpf01 = g_rbp[l_ac].rbp08 AND lpf05='Y'
#            SELECT lpf02 INTO g_rbp[l_ac].rbp08_1_desc FROM lpf_file
#             WHERE lpf01 = g_rbp[l_ac].rbp08_1 AND lpf05='Y'
#FUN-BC0058 MARK----
#TQC-C20427 add START
    CASE g_argv8
      WHEN '1'
#FUN-BC0058 begin---
         SELECT lpc02 INTO g_rbp[l_ac].rbp08_desc FROM lpc_file
            WHERE lpc01 = g_rbp[l_ac].rbp08 AND lpcacti = 'Y' AND lpc00 = '6'
         SELECT lpc02 INTO g_rbp[l_ac].rbp08_1_desc FROM lpc_file
            WHERE lpc01 = g_rbp[l_ac].rbp08_1 AND lpcacti = 'Y' AND lpc00 = '6'
#FUN-BC0058 end---
      WHEN '2'
         SELECT lpc02 INTO g_rbp[l_ac].rbp08_desc FROM lpc_file
            WHERE lpc01 = g_rbp[l_ac].rbp08 AND lpc00 = '7'
         SELECT lpc02 INTO g_rbp[l_ac].rbp08_1_desc FROM lpc_file
            WHERE lpc01 = g_rbp[l_ac].rbp08_1 AND lpc00 = '7'
      WHEN '3'
         SELECT lph02 INTO g_rbp[l_ac].rbp08_desc FROM lph_file
            WHERE lph01 = g_rbp[l_ac].rbp08 AND lph24 = 'Y'  AND lphacti = 'Y'
         SELECT lph02 INTO g_rbp[l_ac].rbp08_1_desc FROM lph_file
            WHERE lph01 = g_rbp[l_ac].rbp08_1 AND lph24 = 'Y'  AND lphacti = 'Y'
    END CASE
#TQC-C20427 add END
           #CALL t402_2_rbp08('d')
         END IF
      END IF
      
    BEFORE INSERT
       LET l_n=ARR_COUNT()
       LET p_cmd='a'
       INITIALIZE g_rbp[l_ac].* TO NULL               
       LET g_rbp_t.*=g_rbp[l_ac].*
       LET g_rbp[l_ac].type='0'
       LET g_rbp[l_ac].before='0'
       LET g_rbp[l_ac].after ='1'  
       LET g_rbp[l_ac].rbpacti = 'Y'    
#TQC-C20427 ------------STA
       IF g_argv4 = '2' THEN
          LET g_rbp[l_ac].rbp07 = 0
       END IF
#TQC-C20427 ------------END
       #for item_no.---------------------
       SELECT MAX(rbp05)+1 
         INTO l_rbp05_curr
         FROM rbp_file
        WHERE rbp01=g_argv1
          AND rbp01=g_argv1
          AND rbp02=g_argv2
          AND rbp03=g_argv3
          AND rbp04=g_argv4
          AND rbpplant=g_argv5
          AND rbp06='1'
       IF l_rbp05_curr IS NULL OR l_rbp05_curr=0 THEN
          LET l_rbp05_curr=1
       END IF
       #---------------------------------
       IF p_cmd ='u' THEN
         #CALL cl_set_comp_entry("rbp07,rbp08",FALSE)  #TQC-C20398 mark
          CALL cl_set_comp_entry("rbp07",FALSE)  #TQC-C20398 add
       ELSE
         #CALL cl_set_comp_entry("rbp07,rbp08",TRUE)  #TQC-C20398 mark
          CALL cl_set_comp_entry("rbp07",TRUE)  #TQC-C20398 add
       END IF
       CALL cl_show_fld_cont()
       NEXT FIELD rbp07

    AFTER INSERT
       IF INT_FLAG THEN
          CALL cl_err('',9001,0)
          LET INT_FLAG=0
          CANCEL INSERT
       END IF
#TQC-B30183 ------------STA
       IF g_argv4 = '2' THEN
          LET g_rbp[l_ac].rbp07 = 0
       END IF
#TQC-B30183 ------------END
       IF NOT cl_null(g_rbp[l_ac].rbp07) THEN
          IF cl_null(g_rbp[l_ac].rbp09) THEN LET g_rbp[l_ac].rbp09 = 0 END IF
          IF cl_null(g_rbp[l_ac].rbp11) THEN LET g_rbp[l_ac].rbp11 = 0 END IF
          IF g_rbp[l_ac].type='0' THEN
             INSERT INTO rbp_file(rbp01,rbp02,rbp03,rbp04,rbp05,rbp06,
                                  rbp07,rbp08,rbp09,rbp10,rbp11,rbp12,rbpacti,  #FUN-BC0072 add rbp12
                                  rbpplant,rbplegal)
                VALUES(g_argv1,g_argv2,g_argv3,g_argv4,l_rbp05_curr,g_rbp[l_ac].after,
                       g_rbp[l_ac].rbp07,g_rbp[l_ac].rbp08,g_rbp[l_ac].rbp09,g_rbp[l_ac].rbp10,g_rbp[l_ac].rbp11,
                       g_argv8,g_rbp[l_ac].rbpacti,g_argv5,g_legal)  #FUN-BC0072 add g_argv8 
             IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","rbp_file",g_rbp[l_ac].rbp07||","||g_rbp[l_ac].rbp08,"",SQLCA.sqlcode,"","",1)
                CANCEL INSERT
             ELSE
                MESSAGE 'INSERT Ok'
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b To FORMONLY.cn2
             END IF
          ELSE
             INSERT INTO rbp_file(rbp01,rbp02,rbp03,rbp04,rbp05,rbp06,
                                  rbp07,rbp08,rbp09,rbp10,rbp11,rbp12,rbpacti, #FUN-BC0072 add rpb12
                                  rbpplant,rbplegal)
                VALUES(g_argv1,g_argv2,g_argv3,g_argv4,l_rbp05_curr,g_rbp[l_ac].before,
                       g_rbp[l_ac].rbp07_1,g_rbp[l_ac].rbp08_1,g_rbp[l_ac].rbp09_1,g_rbp[l_ac].rbp10_1,g_rbp[l_ac].rbp11_1,
                       g_argv8,g_rbp[l_ac].rbpacti_1,g_argv5,g_legal)  #FUN-BC0072 add g_argv8 
             IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","rbp_file",g_rbp[l_ac].rbp07_1||","||g_rbp[l_ac].rbp08_1,"",SQLCA.sqlcode,"","",1)
                CANCEL INSERT
             ELSE
                MESSAGE 'INSERT Ok'
             END IF
             INSERT INTO rbp_file(rbp01,rbp02,rbp03,rbp04,rbp05,rbp06,
                                  rbp07,rbp08,rbp09,rbp10,rbp11,rbp12,rbpacti, #FUN-BC0072 add rbp12
                                  rbpplant,rbplegal)
                VALUES(g_argv1,g_argv2,g_argv3,g_argv4,l_rbp05_curr,g_rbp[l_ac].after,
                       g_rbp[l_ac].rbp07,g_rbp[l_ac].rbp08,g_rbp[l_ac].rbp09,g_rbp[l_ac].rbp10,g_rbp[l_ac].rbp11,
                       g_argv8,g_rbp[l_ac].rbpacti,g_argv5,g_legal)  #FUN-BC0072 add g_argv8 
             IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","rbp_file",g_rbp[l_ac].rbp07||","||g_rbp[l_ac].rbp08,"",SQLCA.sqlcode,"","",1)
                CANCEL INSERT
             ELSE
                MESSAGE 'INSERT Ok'
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b To FORMONLY.cn2
             END IF
          END IF
       END IF
         
      AFTER FIELD rbp07
         IF NOT cl_null(g_rbp[l_ac].rbp07) THEN
            IF g_rbp_t.rbp07 IS NULL OR
               (g_rbp[l_ac].rbp07 != g_rbp_t.rbp07 ) THEN
               CALL t402_2_rbp07()    #檢查其有效性
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rbp[l_ac].rbp07,g_errno,0)
                  LET g_rbp[l_ac].rbp07 = g_rbp_t.rbp07
                  NEXT FIELD rbp07
               ELSE 
                  #FUN-BC0072 add START
                  LET l_n = 0
                  IF g_rbp[l_ac].rbp07 <> g_argv9 THEN  #TQC-C20328 add  #輸入的組別與當前組別相同則不進入判斷
                     IF g_argv4 = '1' THEN   #判斷輸入組別是否與當前組別的會員促銷方式相同
                        SELECT COUNT(*) INTO l_n FROM rbc_file
                           WHERE rbc01 = g_argv1 AND rbc02 = g_argv2
                             AND rbc03 = g_argv3 AND rbcplant=g_argv5
                             AND rbc06 = g_rbp[l_ac].rbp07 AND rbc05='1'
                             AND rbc11 = g_argv8
                        IF l_n < 1 THEN
                           SELECT COUNT(*) INTO l_n FROM rac_file
                              WHERE rac01 = g_argv1 AND rbc02 = g_argv2
                                AND racplant=g_argv5
                                AND rbc03 = g_rbp[l_ac].rbp07 
                                AND rac08 = g_argv8
                           IF l_n < 1 THEN
                              CALL cl_err('','art-757',0)
                              NEXT FIELD rbp07
                           END IF
                        END IF
                     END IF
                     IF g_argv4 = '3' THEN
                        SELECT COUNT(*) INTO l_n FROM rbi_file
                           WHERE rbi01 = g_argv1 AND rbi02 = g_argv2
                             AND rbi03 = g_argv3 AND rbiplant=g_argv5
                             AND rbi06 = g_rbp[l_ac].rbp07 AND rbi05='1'
                             AND rbi10 = g_argv8
                        IF l_n < 1 THEN
                           SELECT COUNT(*) INTO l_n FROM rai_file
                              WHERE rai01 = g_argv1 AND rai02 = g_argv2
                                AND raiplant=g_argv5
                                AND rai03 = g_rbp[l_ac].rbp07
                                AND rai07 = g_argv8
                           IF l_n < 1  THEN 
                              CALL cl_err('','art-757',0)
                              NEXT FIELD rbp07
                           END IF
                        END IF
                     END IF
                  END IF  #TQC-C20328 add
                  #FUN-BC0072 add END
                  IF NOT cl_null(g_rbp[l_ac].rbp08) THEN
                    #FUN-BC0072 add START
                     LET l_n = 0 
                     SELECT COUNT(*) INTO l_n FROM rbp_file 
                       WHERE rbp01 = g_argv1 AND rbp02 = g_argv2 
                         AND rbp03 = g_argv3 AND rbp04 = g_argv4
                         AND rbp07 = g_rbp[l_ac].rbp07
                         AND rbp08 = g_rbp[l_ac].rbp08
                     IF l_n > 0 THEN
                        CALL cl_err('','-239',0)
                        NEXT FIELD rbp07
                     END IF
                    #FUN-BC0072 add END
                     #Add or Modify STARTING------
                     SELECT COUNT(*) INTO l_n FROM rap_file
                      WHERE rap01=g_argv1 AND rap02=g_argv2 AND rap03=g_argv4
                        AND rapplant = g_argv5 AND rap04 = g_rbp[l_ac].rbp07   #NO.MOD-AC0176
                     IF l_n=0 THEN
                        IF NOT cl_confirm('art-672') THEN   #新增？
                            NEXT FIELD rbp07
                         ELSE
                            CALL t402_2_init()
                         END IF
                     ELSE
                        IF NOT cl_confirm('art-673') THEN   #修改？
                           NEXT FIELD rbp07
                        ELSE
                           CALL t402_2_find()
                        END IF
                     END IF
                  END IF
               END IF
            END IF
         END IF

      ON CHANGE rbp07
         IF NOT cl_null(g_rbp[l_ac].rbp07) THEN
            CALL t402_2_rbp07()
         END IF

      AFTER FIELD rbp08
             IF NOT cl_null(g_rbp[l_ac].rbp08) THEN  
                IF p_cmd = 'a' OR (p_cmd = 'u' AND 
                             g_rbp[l_ac].rbp08 <> g_rbp_t.rbp08) THEN
                   LET l_n =0 
                   SELECT COUNT(*) INTO l_n FROM rbp_file
                    WHERE rbp01=g_argv1 AND rbp02=g_argv2 AND rbp03=g_argv3
                      AND rbpplant=g_argv5 AND rbp07 = g_rbp[l_ac].rbp07
                      AND rbp08 = g_rbp[l_ac].rbp08
                      AND rbp12 = g_argv8  #TQC-C20427 add
                   IF l_n>0 THEN
                      CALL cl_err('',-239,0)
                      LET g_rbp[l_ac].rbp08=g_rbp_t.rbp08
                      NEXT FIELD rbp08
                   ELSE  
                      CALL t402_2_rbp08('a')
                      IF NOT cl_null(g_errno) THEN
                         CALL cl_err('rbp08',g_errno,0)
                         LET g_rbp[l_ac].rbp08 = g_rbp_t.rbp08
                         DISPLAY BY NAME g_rbp[l_ac].rbp08
                         NEXT FIELD rbp08
                      ELSE
                         IF NOT cl_null(g_rbp[l_ac].rbp07) THEN
                           #FUN-BC0072 add START
                            LET l_n = 0
                            SELECT COUNT(*) INTO l_n FROM rbp_file
                              WHERE rbp01 = g_argv1 AND rbp02 = g_argv2
                                AND rbp03 = g_argv3 AND rbp04 = g_argv4
                                AND rbp07 = g_rbp[l_ac].rbp07
                                AND rbp08 = g_rbp[l_ac].rbp08
                                AND rbp12 = g_argv8  #TQC-C20427 add
                            IF l_n > 0 THEN
                               CALL cl_err('','-239',0)
                               NEXT FIELD rbp08
                            END IF
                           #FUN-BC0072 add END
                            #Add or Modify STARTING------
                            SELECT COUNT(*) INTO l_n FROM rap_file
                             WHERE rap01=g_argv1 AND rap02=g_argv2 AND rap03=g_argv4
                               AND rapplant = g_argv5  AND rap04 = g_rbp[l_ac].rbp07 AND rap05=g_rbp[l_ac].rbp08  #NO.MOD-AC0176
                               AND rap09 = g_argv8  #TQC-C20427 add
                            IF l_n=0 THEN
                               IF NOT cl_confirm('art-672') THEN   #新增？
                                   NEXT FIELD rbp08
                               ELSE
                                  CALL t402_2_init()
                               END IF
                            ELSE
                               IF NOT cl_confirm('art-673') THEN   #修改？
                                  NEXT FIELD rbp08
                               ELSE
                                  CALL t402_2_find()
                               END IF
                            END IF
                         END IF  
                      END IF  
                   END IF  
                END IF
             END IF

      BEFORE FIELD rbp09,rbp10,rbp11
         IF NOT cl_null(g_rbp[l_ac].rbp07) THEN
            CALL t402_2_rbp07()
         END IF

      AFTER FIELD rbp09    #會員特賣價
         LET l_price = FGL_DIALOG_GETBUFFER()
         IF l_price <= 0 THEN
            CALL cl_err('','art-180',0)
            NEXT FIELD CURRENT
         ELSE
            DISPLAY BY NAME g_rbp[l_ac].rbp09
         END IF

      AFTER FIELD rbp10   #會員折扣率
           LET l_discount = FGL_DIALOG_GETBUFFER()
           IF l_discount < 0 OR l_discount > 100 THEN
              CALL cl_err('','atm-384',0)
              NEXT FIELD CURRENT
           ELSE
              DISPLAY BY NAME g_rbp[l_ac].rbp10
           END IF

      AFTER FIELD rbp11    #會員折讓額
         LET l_price = FGL_DIALOG_GETBUFFER()
         IF l_price <= 0 THEN
            CALL cl_err('','art-653',0)
            NEXT FIELD CURRENT
         ELSE
            DISPLAY BY NAME g_rbp[l_ac].rbp11
         END IF

                           
       BEFORE DELETE                      
           IF g_rbp_t.rbp07 > 0 AND NOT cl_null(g_rbp_t.rbp07) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rbp_file
                     WHERE rbp01=g_argv1 AND rbp02=g_argv2 AND rbp03=g_argv3 
                       AND rbp04=g_argv4 AND rbpplant=g_argv5 
                       AND rbp07=g_rbp_t.rbp07 AND rbp08=g_rbp_t.rbp08
                       AND rbp12=g_argv8   #FUN-BC0072 add
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","rbp_file",g_rbp_t.rbp07,'',SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rbp[l_ac].* = g_rbp_t.*
              CLOSE t402_2_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF

           IF g_rbp[l_ac].rbp07<>g_rbp_t.rbp07 OR
              g_rbp[l_ac].rbp08<>g_rbp_t.rbp08 THEN 
              SELECT COUNT(*) INTO l_n FROM rbp_file
               WHERE rbp01=g_argv1 AND rbp02=g_argv2 AND rbp03=g_argv3 AND rbp04=g_argv4
                 AND rbpplant=g_argv5 AND rbp07 = g_rbp[l_ac].rbp07
                 AND rbp08 = g_rbp[l_ac].rbp08
                 AND rbp12 = g_argv8  #TQC-C20427 add  
              IF l_n>0 THEN
                  CALL cl_err(g_rbp[l_ac].rbp07,-239,0)
                  LET g_rbp[l_ac].* = g_rbp_t.*
                  NEXT FIELD CURRENT
              END IF
           END IF

           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rbp[l_ac].rbp07,-263,1)
              LET g_rbp[l_ac].* = g_rbp_t.*
           ELSE
              IF NOT cl_null(g_rbp[l_ac].rbp07) THEN
                 UPDATE rbp_file SET  rbp09 = g_rbp[l_ac].rbp09,
                                      rbp10 = g_rbp[l_ac].rbp10,
                                      rbp11 = g_rbp[l_ac].rbp11,
                                      rbp08 = g_rbp[l_ac].rbp08,  #TQC-C20398 add
                                      rbpacti = g_rbp[l_ac].rbpacti
                       WHERE rbp01=g_argv1 AND rbp02=g_argv2 AND rbp03=g_argv3 AND rbp04=g_argv4
                         AND rbpplant=g_argv5 AND rbp07=g_rbp_t.rbp07 AND rbp06='1'
                         AND rbp08=g_rbp_t.rbp08
                         AND rbp12=g_argv8  #FUN-BC0072 add
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("upd","rbp_file",g_rbp_t.rbp07||","||g_rbp_t.rbp08,'',SQLCA.sqlcode,"","",1) 
                    LET g_rbp[l_ac].* = g_rbp_t.*
                 ELSE
                   #TQC-C20427 add START
                    IF cl_null(g_rbp[l_ac].rbp08_1) THEN
                       DELETE FROM rbp_file
                          WHERE rbp01=g_argv1 AND rbp02=g_argv2 AND rbp03=g_argv3
                            AND rbpplant=g_argv5 AND rbp07 = g_rbp[l_ac].rbp07
                            AND rbp08 = g_rbp_t.rbp08
                            AND rbp12 = g_argv8  AND rbp06 = '0'
                    ELSE
                       UPDATE rbp_file SET  rbp09 = g_rbp[l_ac].rbp09_1,
                                            rbp10 = g_rbp[l_ac].rbp10_1,
                                            rbp11 = g_rbp[l_ac].rbp11_1,
                                            rbp08 = g_rbp[l_ac].rbp08_1,  
                                            rbpacti = g_rbp[l_ac].rbpacti_1
                             WHERE rbp01=g_argv1 AND rbp02=g_argv2 AND rbp03=g_argv3 AND rbp04=g_argv4
                               AND rbpplant=g_argv5 AND rbp07=g_rbp_t.rbp07 AND rbp06='0'
                               AND rbp08=g_rbp_t.rbp08
                               AND rbp12=g_argv8  
                    END IF
                   #TQC-C20427 add END
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                 END IF
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
          #FUN-D30033------Mark---Str
          #LET l_ac_t = l_ac 
          #IF cl_null(g_rbp[l_ac].rbp07) THEN
          #   CALL g_rbp.deleteelement(l_ac)
          #END IF  
          #FUN-D30033------Mark---End
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rbp[l_ac].* = g_rbp_t.*
              #FUN-D30033----Add---Str
              ELSE
                 CALL g_rbp.deleteelement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033----Add---End 
              END IF
              CLOSE t402_2_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac     #FUN-D30033 Add
           CLOSE t402_2_bcl
           COMMIT WORK
           
      ON ACTION CONTROLO                        
           IF (INFIELD(rbp07) OR INFIELD(rbp08)) AND l_ac > 1 THEN
              LET g_rbp[l_ac].* = g_rbp[l_ac-1].*
              LET g_rec_b = g_rec_b + 1
              NEXT FIELD rbp07
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
            WHEN INFIELD(rbp08)                     
               CALL cl_init_qry_var()
               #LET g_qryparam.state = "c"
#              LET g_qryparam.form ="q_lpf"      #FUN-BC0058  mark
              #LET g_qryparam.form ="q_lpc01_1"  #FUN-BC0058  #FUN-BC0072 mark
              #LET g_qryparam.arg1 = '6'         #FUN-BC0058  #FUN-BC0072 mark
              #LET g_qryparam.default1 = g_rbp[l_ac].rbp08    #FUN-BC0072 mark
              #FUN-BC0072 add START
              CASE g_argv8
                 WHEN "3"
                    LET g_qryparam.form = "q_lph04"
                 WHEN "1"
                    LET g_qryparam.form = "q_lpc02"
                 WHEN "2"
                    LET g_qryparam.form = "q_lpc03"
              END CASE
              #FUN-BC0072 add END
               CALL cl_create_qry() RETURNING g_rbp[l_ac].rbp08
               CALL t402_2_rbp08('a')
              #FUN-BC0072 add START
               CASE g_argv8
                 WHEN '1'
                    SELECT lpc02 INTO g_rbp[l_ac].rbp08_1_desc FROM lpc_file
                      WHERE lpc01 = g_rbp[l_ac].rbp08 AND lpc00 = '6'
                 WHEN '2'
                    SELECT lpc02 INTO g_rbp[l_ac].rbp08_1_desc FROM lpc_file
                      WHERE lpc01 = g_rbp[l_ac].rbp08 AND lpc00 = '7'
                 WHEN '3'
                    SELECT lph02 INTO g_rbp[l_ac].rbp08_1_desc FROM lph_file
                      WHERE lph01 = g_rbp[l_ac].rbp08 AND lph24 = 'Y'  AND lphacti = 'Y'
              END CASE
              #FUN-BC0072 add END
               NEXT FIELD rbp08
            OTHERWISE EXIT CASE
          END CASE
     
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
 
        ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
    END INPUT
  
    CLOSE t402_2_bcl
    COMMIT WORK
    
END FUNCTION                          
                                                   
FUNCTION t402_2_bp_refresh()
 
  DISPLAY ARRAY g_rbp TO s_rbp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  
END FUNCTION

FUNCTION t402_2_find()

   LET g_rbp[l_ac].type  ='1'
   LET g_rbp[l_ac].before='0'
   LET g_rbp[l_ac].after ='1'

   SELECT rap04,rap05,rap06,rap07,rap08,rapacti
     INTO g_rbp[l_ac].rbp07_1,g_rbp[l_ac].rbp08_1,g_rbp[l_ac].rbp09_1,
          g_rbp[l_ac].rbp10_1,g_rbp[l_ac].rbp11_1,g_rbp[l_ac].rbpacti_1
     FROM rap_file
    WHERE rap01=g_argv1 AND rap02=g_argv2 AND rap03=g_argv4
      AND rapplant=g_argv5 
      AND rap04=g_rbp[l_ac].rbp07
      AND rap05=g_rbp[l_ac].rbp08
      AND rap09=g_argv8  #TQC-C20427 add
#FUN-BC0058 mark---
#   SELECT lpf02 INTO g_rbp[l_ac].rbp08_desc FROM lpf_file
#    WHERE lpf01 = g_rbp[l_ac].rbp08 AND lpf05='Y'
#   SELECT lpf02 INTO g_rbp[l_ac].rbp08_1_desc FROM lpf_file
#    WHERE lpf01 = g_rbp[l_ac].rbp08_1 AND lpf05='Y'
#FUN-BC0058 mark---
#TQC-C20427 add START
    CASE g_argv8
      WHEN '1' 
#FUN-BC0058 begin---
         SELECT lpc02 INTO g_rbp[l_ac].rbp08_desc FROM lpc_file
            WHERE lpc01 = g_rbp[l_ac].rbp08 AND lpcacti = 'Y' AND lpc00 = '6'
         SELECT lpc02 INTO g_rbp[l_ac].rbp08_1_desc FROM lpc_file
            WHERE lpc01 = g_rbp[l_ac].rbp08_1 AND lpcacti = 'Y' AND lpc00 = '6'
#FUN-BC0058 end---
      WHEN '2' 
         SELECT lpc02 INTO g_rbp[l_ac].rbp08_desc FROM lpc_file
            WHERE lpc01 = g_rbp[l_ac].rbp08 AND lpc00 = '7' 
         SELECT lpc02 INTO g_rbp[l_ac].rbp08_1_desc FROM lpc_file
            WHERE lpc01 = g_rbp[l_ac].rbp08_1 AND lpc00 = '7'
      WHEN '3' 
         SELECT lph02 INTO g_rbp[l_ac].rbp08_desc FROM lph_file
            WHERE lph01 = g_rbp[l_ac].rbp08 AND lph24 = 'Y'  AND lphacti = 'Y' 
         SELECT lph02 INTO g_rbp[l_ac].rbp08_1_desc FROM lph_file
            WHERE lph01 = g_rbp[l_ac].rbp08_1 AND lph24 = 'Y'  AND lphacti = 'Y'
    END CASE
#TQC-C20427 add END
   DISPLAY BY NAME g_rbp[l_ac].rbp07_1,g_rbp[l_ac].rbp08_1,g_rbp[l_ac].rbp09_1,
                   g_rbp[l_ac].rbp10_1,g_rbp[l_ac].rbp11_1,g_rbp[l_ac].rbpacti_1,
                   g_rbp[l_ac].rbp08_1_desc
   DISPLAY BY NAME g_rbp[l_ac].rbp07,g_rbp[l_ac].rbp08,g_rbp[l_ac].rbp08_desc

END FUNCTION

FUNCTION t402_2_init()

   LET g_rbp[l_ac].type  ='0'
   LET g_rbp[l_ac].before=' '
   LET g_rbp[l_ac].after ='1'

   LET g_rbp[l_ac].rbp07_1=NULL
   LET g_rbp[l_ac].rbp08_1=NULL
   LET g_rbp[l_ac].rbp09_1=NULL
   LET g_rbp[l_ac].rbp10_1=NULL
   LET g_rbp[l_ac].rbp11_1=NULL
   LET g_rbp[l_ac].rbpacti_1=NULL
   LET g_rbp[l_ac].rbp08_1_desc=NULL

   DISPLAY BY NAME g_rbp[l_ac].rbp07_1,g_rbp[l_ac].rbp08_1,g_rbp[l_ac].rbp09_1,
                   g_rbp[l_ac].rbp10_1,g_rbp[l_ac].rbp11_1,g_rbp[l_ac].rbpacti_1,
                   g_rbp[l_ac].rbp08_1_desc

END FUNCTION
 
#FUN-A70048
