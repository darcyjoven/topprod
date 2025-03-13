# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
#Pattern name...:"art403_1.4gl"
#Descriptions...:換贈資料維護作業
#Date & Author..:NO.FUN-A80104 10/09/08 By lixia
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No.FUN-AB0025 10/11/10 By huangtao 新增料號控管
# Modify.........: No.FUN-AB0025 10/11/11 By chenying 修改料號開窗改為CALL q_sel_ima()
# Modify.........: No.FUN-BC0078 11/12/22 By pauline GP5.3 artt403 一般促銷變更單促銷功能優化 
# Modify.........: No.TQC-C30004 12/03/01 By pauline 促銷優化修改 
# Modify.........: No.TQC-C30055 12/03/03 By pauline 促銷優化修改
# Modify.........: No.FUN-C60041 12/08/10 By huangtao 換贈變更時，rbe28t,rbe29t 都不能为空
# Modify.........: No.TQC-D40014 13/04/02 By pauline 當營運中心未設定產品策略時,不控卡輸入的產品料號
# Modify.........: No:FUN-D30033 13/04/18 by xumm 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_rbr    DYNAMIC ARRAY OF RECORD 
                type       LIKE type_file.chr1,                
                before     LIKE rbr_file.rbr06,
                rbr07_1    LIKE rbr_file.rbr07,     #項次
                rbr08_1    LIKE rbr_file.rbr08,     #組別
                rbr09_1    LIKE rbr_file.rbr09,     #數量
                rbr10_1    LIKE rbr_file.rbr10,     #加價金額
                rbr11_1    LIKE rbr_file.rbr11,     #會員加價金額
                rbracti_1  LIKE rbr_file.rbracti,   #有效否
                after      LIKE rbr_file.rbr06,
                rbr07      LIKE rbr_file.rbr07,     #項次
                rbr08      LIKE rbr_file.rbr08,     #組別
                rbr09      LIKE rbr_file.rbr09,     #數量
                rbr10      LIKE rbr_file.rbr10,     #加價金額
                rbr11      LIKE rbr_file.rbr11,     #會員加價金額
                rbracti    LIKE rbr_file.rbracti    #有效否
                END RECORD,
      g_rbr_t   RECORD
                type       LIKE type_file.chr1,                
                before     LIKE rbr_file.rbr06, 
                rbr07_1    LIKE rbr_file.rbr07,     #項次
                rbr08_1    LIKE rbr_file.rbr08,     #組別
                rbr09_1    LIKE rbr_file.rbr09,     #數量
                rbr10_1    LIKE rbr_file.rbr10,     #加價金額
                rbr11_1    LIKE rbr_file.rbr11,     #會員加價金額
                rbracti_1  LIKE rbr_file.rbracti,   #有效否
                after      LIKE rbr_file.rbr06,
                rbr07      LIKE rbr_file.rbr07,     #項次
                rbr08      LIKE rbr_file.rbr08,     #組別
                rbr09      LIKE rbr_file.rbr09,     #數量
                rbr10      LIKE rbr_file.rbr10,     #加價金額
                rbr11      LIKE rbr_file.rbr11,     #會員加價金額
                rbracti    LIKE rbr_file.rbracti    #有效否
                END RECORD,
      g_rbr_o   RECORD
                type       LIKE type_file.chr1,                
                before     LIKE rbr_file.rbr06,
                rbr07_1    LIKE rbr_file.rbr07,     #項次
                rbr08_1    LIKE rbr_file.rbr08,     #組別
                rbr09_1    LIKE rbr_file.rbr09,     #數量
                rbr10_1    LIKE rbr_file.rbr10,     #加價金額
                rbr11_1    LIKE rbr_file.rbr11,     #會員加價金額
                rbracti_1  LIKE rbr_file.rbracti,   #有效否
                after      LIKE rbr_file.rbr06,
                rbr07      LIKE rbr_file.rbr07,     #項次
                rbr08      LIKE rbr_file.rbr08,     #組別
                rbr09      LIKE rbr_file.rbr09,     #數量
                rbr10      LIKE rbr_file.rbr10,     #加價金額
                rbr11      LIKE rbr_file.rbr11,     #會員加價金額
                rbracti    LIKE rbr_file.rbracti    #有效否
                END RECORD
DEFINE g_rbs   DYNAMIC ARRAY OF RECORD 
               type1        LIKE type_file.chr1,                
               before1      LIKE rbs_file.rbs06,
               rbs07_1      LIKE rbs_file.rbs07,
               rbs08_1      LIKE rbs_file.rbs08,
               rbs09_1      LIKE rbs_file.rbs09,
               rbs10_1      LIKE rbs_file.rbs10,
               rbs10_1_desc LIKE type_file.chr100,
               rbs11_1      LIKE rbs_file.rbs11,
               rbs11_1_desc LIKE gfe_file.gfe02,
               rbs12_1      LIKE rbs_file.rbs12,   #FUN-BC0078 add
               rbsacti_1    LIKE rbs_file.rbsacti,
               after1       LIKE rbs_file.rbs06,
               rbs07        LIKE rbs_file.rbs07,
               rbs08        LIKE rbs_file.rbs08,
               rbs09        LIKE rbs_file.rbs09,
               rbs10        LIKE rbs_file.rbs10,
               rbs10_desc   LIKE type_file.chr100,
               rbs11        LIKE rbs_file.rbs11,
               rbs11_desc   LIKE gfe_file.gfe02,
               rbs12        LIKE rbs_file.rbs12,   #FUN-BC0078 add
               rbsacti      LIKE rbs_file.rbsacti
                            END RECORD,
       g_rbs_t             RECORD
               type1        LIKE type_file.chr1,                
               before1      LIKE rbs_file.rbs06,
               rbs07_1      LIKE rbs_file.rbs07,
               rbs08_1      LIKE rbs_file.rbs08,
               rbs09_1      LIKE rbs_file.rbs09,
               rbs10_1      LIKE rbs_file.rbs10,
               rbs10_1_desc LIKE type_file.chr100,
               rbs11_1      LIKE rbs_file.rbs11,
               rbs11_1_desc LIKE gfe_file.gfe02,
               rbs12_1      LIKE rbs_file.rbs12,   #FUN-BC0078 add
               rbsacti_1    LIKE rbs_file.rbsacti,
               after1       LIKE rbs_file.rbs06,
               rbs07        LIKE rbs_file.rbs07,
               rbs08        LIKE rbs_file.rbs08,
               rbs09        LIKE rbs_file.rbs09,
               rbs10        LIKE rbs_file.rbs10,
               rbs10_desc   LIKE type_file.chr100,
               rbs11        LIKE rbs_file.rbs11,
               rbs11_desc   LIKE gfe_file.gfe02,
               rbs12        LIKE rbs_file.rbs12,   #FUN-BC0078 add
               rbsacti      LIKE rbs_file.rbsacti
                            END RECORD,
       g_rbs_o              RECORD
               type1        LIKE type_file.chr1,                
               before1      LIKE rbs_file.rbs06,
               rbs07_1      LIKE rbs_file.rbs07,
               rbs08_1      LIKE rbs_file.rbs08,
               rbs09_1      LIKE rbs_file.rbs09,
               rbs10_1      LIKE rbs_file.rbs10,
               rbs10_1_desc LIKE type_file.chr100,
               rbs11_1      LIKE rbs_file.rbs11,
               rbs11_1_desc LIKE gfe_file.gfe02,
               rbs12_1      LIKE rbs_file.rbs12,   #FUN-BC0078 add
               rbsacti_1    LIKE rbs_file.rbsacti,
               after1       LIKE rbs_file.rbs06,
               rbs07        LIKE rbs_file.rbs07,
               rbs08        LIKE rbs_file.rbs08,
               rbs09        LIKE rbs_file.rbs09,
               rbs10        LIKE rbs_file.rbs10,
               rbs10_desc   LIKE type_file.chr100,
               rbs11        LIKE rbs_file.rbs11,
               rbs11_desc   LIKE gfe_file.gfe02,
               rbs12        LIKE rbs_file.rbs12,   #FUN-BC0078 add
               rbsacti      LIKE rbs_file.rbsacti
                            END RECORD

DEFINE   g_sql      STRING,
         g_wc1      STRING,
         g_wc2      STRING,
         g_rec_b    LIKE type_file.num5,
         g_rec_b1   LIKE type_file.num5,
         g_rec_b2   LIKE type_file.num5,
         l_ac2      LIKE type_file.num5,
         l_ac1      LIKE type_file.num5,
         l_ac       LIKE type_file.num5
DEFINE  p_row,p_col     LIKE type_file.num5
DEFINE  g_forupd_sql    STRING
DEFINE  g_cnt           LIKE type_file.num10
DEFINE  g_argv1         LIKE rbr_file.rbr01,
        g_argv2         LIKE rbr_file.rbr02,
        g_argv3         LIKE rbr_file.rbr03,
        g_argv4         LIKE rbr_file.rbr04,
        g_argv5         LIKE rbr_file.rbrplant,
        g_argv6         LIKE rbe_file.rbeconf,
        g_argv7         LIKE rbe_file.rbe10   #促銷方式

DEFINE g_flag_b            LIKE type_file.chr1
DEFINE g_legal LIKE azw_file.azw02
DEFINE g_rtz RECORD LIKE rtz_file.*
#FUN-BC0078 add START
DEFINE   g_rbe      RECORD
           rbe28          LIKE rbe_file.rbe28,
           rbe29          LIKE rbe_file.rbe29,
           rbe31          LIKE rbe_file.rbe31,
           rbe28t         LIKE rbe_file.rbe28t,
           rbe29t         LIKE rbe_file.rbe29t,
           rbe31t         LIKE rbe_file.rbe31t
                    END RECORD

#FUN-BC0078 add END 
FUNCTION t403_gift(p_argv1,p_argv2,p_argv3,p_argv4,p_argv5,p_argv6,p_argv7)
DEFINE  p_argv1         LIKE rbr_file.rbr01,
        p_argv2         LIKE rbr_file.rbr02,
        p_argv3         LIKE rbr_file.rbr03,
        p_argv4         LIKE rbr_file.rbr04,
        p_argv5         LIKE rbr_file.rbrplant,
        p_argv6         LIKE rbe_file.rbeconf,
        p_argv7         LIKE rbe_file.rbe10
 
    WHENEVER ERROR CALL cl_err_msg_log
    LET g_argv1 = p_argv1
    LET g_argv2 = p_argv2
    LET g_argv3 = p_argv3
    LET g_argv4 = p_argv4
    LET g_argv5 = p_argv5
    LET g_argv6 = p_argv6
    LET g_argv7 = p_argv7
 
   SELECT * INTO g_rtz.* FROM rtz_file WHERE rtz01 = g_argv5
   SELECT azw02 INTO g_legal FROM azw_file WHERE azw01=g_argv5
  
   LET p_row = 2 LET p_col = 21
    OPEN WINDOW t403_1_w AT p_row,p_col WITH FORM "art/42f/artt403_1"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("artt403_1")
   CALL t403_1_b1(" 1=1") #FUN-BC0078 add
   CALL t403_1_b2(" 1=1") #FUN-BC0078 add
   CALL t403_gift_b_fill(" 1=1")
   CALL t403_gift_b1_fill(" 1=1")
   IF g_rec_b=0 THEN
      CALL t403_1_updrbe()  #FUN-BC0078 add
      CALL t403_gift_b()
      CALL t403_gift_b1()
    END IF   
   CALL t403_gift_menu()
   CLOSE WINDOW t403_1_w
END FUNCTION
 
FUNCTION t403_gift_menu() 
   WHILE TRUE
      CALL t403_gift_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t403_gift_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               IF g_flag_b = '1' THEN
                  CALL t403_gift_b()
               ELSE
                  CALL t403_gift_b1()
               END IF
            ELSE
               LET g_action_choice = NULL
            END IF 
#FUN-BB0058 add START
         WHEN "updrbe"         #換贈資料
            IF cl_chk_act_auth() THEN
                  CALL t403_1_updrbe()
            END IF
#FUN-BB0058 add END
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()       
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rbr),'','')
             END IF        
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t403_gift_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = ''
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_rbr TO s_rbr.* ATTRIBUTE(COUNT=g_rec_b)
         BEFORE DISPLAY
           CALL cl_navigator_setting(0,0)
           
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()                   
         
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG

         ON ACTION detail
            LET g_action_choice="detail"
            LET g_flag_b = '1'
            LET l_ac = 1
            EXIT DIALOG

         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG

         ON ACTION locale
            CALL cl_dynamic_locale()
             CALL cl_show_fld_cont()                  
    
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG
    
         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG
      
         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '1'
            LET l_ac = ARR_CURR()
            EXIT DIALOG

        #FUN-BC0078 add START
        #ON ACTION updrbe  #TQC-C20564 mark
         ON ACTION modify  #TQC-C20564 add
            LET g_action_choice="updrbe"
            EXIT DIALOG
        #FUN-BC0078 add END
      
         ON ACTION cancel
            LET INT_FLAG=FALSE 		
            LET g_action_choice="exit"
            EXIT DIALOG
      
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE DIALOG
    
         ON ACTION about         
            CALL cl_about()      
               
         ON ACTION exporttoexcel
            LET g_action_choice = 'exporttoexcel'
            EXIT DIALOG
         AFTER DISPLAY
            CONTINUE DIALOG
       END DISPLAY

      DISPLAY ARRAY g_rbs TO s_rbs.* ATTRIBUTE(COUNT=g_rec_b1)
         BEFORE DISPLAY
           CALL cl_navigator_setting(0,0)
           
         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()                   
         
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG

         ON ACTION detail
            LET g_action_choice="detail"
            LET g_flag_b = '2'
            LET l_ac2 = 1
            EXIT DIALOG

         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG

         ON ACTION locale
            CALL cl_dynamic_locale()
             CALL cl_show_fld_cont()                  
    
         #ON ACTION exit
         #   LET g_action_choice="exit"
         #   EXIT DIALOG
    
         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG
      
         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '2'
            LET l_ac2 = ARR_CURR()
            EXIT DIALOG
     
        #FUN-BC0078 add START
        #ON ACTION updrbe  #TQC-C20564 mark
         ON ACTION modify  #TQC-C20564 add
            LET g_action_choice="updrbe"
            EXIT DIALOG
        #FUN-BC0078 add END
 
         ON ACTION cancel
            LET INT_FLAG=FALSE 		
            LET g_action_choice="exit"
            EXIT DIALOG
      
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE DIALOG
    
         ON ACTION about         
            CALL cl_about()      
               
         ON ACTION exporttoexcel
            LET g_action_choice = 'exporttoexcel'
            EXIT DIALOG

         AFTER DISPLAY
            CONTINUE DIALOG
       END DISPLAY
    END DIALOG
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t403_gift_q() 
  CALL cl_navigator_setting(0,0)
  CALL cl_opmsg('q')   
  CLEAR FORM 
  CALL g_rbr.clear()
  CALL g_rbs.clear()
  MESSAGE ''
  DISPLAY ' ' TO FORMONLY.cnt
  CONSTRUCT g_wc1 ON b.rbr07,b.rbr08,b.rbr09,b.rbr10,b.rbr11,b.rbracti
                FROM s_rbr[1].rbr07,s_rbr[1].rbr08,s_rbr[1].rbr09,
                     s_rbr[1].rbr10,s_rbr[1].rbr11,s_rbr[1].rbracti
    
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
 
    CONSTRUCT g_wc2 ON b.rbs07,b.rbs08,b.rbs09,b.rbs10,b.rbs11,b.rbs12,b.rbsacti  #FUN-BC0078 add rbs12
           FROM s_rbs[1].rbs07,s_rbs[1].rbs08,s_rbs[1].rbs09,
                s_rbs[1].rbs10,s_rbs[1].rbs11,s_rbs[1].rbs12, s_rbs[1].rbsacti  #FUN-BC0078 add rbs12

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(rbs10)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_ras07"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rbs10
               NEXT FIELD rbs10
            WHEN INFIELD(rbs11)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_ras08"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rbs11
               NEXT FIELD rbs11
         END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about
         CALL cl_about()

      ON ACTION HELP
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION qbe_save
         CALL cl_qbe_save()
    END CONSTRUCT

    IF INT_FLAG THEN
       RETURN
    END IF
    
    LET g_wc1 = g_wc1 CLIPPED
    LET g_wc2 = g_wc2 CLIPPED
    IF cl_null(g_wc1) THEN
       LET g_wc1=" 1=1"
    END IF
    IF cl_null(g_wc2) THEN
       LET g_wc2=" 1=1"
    END IF
    CALL t403_gift_b_fill(g_wc1)
    CALL t403_gift_b1_fill(g_wc2)
END FUNCTION
 
FUNCTION t403_gift_b()
   DEFINE l_ac_t          LIKE type_file.num5,
          l_n             LIKE type_file.num5,
          l_cnt           LIKE type_file.num5,
          l_lock_sw       LIKE type_file.chr1,
          p_cmd           LIKE type_file.chr1,
          l_allow_insert  LIKE type_file.num5,
          l_allow_delete  LIKE type_file.num5
   DEFINE l_rbr05_curr    LIKE rbr_file.rbr05   #序号
 
   LET g_action_choice=""
   IF s_shut(0) THEN 
      RETURN
   END IF
   IF g_argv6<>'N' THEN
      CALL cl_err('','apm-267',0)
      RETURN 
   END IF   
   CALL cl_opmsg('b')
   
   LET g_forupd_sql="SELECT * ",
                    "  FROM rbr_file ",
                    " WHERE rbr01=?  AND rbr02=? AND rbr03=? AND rbr04=? ",
                    "   AND rbr07=?  AND rbr08=? AND rbrplant=? ",
                    "   FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t403_gift_bcl CURSOR FROM g_forupd_sql   
   LET l_allow_insert=cl_detail_input_auth("insert")
   LET l_allow_delete=cl_detail_input_auth("delete")
   
   INPUT ARRAY g_rbr WITHOUT DEFAULTS FROM s_rbr.*
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
      
      BEGIN WORK                   
      IF g_rec_b>=l_ac THEN 
         LET p_cmd ='u'
         LET g_rbr_t.*=g_rbr[l_ac].*
         IF p_cmd='u' THEN
            CALL cl_set_comp_entry("rbr07,rbr08",FALSE)
         ELSE
            CALL cl_set_comp_entry("rbr07,rbr08",TRUE)
         END IF         
         OPEN t403_gift_bcl USING g_argv1,g_argv2,g_argv3,g_argv4,g_rbr[l_ac].rbr07,
                                  g_rbr[l_ac].rbr08,g_argv5 
         IF STATUS THEN
            CALL cl_err("OPEN t403_gift_bcl:",STATUS,1)
            LET l_lock_sw='Y'
         ELSE
            #FETCH t403_gift_bcl INTO l_rbr05_curr,g_rbr[l_ac].*
            SELECT b.rbr05,'',a.rbr06,a.rbr07,a.rbr08,a.rbr09,a.rbr10,a.rbr11,a.rbracti, 
                   b.rbr06,b.rbr07,b.rbr08,b.rbr09,b.rbr10,b.rbr11,b.rbracti 
             INTO l_rbr05_curr,g_rbr[l_ac].*      
             FROM rbr_file b LEFT OUTER JOIN rbr_file a  
               ON (b.rbr01=a.rbr01 AND b.rbr02=a.rbr02 AND b.rbr03=a.rbr03 AND b.rbrplant=a.rbrplant 
              AND b.rbr04=a.rbr04  AND b.rbr05=a.rbr05 AND b.rbr07=a.rbr07  AND b.rbr08=a.rbr08 
                AND b.rbr06<>a.rbr06 )
            WHERE b.rbr01=g_argv1  AND b.rbr02=g_argv2 
              AND b.rbr03=g_argv3  AND b.rbr04=g_argv4 
              AND b.rbr06='1'  
              AND b.rbr07=g_rbr[l_ac].rbr07 
              AND b.rbr08=g_rbr[l_ac].rbr08 
              AND b.rbrplant=g_argv5
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_rbr_t.rbr08,SQLCA.sqlcode,1)
               LET l_lock_sw="Y"
            ELSE
               CALL cl_set_comp_entry("rbr08",p_cmd='a')   
            END IF
            IF g_rbr[l_ac].before='0' THEN
               LET g_rbr[l_ac].type ='1'
            ELSE
               LET g_rbr[l_ac].type ='0'
            END IF            
         END IF
     #TQC-C20564 add START
      ELSE
         CALL cl_set_comp_entry("rbr07,rbr08",TRUE)
     #TQC-C20564 add END
      END IF
      
    BEFORE INSERT
       LET l_n=ARR_COUNT()
       LET p_cmd='a'
       INITIALIZE g_rbr[l_ac].* TO NULL               
       LET g_rbr[l_ac].type = '0'      
       LET g_rbr[l_ac].before = '0'
       LET g_rbr[l_ac].after  = '1'
       LET g_rbr_t.*=g_rbr[l_ac].*
       LET g_rbr_o.* = g_rbr[l_ac].*
       SELECT MAX(rbr05)+1 INTO l_rbr05_curr 
         FROM rbr_file
        WHERE rbr01=g_argv1 AND rbr02=g_argv2 
          AND rbr03=g_argv3 AND rbr04=g_argv4
          AND rbrplant=g_argv5
       IF l_rbr05_curr IS NULL OR l_rbr05_curr=0 THEN
          LET l_rbr05_curr = 1
       END IF
       CALL cl_set_comp_entry("rbr08",p_cmd='a')  
       IF g_argv4='2' THEN
          LET g_rbr[l_ac].rbr07=0 
          CALL cl_set_comp_visible("dummy2,rbr07,rbr07_1",FALSE)
          NEXT FIELD rbr08
       ELSE
          NEXT FIELD rbr07
       END IF        
       
    AFTER INSERT
       IF INT_FLAG THEN
          CALL cl_err('',9001,0)
          LET INT_FLAG=0
          CANCEL INSERT
       END IF
       SELECT COUNT(*) INTO l_n FROM rbr_file
        WHERE rbr01=g_argv1  AND rbr02=g_argv2 
          AND rbr03=g_argv3  AND rbr04=g_argv4 
          AND rbrplant=g_argv5 
          AND rbr07=g_rbr[l_ac].rbr07 
          AND rbr08=g_rbr[l_ac].rbr08          
       IF l_n>0 THEN 
          CALL cl_err('',-239,0)
          NEXT FIELD rbr08
       END IF  
       IF NOT cl_null(g_rbr[l_ac].rbr08) THEN
          IF g_rbr[l_ac].type= '0' THEN
             INSERT INTO rbr_file(rbr01,rbr02,rbr03,rbr04,rbr05,rbr06,rbr07,rbr08,rbr09,rbr10,rbr11,rbracti,rbrplant,rbrlegal)
             VALUES(g_argv1,g_argv2,g_argv3,g_argv4,l_rbr05_curr,g_rbr[l_ac].after,g_rbr[l_ac].rbr07,g_rbr[l_ac].rbr08,
                    g_rbr[l_ac].rbr09,g_rbr[l_ac].rbr10,g_rbr[l_ac].rbr11,g_rbr[l_ac].rbracti,g_argv5,g_legal)
                 
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","rbr_file",g_rbr[l_ac].rbr08,"",SQLCA.sqlcode,"","",1)
                CANCEL INSERT
             ELSE
                #MESSAGE 'INSERT Ok'
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b To FORMONLY.cn1
             END IF
          ELSE
             INSERT INTO rbr_file(rbr01,rbr02,rbr03,rbr04,rbr05,rbr06,rbr07,rbr08,rbr09,rbr10,rbr11,rbracti,rbrplant,rbrlegal)
                VALUES(g_argv1,g_argv2,g_argv3,g_argv4,l_rbr05_curr,g_rbr[l_ac].before,g_rbr[l_ac].rbr07_1,
                       g_rbr[l_ac].rbr08_1,g_rbr[l_ac].rbr09_1,g_rbr[l_ac].rbr10_1,g_rbr[l_ac].rbr11_1,
                       g_rbr[l_ac].rbracti_1,g_argv5,g_legal)
                 
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","rbr_file",g_rbr[l_ac].rbr08,"",SQLCA.sqlcode,"","",1)
                CANCEL INSERT
             #ELSE
             #   MESSAGE 'INSERT Ok' 
             END IF
             INSERT INTO rbr_file(rbr01,rbr02,rbr03,rbr04,rbr05,rbr06,rbr07,rbr08,rbr09,rbr10,rbr11,rbracti,rbrplant,rbrlegal)
                VALUES(g_argv1,g_argv2,g_argv3,g_argv4,l_rbr05_curr,g_rbr[l_ac].after,g_rbr[l_ac].rbr07,g_rbr[l_ac].rbr08,
                       g_rbr[l_ac].rbr09,g_rbr[l_ac].rbr10,g_rbr[l_ac].rbr11,g_rbr[l_ac].rbracti,g_argv5,g_legal)
                 
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","rbr_file",g_rbr[l_ac].rbr08,"",SQLCA.sqlcode,"","",1)
                CANCEL INSERT
             ELSE
                #MESSAGE 'INSERT Ok'
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b To FORMONLY.cn1
             END IF
          END IF   
       END IF

       BEFORE FIELD rbr07
         IF g_argv4='2' THEN
            LET g_rbr[l_ac1].rbr07=0 
            NEXT FIELD rbr08
         ELSE
            IF cl_null(g_rbr[l_ac].rbr07) OR g_rbr[l_ac].rbr07 = 0 THEN 
               #TQC-C30004 mark START
               #SELECT MAX(rbr07)+1 INTO g_rbr[l_ac].rbr07 FROM rbr_file
               # WHERE rbr01=g_argv1 AND rbr02=g_argv2 
               #   AND rbr03=g_argv3 AND rbr04=g_argv4
               #   AND rbrplant=g_argv5                   
               #IF cl_null(g_rbr[l_ac].rbr07) THEN
               #   LET g_rbr[l_ac].rbr07=1
               #END IF
               #TQC-C30004 mark END
            END IF
         END IF
         
      AFTER FIELD rbr07
        IF NOT cl_null(g_rbr[l_ac].rbr07) THEN 
           IF p_cmd = 'a' OR (p_cmd = 'u' AND g_rbr[l_ac].rbr07 <> g_rbr_t.rbr07) THEN
              IF g_rbr[l_ac].rbr07 < = 0 THEN
                 CALL cl_err(g_rbr[l_ac].rbr07,'aec-994',0)
                 NEXT FIELD rbr07
              ELSE
                IF NOT cl_null(g_rbr[l_ac].rbr08) THEN   #TQC-C30004 add
                   SELECT COUNT(*) INTO l_n FROM rbr_file
                    WHERE rbr01=g_argv1 AND rbr02=g_argv2 
                      AND rbr03=g_argv3 AND rbr04=g_argv4
                      AND rbr07=g_rbr[l_ac].rbr07 
                      AND rbrplant=g_argv5
                      AND rbr08 = g_rbr[l_ac].rbr08  #TQC-C30004 add
                    IF l_n>0 THEN
                       CALL cl_err('',-239,0)
                       LET g_rbr[l_ac].rbr07=g_rbr_t.rbr07
                       NEXT FIELD rbr07
                    END IF
                END IF  #TQC-C30004 add
               #TQC-C30004 add START 
                IF g_argv4 = '3' THEN     #FUN-B30012 ADD
                   LET l_n = 0
                   SELECT COUNT(*) INTO l_n FROM rai_file
                    WHERE rai03 = g_rbr[l_ac].rbr07
                      AND rai01 = g_argv1
                      AND rai02 = g_argv2
                      AND raiplant = g_argv5
                   IF l_n=0 THEN
                      SELECT COUNT(*) INTO l_n FROM rbi_file
                       WHERE rbi06 = g_rbr[l_ac].rbr07
                         AND rbi01 = g_argv1
                         AND rbi02 = g_argv2
                         AND rbi03 = g_argv4  
                         AND rbiplant = g_argv5                      
                         CALL cl_err('','aec-040',0)
                         LET g_rbr[l_ac].rbr07 = NULL
                         NEXT FIELD rbr07
                   END IF
                END IF               
               #TQC-C30004 add END
                   END IF
                END IF
         END IF

      BEFORE FIELD rbr08
        IF cl_null(g_rbr[l_ac].rbr08) OR g_rbr[l_ac].rbr08 = 0 THEN
            SELECT MAX(rbr08)+1 INTO g_rbr[l_ac].rbr08 FROM rbr_file
             WHERE rbr01=g_argv1 AND rbr02=g_argv2
               AND rbr03=g_argv3 AND rbr04=g_argv4
               AND rar04=g_rbr[l_ac].rbr07 
               AND rbrplant=g_argv5              
            IF cl_null(g_rbr[l_ac].rbr08) THEN
               LET g_rbr[l_ac].rbr08=1
            END IF
         END IF

      AFTER FIELD rbr08
        IF NOT cl_null(g_rbr[l_ac].rbr08) THEN
           #TQC-C30004 add START
            IF NOT cl_null(g_rbr[l_ac].rbr07) THEN
               SELECT COUNT(*) INTO l_n FROM rbr_file
                WHERE rbr01=g_argv1 AND rbr02=g_argv2
                  AND rbr03=g_argv3 AND rbr04=g_argv4
                  AND rbr07=g_rbr[l_ac].rbr07
                  AND rbrplant=g_argv5
                  AND rbr08 = g_rbr[l_ac].rbr08  #TQC-C30004 add
                IF l_n>0 THEN
                   CALL cl_err('',-239,0)
                   LET g_rbr[l_ac].rbr07=g_rbr_t.rbr07
                   NEXT FIELD rbr07
                END IF               
            END IF
           #TQC-C30004 add END
            IF (g_rbr[l_ac].rbr08 <> g_rbr_t.rbr08 OR cl_null(g_rbr_t.rbr08)) THEN
                SELECT COUNT(*) INTO l_n FROM rar_file
                 WHERE rar01=g_argv1 AND rar02=g_argv2
                   AND rar03=g_argv4 AND rarplant=g_argv5
                   AND rar04=g_rbr[l_ac].rbr07 
                   AND rar05=g_rbr[l_ac].rbr08                   
                IF l_n=0 THEN
                    IF NOT cl_confirm('art-677') THEN   #確定新增?
                       NEXT FIELD rbr08
                    ELSE
                       CALL t403_giftb1_init()
                    END IF
                 ELSE
                    IF NOT cl_confirm('art-676') THEN   #確定修改?
                       NEXT FIELD rbr08
                    ELSE
                       CALL t403_giftb1_find()   
                    END IF           
                 END IF
           END IF
         END IF         

       AFTER FIELD rbr09
           IF NOT cl_null(g_rbr[l_ac].rbr09) THEN
              IF g_rbr[l_ac].rbr09<0 THEN
                 CALL cl_err(g_rbr[l_ac].rbr09,'art-184',0)
                 NEXT FIELD rbr09
              END IF
           END IF
       
       AFTER FIELD rbr10,rbr11
           IF FGL_DIALOG_GETBUFFER()<0 THEN
              CALL cl_err('','alm-342',0)
              NEXT FIELD CURRENT
           END IF 

       BEFORE DELETE                      
           IF NOT cl_null(g_rbr_t.rbr08) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF              
              SELECT COUNT(*) INTO l_n FROM rbs_file
               WHERE rbs01=g_argv1 AND rbs02=g_argv2 
                 AND rbs03=g_argv3 AND rbs04=g_argv4
                 AND rbs07=g_rbr[l_ac].rbr07
                 AND rbs08=g_rbr[l_ac].rbr08 
                 AND rbsplant=g_argv5
              IF l_n>0 THEN
                 CALL cl_err('','art-664',0)
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rbr_file
               WHERE rbr01=g_argv1 AND rbr02=g_argv2 AND rbr03=g_argv3
                 AND rbr04=g_argv4 AND rbr07=g_rbr[l_ac].rbr07
                 AND rbr08=g_rbr[l_ac].rbr08 AND rbrplant=g_argv5                 
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","rbr_file",g_rbr[l_ac].rbr08,'',SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn1
           END IF
           COMMIT WORK

       ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rbr[l_ac].* = g_rbr_t.*
              CLOSE t403_gift_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rbr[l_ac].rbr08,-263,1)
              LET g_rbr[l_ac].* = g_rbr_t.*
           ELSE           
              UPDATE rbr_file SET  rbr09 = g_rbr[l_ac].rbr09,
                                   rbr07 = g_rbr[l_ac].rbr07,  #TQC-C20564 add
                                   rbr08 = g_rbr[l_ac].rbr08,  #TQC-C20564 add
                                   rbr10 = g_rbr[l_ac].rbr10,
                                   rbr11 = g_rbr[l_ac].rbr11,
                                   rbracti = g_rbr[l_ac].rbracti
                WHERE rbr01=g_argv1 AND rbr02=g_argv2 AND rbr03=g_argv3
                  AND rbr07=g_rbr_t.rbr07 AND rbr08=g_rbr_t.rbr08
                  AND rbr06='1'
                  AND rbrplant=g_argv5  AND rbr04=g_argv4
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rbr_file",g_rbr_t.rbr08,'',SQLCA.sqlcode,"","",1) 
                 LET g_rbr[l_ac].* = g_rbr_t.*
              ELSE
                 #MESSAGE 'UPDATE O.K'
                #TQC-C20564 add START 
                 IF cl_null(g_rbr[l_ac].rbr08_1) THEN
                    DELETE FROM rbr_file 
                      WHERE rbr01=g_argv1 AND rbr02=g_argv2 AND rbr03=g_argv3
                        AND rbr07=g_rbr_t.rbr07 AND rbr08=g_rbr_t.rbr08
                        AND rbr06='0'
                        AND rbrplant=g_argv5  AND rbr04=g_argv4
                 ELSE 
                    UPDATE rbr_file SET  rbr09 = g_rbr[l_ac].rbr09_1,
                                         rbr10 = g_rbr[l_ac].rbr10_1,
                                         rbr11 = g_rbr[l_ac].rbr11_1,
                                         rbracti = g_rbr[l_ac].rbracti_1
                      WHERE rbr01=g_argv1 AND rbr02=g_argv2 AND rbr03=g_argv3
                        AND rbr07=g_rbr_t.rbr07 AND rbr08=g_rbr_t.rbr08
                        AND rbr06='0'
                        AND rbrplant=g_argv5  AND rbr04=g_argv4
                 END IF
                #TQC-C20564 add END 
                 COMMIT WORK
              END IF
           END IF    
 
       AFTER ROW
           LET l_ac = ARR_CURR()
          #FUN-D30033--mark---str---
          #IF cl_null(g_rbr[l_ac].rbr08) THEN
          #   CALL g_rbr.deleteelement(l_ac)
          #END IF
          #FUN-D30033--mark---end---
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rbr[l_ac].* = g_rbr_t.*
              #FUN-D30033--add--str--
              ELSE
                 CALL g_rbr.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end--
              END IF
              CLOSE t403_gift_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac   #FUN-D30033 Add
           CLOSE t403_gift_bcl
           COMMIT WORK
           
      ON ACTION CONTROLO                        
           IF INFIELD(rbr08) AND l_ac > 1 THEN
              LET g_rbr[l_ac].* = g_rbr[l_ac-1].*
              LET g_rec_b = g_rec_b + 1
              NEXT FIELD rbr08
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
 
        ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
    END INPUT  
    CLOSE t403_gift_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION t403_gift_b1()
    DEFINE  l_ac2_t         LIKE type_file.num5,
            l_cnt           LIKE type_file.num5,
            l_n             LIKE type_file.num5,
            l_lock_sw       LIKE type_file.chr1,
            p_cmd           LIKE type_file.chr1,
            l_allow_insert  LIKE type_file.num5,
            l_allow_delete  LIKE type_file.num5
    DEFINE  l_ima25         LIKE ima_file.ima25
    DEFINE  l_rbs05_curr    LIKE rbs_file.rbs05 
  #FUN-BC0078 add START
    DEFINE l_rtz04      LIKE rtz_file.rtz04    
    DEFINE l_cnt2        LIKE type_file.num5    
  #FUN-BC0078 add END
    LET g_action_choice=""
    IF s_shut(0) THEN 
       RETURN
    END IF
    IF g_argv6<>'N' THEN
       CALL cl_err('','apm-267',0)
       RETURN 
    END IF   
    CALL cl_opmsg('b')   
   
    LET g_forupd_sql = " SELECT * ",
                       "   FROM rbs_file ",
                       "  WHERE rbs01 = ? AND rbs02 = ?  AND rbs03 = ? ",
                       "    AND rbs04=?   AND rbsplant=? AND rbs07=? AND rbs08=?",  
                       "    AND rbs09=?   AND rbs10=?  AND rbs06='1'", 
                       "    FOR UPDATE   "                   
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t4031_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_ac2_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
        
    INPUT ARRAY g_rbs WITHOUT DEFAULTS FROM s_rbs.*
    ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
              INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
              APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           #DISPLAY "BEFORE INPUT!"
           IF g_rec_b2 != 0 THEN
              CALL fgl_set_arr_curr(l_ac2)
           END IF
 
        BEFORE ROW
           #DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac2 = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()           
 
           BEGIN WORK           
           IF g_rec_b2 >= l_ac2 THEN
              LET p_cmd='u'
              LET g_rbs_t.* = g_rbs[l_ac2].*  #BACKUP
              LET g_rbs_o.* = g_rbs[l_ac2].*  #BACKUP
              IF p_cmd='u' THEN
                 CALL cl_set_comp_entry("rbs07",FALSE)
              ELSE
                 CALL cl_set_comp_entry("rbs07",TRUE)
              END IF
              CALL t403_rbs09()   
              OPEN t4031_bcl USING g_argv1,g_argv2,g_argv3,g_argv4,g_argv5,g_rbs_t.rbs07,g_rbs_t.rbs08,
                                   g_rbs_t.rbs09,g_rbs_t.rbs10
              IF STATUS THEN
                 CALL cl_err("OPEN t4031_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 #FETCH t4031_bcl INTO l_rbs05_curr,g_rbs[l_ac2].*
                 SELECT b.rbs05,'',a.rbs06,a.rbs07,a.rbs08,a.rbs09,a.rbs10,'',a.rbs11,'',a.rbs12,a.rbsacti,  #FUN-BC0078 add rbs12
                        b.rbs06,b.rbs07,b.rbs08,b.rbs09,b.rbs10,'',b.rbs11,'',b.rbs12,b.rbsacti  #FUN-BC0078 add rbs12
                   INTO l_rbs05_curr,g_rbs[l_ac2].*     
                   FROM rbs_file b LEFT OUTER JOIN rbs_file a
                     ON (b.rbs01=a.rbs01 AND b.rbs02=a.rbs02 AND b.rbs03=a.rbs03 AND b.rbs04=a.rbs04 
                    AND b.rbs05=a.rbs05  AND b.rbs07=a.rbs07 AND b.rbs08=a.rbs08 AND b.rbsplant=a.rbsplant 
                    AND b.rbs06<>a.rbs06 ) 
                  WHERE b.rbs01 =g_argv1 AND b.rbs02 =g_argv2 AND b.rbs03 =g_argv3  
                    AND b.rbs04=g_argv4  AND b.rbsplant=g_argv5  AND b.rbs06='1'      
                    AND b.rbs07=g_rbs_t.rbs07  AND b.rbs08=g_rbs_t.rbs08
                    AND b.rbs09=g_rbs_t.rbs09  AND b.rbs10=g_rbs_t.rbs10
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rbs_t.rbs08,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 IF g_rbs[l_ac2].before1='0' THEN
                   LET g_rbs[l_ac2].type1 ='1'
                 ELSE
                   LET g_rbs[l_ac2].type1 ='0'
                END IF    
                CALL t403_rbs10('d',l_ac2)
                CALL t403_rbs10_1('d',l_ac2)
                CALL t403_rbs11('d')
              END IF
           END IF 
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            SELECT COUNT(*) INTO l_n FROM rbs_file
             WHERE rbs01=g_argv1  AND rbs02=g_argv2 
               AND rbs03=g_argv3  AND rbs04=g_argv4 
               AND rbsplant=g_argv5 
               AND rbs07=g_rbs[l_ac2].rbs07 
               AND rbs08=g_rbs[l_ac2].rbs08
               AND rbs09=g_rbs[l_ac2].rbs09          
            IF l_n>0 THEN 
               CALL cl_err('',-239,0)
               NEXT FIELD rbs08
            END IF  
            IF cl_null(g_rbs[l_ac2].rbs12) THEN LET g_rbs[l_ac2].rbs12 = 0 END IF #FUN-BC0078 add  
            IF g_rbs[l_ac2].type1= '0' THEN
               INSERT INTO rbs_file(rbs01,rbs02,rbs03,rbs04,rbs05,rbs06,rbs07,rbs08,
                                    rbs09,rbs10,rbs11,rbs12, rbsacti,rbsplant,rbslegal)  #FUN-BC0078 add rbs12
               VALUES(g_argv1,g_argv2,g_argv3,g_argv4,l_rbs05_curr,g_rbs[l_ac2].after1,
                      g_rbs[l_ac2].rbs07,g_rbs[l_ac2].rbs08,g_rbs[l_ac2].rbs09,g_rbs[l_ac2].rbs10,g_rbs[l_ac2].rbs11, 
                      g_rbs[l_ac2].rbs12,g_rbs[l_ac2].rbsacti,g_argv5,g_legal)   #FUN-BC0078 add rbs12
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("ins","rbs_file",g_argv2||g_rbs[l_ac2].after1||g_rbs[l_ac2].rbs08,"",SQLCA.sqlcode,"","",1)
                  CANCEL INSERT
               ELSE
                  #MESSAGE 'INSERT O.K'
                  COMMIT WORK
                  LET g_rec_b2=g_rec_b2+1
                  DISPLAY g_rec_b2 TO FORMONLY.cn2
               END IF           
            ELSE
               INSERT INTO rbs_file(rbs01,rbs02,rbs03,rbs04,rbs05,rbs06,rbs07,rbs08,
                                    rbs09,rbs10,rbs11,rbs12, rbsacti,rbsplant,rbslegal)  #FUN-BC0078 add rbs12
               VALUES(g_argv1,g_argv2,g_argv3,g_argv4,l_rbs05_curr,g_rbs[l_ac2].after1,
                      g_rbs[l_ac2].rbs07,g_rbs[l_ac2].rbs08,g_rbs[l_ac2].rbs09,g_rbs[l_ac2].rbs10,g_rbs[l_ac2].rbs11, 
                      g_rbs[l_ac2].rbs12,g_rbs[l_ac2].rbsacti,g_argv5,g_legal)   #FUN-BC0078 add rbs12
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("ins","rbs_file",g_argv2||g_rbs[l_ac2].after1||g_rbs[l_ac2].rbs08,"",SQLCA.sqlcode,"","",1)
                  CANCEL INSERT 
               #ELSE
               #   MESSAGE 'INSERT value.after O.K' 
               END IF
               INSERT INTO rbs_file(rbs01,rbs02,rbs03,rbs04,rbs05,rbs06,rbs07,rbs08,
                                    rbs09,rbs10,rbs11,rbs12, rbsacti,rbsplant,rbslegal)  #FUN-BC0078 add rbs12
               VALUES(g_argv1,g_argv2,g_argv3,g_argv4,l_rbs05_curr,g_rbs[l_ac2].before1,
                      g_rbs[l_ac2].rbs07_1,g_rbs[l_ac2].rbs08_1,g_rbs[l_ac2].rbs09_1,g_rbs[l_ac2].rbs10_1,
                      g_rbs[l_ac2].rbs11_1,g_rbs[l_ac2].rbs12,g_rbs[l_ac2].rbsacti_1,g_argv5,g_legal)  #FUN-BC0078 add rbs12
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("ins","rbs_file",g_argv2||g_rbs[l_ac2].before1||g_rbs[l_ac2].rbs08_1,"",SQLCA.sqlcode,"","",1)
                  CANCEL INSERT               
               ELSE
                  #MESSAGE 'INSERT value.before O.K'
                  COMMIT WORK
                  LET g_rec_b2=g_rec_b2+1
                  DISPLAY g_rec_b2 TO FORMONLY.cn2
               END IF
            END IF
            
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_rbs[l_ac2].* TO NULL 
            LET g_rbs[l_ac2].type1 = '0'      
            LET g_rbs[l_ac2].before1 = '0'
            LET g_rbs[l_ac2].after1  = '1'  
            LET g_rbs[l_ac2].rbsacti = 'Y'              
            LET g_rbs_t.* = g_rbs[l_ac2].*         #新輸入資料
            LET g_rbs_o.* = g_rbs[l_ac2].*         #新輸入資料
            SELECT MAX(rbs05)+1 INTO l_rbs05_curr 
              FROM rbs_file
             WHERE rbs01=g_argv1 AND rbs02=g_argv2 
               AND rbs03=g_argv3 AND rbs04=g_argv4
               AND rbsplant=g_argv5
              IF l_rbs05_curr IS NULL OR l_rbs05_curr=0 THEN
                 LET l_rbs05_curr = 1
              END IF
            IF p_cmd='u' THEN
               CALL cl_set_comp_entry("rbs07",FALSE)
            ELSE
               CALL cl_set_comp_entry("rbs07",TRUE)
            END IF
            IF g_argv4='2' THEN
               LET g_rbs[l_ac2].rbs07=0 
               CALL cl_set_comp_visible("dummy9,rbs07,rbs07_1",FALSE)
               NEXT FIELD rbs08
            ELSE
               NEXT FIELD rbs07
            END IF 

       BEFORE FIELD rbs07
          IF g_argv4='2' THEN
             LET g_rbs[l_ac2].rbs07=0 
             NEXT FIELD rbs08
          ELSE
             IF cl_null(g_rbs[l_ac2].rbs07) OR g_rbs[l_ac2].rbs07 = 0 THEN 
                SELECT MAX(rbs07)+1 INTO g_rbs[l_ac2].rbs07 FROM rbs_file
                 WHERE rbs01=g_argv1 AND rbs02=g_argv2 
                   AND rbs03=g_argv3 AND rbs04=g_argv4
                   AND rbsplant=g_argv5                   
                IF cl_null(g_rbs[l_ac2].rbs07) THEN
                   LET g_rbs[l_ac2].rbs07=1
                END IF
            END IF
         END IF
         
      AFTER FIELD rbs07
        IF NOT cl_null(g_rbs[l_ac2].rbs07) THEN 
           IF p_cmd = 'a' OR (p_cmd = 'u' AND g_rbs[l_ac2].rbs07 <> g_rbs_t.rbs07) THEN
              IF g_rbs[l_ac2].rbs07 < = 0 THEN
                 CALL cl_err(g_rbs[l_ac2].rbs07,'aec-994',0)
                 NEXT FIELD rbs07
              ELSE
               #FUN-BC0078 mark START
               #SELECT COUNT(*) INTO l_n FROM rbs_file
               # WHERE rbs01=g_argv1 AND rbs02=g_argv2 
               #   AND rbs03=g_argv3 AND rbs04=g_argv4
               #   AND rbs07=g_rbs[l_ac2].rbs07 
               #   AND rbsplant=g_argv5
               # IF l_n>0 THEN
               #    CALL cl_err('',-239,0)
               #    LET g_rbs[l_ac2].rbs07=g_rbs_t.rbs07
               #    NEXT FIELD rbs07
               #END IF
               #FUN-BC0078 mark END
               #FUN-BC0078 add START
                LET l_n = 0 
                SELECT COUNT(*) INTO l_n FROM rbr_file 
                  WHERE rbr01 = g_argv1 AND rbr02 = g_argv2 
                    AND rbr03 = g_argv3 AND rbr07 = g_rbs[l_ac2].rbs07
                    AND rbr04 = g_argv4
                    AND rbrplant = g_argv5 
                IF l_n < 1 OR cl_null(l_n) THEN 
                   SELECT COUNT(*) INTO l_n FROM rar_file
                     WHERE rar01 = g_argv1 AND rar02 = g_argv2
                       AND rar03 = g_argv4 AND rarplant = g_argv5
                       AND rar04 = g_rbs[l_ac2].rbs07
                   IF l_n < 1 OR cl_null(l_n) THEN
                      CALL cl_err('','aec-040',0)
                      NEXT FIELD rbs07
                   END IF
                END IF
               #FUN-BC0078 add END
              END IF
           END IF
         END IF   
 
      AFTER FIELD rbs08
         IF NOT cl_null(g_rbs[l_ac2].rbs08) THEN
            IF g_rbs_o.rbs08 IS NULL OR
               (g_rbs[l_ac2].rbs08 != g_rbs_o.rbs08 ) THEN
               CALL t403_rbs08()    #檢查其有效性          
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rbs[l_ac2].rbs08,g_errno,0)
                  LET g_rbs[l_ac2].rbs08 = g_rbs_o.rbs08
                  LET g_errno = ' '   #TQC-C30055 add
                  NEXT FIELD rbs08
               END IF
               IF NOT cl_null(g_rbs[l_ac2].rbs09) THEN
                  SELECT COUNT(*) INTO l_n 
                   FROM ras_file
                  WHERE ras01=g_argv1 AND ras02=g_argv2
                    AND rasplant=g_argv5 
                    AND ras03=g_argv4
                    AND ras04=g_rbs[l_ac2].rbs07
                    AND ras05=g_rbs[l_ac2].rbs08 
                    AND ras06=g_rbs[l_ac2].rbs09 
                  IF l_n=0 THEN
                     IF NOT cl_confirm('art-678') THEN
                        NEXT FIELD rbs08
                     ELSE
                        CALL t403_giftb2_init()
                     END IF
                  ELSE
                     IF NOT cl_confirm('art-679') THEN
                        NEXT FIELD rbs08
                     ELSE
                        CALL t403_giftb2_find()   
                     END IF           
                  END IF
               END IF  
            END IF  
         END IF
      
      AFTER FIELD rbs09
         IF NOT cl_null(g_rbs[l_ac2].rbs09) THEN
            IF g_rbs_o.rbs09 IS NULL OR
               (g_rbs[l_ac2].rbs09 != g_rbs_o.rbs09 ) THEN
               IF NOT cl_null(g_rbs[l_ac2].rbs08) THEN
                  SELECT COUNT(*) INTO l_n 
                   FROM ras_file
                  WHERE ras01=g_argv1 AND ras02=g_argv2
                    AND rasplant=g_argv5 
                    AND ras03=g_argv4
                    AND ras04=g_rbs[l_ac2].rbs07
                    AND ras05=g_rbs[l_ac2].rbs08 
                    AND ras06=g_rbs[l_ac2].rbs09 
                  IF l_n=0 THEN
                     IF NOT cl_confirm('art-678') THEN    #確定新增?
                        NEXT FIELD rbs09
                     ELSE
                        CALL t403_giftb2_init()
                     END IF
                  ELSE
                     IF NOT cl_confirm('art-679') THEN    #確定修改?
                        NEXT FIELD rbs09
                     ELSE
                        CALL t403_giftb2_find()   
                     END IF           
                  END IF
               END IF  
               CALL t403_rbs09() 
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rbs[l_ac2].rbs09,g_errno,0)
                  LET g_rbs[l_ac2].rbs09 = g_rbs_o.rbs09
                  LET g_errno = ' '   #TQC-C30055 add
                  NEXT FIELD rbs09
               END IF
            END IF  
         END IF  

      ON CHANGE rbs09
         IF NOT cl_null(g_rbs[l_ac2].rbs09) THEN
            CALL t403_rbs09()   
            LET g_rbs[l_ac2].rbs10=NULL
            LET g_rbs[l_ac2].rbs10_desc=NULL
            LET g_rbs[l_ac2].rbs11=NULL
            LET g_rbs[l_ac2].rbs11_desc=NULL
            DISPLAY BY NAME g_rbs[l_ac2].rbs10,g_rbs[l_ac2].rbs10_desc
            DISPLAY BY NAME g_rbs[l_ac2].rbs11,g_rbs[l_ac2].rbs11_desc
         END IF
  
      BEFORE FIELD rbs10,rbs11
         IF NOT cl_null(g_rbs[l_ac2].rbs09) THEN
            CALL t403_rbs09()            
         END IF

      AFTER FIELD rbs10
         IF NOT cl_null(g_rbs[l_ac2].rbs10) THEN
#FUN-AB0025 ---------------------start----------------------------
            IF g_rbs[l_ac2].rbs09="01" THEN
               IF NOT s_chk_item_no(g_rbs[l_ac2].rbs10,"") THEN 
                  CALL cl_err('',g_errno,1)
                  LET g_rbs[l_ac2].rbs10= g_rbs_t.rbs10
                  LET g_errno = ' '   #TQC-C30055 add
                  NEXT FIELD rbs10
               END IF
            END IF
#FUN-AB0025 ---------------------end-------------------------------
            IF g_rbs_o.rbs10 IS NULL OR
              #(g_rbs[l_ac2].rbs08 != g_rbs_o.rbs10 ) THEN
               (g_rbs[l_ac2].rbs10 <> g_rbs_o.rbs10 ) THEN  #TQC-C20564 add 
               CALL t403_rbs10('a',l_ac2) 
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rbs[l_ac2].rbs10,g_errno,0)
                  LET g_rbs[l_ac2].rbs10 = g_rbs_o.rbs10
                  LET g_errno = ' '   #TQC-C30055 add
                  NEXT FIELD rbs10
               END IF
            END IF  
         #FUN-BC0078 add START
            IF g_rbs[l_ac2].rbs09 = '01' THEN
               SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01 = g_plant
               LET l_cnt2 = 0
               IF NOT cl_null(l_rtz04) THEN  #TQC-D40014 add
                  SELECT COUNT(*) INTO l_cnt2 FROM rte_file
                    WHERE rte03 = g_rbs[l_ac2].rbs10 AND rte01 = l_rtz04
                  IF l_cnt2 < 1 OR cl_null(l_cnt2) THEN
                     CALL cl_err('','art-389', 0 )
                     NEXT FIELD rbs10
                  END IF
               END IF  #TQC-D40014 add
            END IF
         #FUN-BC0078 add END
         END IF  

      AFTER FIELD rbs11
         IF NOT cl_null(g_rbs[l_ac2].rbs11) THEN
            IF g_rbs_o.rbs11 IS NULL OR
               (g_rbs[l_ac2].rbs11 != g_rbs_o.rbs11 ) THEN
               CALL t403_rbs11('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rbs[l_ac2].rbs11,g_errno,0)
                  LET g_rbs[l_ac2].rbs11 = g_rbs_o.rbs11
                  LET g_errno = ' '   #TQC-C30055 add
                  NEXT FIELD rbs11
               END IF
            END IF  
         END IF        
    
     #FUN-BC0078 add START
      AFTER FIELD rbs12
         IF NOT cl_null(g_rbs[l_ac2].rbs12) AND NOT cl_null(g_rbs[l_ac2].rbs09)THEN
            IF g_rbs[l_ac2].rbs09 = '11'THEN
               IF g_rbs[l_ac2].rbs12 <= 0 THEN
                  CALL cl_err('','art-778',0)
                  NEXT FIELD rbs12
               END IF
            END IF
         END IF
     #FUN-BC0078 add END
        
        BEFORE DELETE
           #DISPLAY "BEFORE DELETE"
           IF g_rbs_t.rbs08 > 0 AND g_rbs_t.rbs08 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rbs_file
               WHERE rbs02 = g_argv2 AND rbs01 = g_argv1
                 AND rbs03 = g_argv3 AND rbs04 = g_argv4
                 AND rbs07 = g_rbs_t.rbs07 AND rbs08 = g_rbs_t.rbs08 
                 AND rbsplant = g_argv5    AND rbs05 = l_rbs05_curr 
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rbs_file",g_argv2,g_rbs_t.rbs08,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b2=g_rec_b2-1
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rbs[l_ac2].* = g_rbs_t.*
              CLOSE t4031_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF

           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rbs[l_ac2].rbs08,-263,1)
              LET g_rbs[l_ac2].* = g_rbs_t.*
           ELSE
              IF g_rbs[l_ac2].rbs07<>g_rbs_t.rbs07 OR
                 g_rbs[l_ac2].rbs08<>g_rbs_t.rbs08 OR
                 g_rbs[l_ac2].rbs09<>g_rbs_t.rbs09 THEN
                 SELECT COUNT(*) INTO l_n FROM rbs_file
                  WHERE rbs01 =g_argv1 AND rbs02 = g_argv2
                    AND rbs03=g_argv3  AND rbs04=g_argv4
                    AND rbs07 = g_rbs[l_ac2].rbs07 
                    AND rbs08 = g_rbs[l_ac2].rbs08 
                    AND rbs09 = g_rbs[l_ac2].rbs09
                    AND rbsplant = g_argv5
                 IF l_n>0 THEN 
                    CALL cl_err('',-239,0)
                   #LET g_rbs[l_ac2].* = g_rbs_t.*
                    NEXT FIELD rbs08
                 END IF
              END IF
              IF cl_null(g_rbs[l_ac2].rbs12) THEN LET g_rbs[l_ac2].rbs12 = 0 END IF
              UPDATE rbs_file SET rbs08=g_rbs[l_ac2].rbs08,
                                  rbs09=g_rbs[l_ac2].rbs09,
                                  rbs10=g_rbs[l_ac2].rbs10,
                                  rbs11=g_rbs[l_ac2].rbs11,
                                  rbs12=g_rbs[l_ac2].rbs12, #FUN-BC0078 add
                                  rbsacti=g_rbs[l_ac2].rbsacti
               WHERE rbs02 = g_argv2 AND rbs01=g_argv1 AND rbs03=g_argv3 
                 AND rbs04 = g_argv4 AND rbs06='1' AND rbs07=g_rbs_t.rbs07
                 AND rbs08=g_rbs_t.rbs08 AND rbs09=g_rbs_t.rbs09 AND rbsplant = g_argv5
                 AND rbs10=g_rbs_t.rbs10
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rbs_file",g_argv2,g_rbs_t.rbs08,SQLCA.sqlcode,"","",1) 
                 LET g_rbs[l_ac2].* = g_rbs_t.*
              ELSE                
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK                
              END IF
           END IF
 
        AFTER ROW
           #DISPLAY  "AFTER ROW!!"
           LET l_ac2 = ARR_CURR()
          #LET l_ac2_t = l_ac2     #FUN-D30033 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rbs[l_ac2].* = g_rbs_t.*
              #FUN-D30033--add--str--
              ELSE
                 CALL g_rbs.deleteElement(l_ac2)
                 IF g_rec_b2 != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac2 = l_ac2_t
                 END IF
              #FUN-D30033--add--end--
              END IF
              CLOSE t4031_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac2_t = l_ac2     #FUN-D30033 Add 
          #CALL t403_repeat(g_rbs[l_ac2].rbs06)  #check
           CLOSE t4031_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO
           IF INFIELD(rbs08) AND l_ac2 > 1 THEN
              LET g_rbs[l_ac2].* = g_rbs[l_ac2-1].*
              LET g_rec_b2 = g_rec_b2+1
             #LET l_rbs04_curr=l_rbs04_curr+1
              NEXT FIELD rbs08
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
             WHEN INFIELD(rbs10)
                 CALL cl_init_qry_var()
                 CASE g_rbs[l_ac2].rbs09
                    WHEN '01'
                       IF cl_null(g_rtz.rtz05) THEN
#FUN-AA0059---------mod------------str-----------------                       
#                         LET g_qryparam.form="q_ima"              #FUN-AB0025 mark
                          CALL q_sel_ima(FALSE, "q_ima","",g_rbs[l_ac2].rbs10,"","","","","",'' ) 
                              RETURNING g_rbs[l_ac2].rbs10
#FUN-AA0059---------mod------------end-----------------                          
                       ELSE
                          LET g_qryparam.form = "q_rtg03_1" 
                          LET g_qryparam.arg1 = g_rtz.rtz05  
                       END IF
                    WHEN '02'
                       LET g_qryparam.form ="q_oba01"
                    WHEN '03'
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '1'
                    WHEN '04'
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '2'
                    WHEN '05'
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '3'
                    WHEN '06'
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '4'
                    WHEN '07'
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '5'
                    WHEN '08'
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '6'
                    WHEN '09'
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '27'
                  #FUN-BC0078 add START
                    WHEN '10'
                       LET g_qryparam.form ="q_lpx02"
                  #FUN-BC0078 add END
                 END CASE
                 IF g_rbs[l_ac2].rbs09 != '01' OR (g_rbs[l_ac2].rbs09 = '01' AND NOT cl_null(g_rtz.rtz05)) THEN #FUN-AA0059 ADD
                    LET g_qryparam.default1 = g_rbs[l_ac2].rbs10
                    CALL cl_create_qry() RETURNING g_rbs[l_ac2].rbs10
                 END IF   #FUN-AA0059
                 CALL t403_rbs10('d',l_ac2)
                 NEXT FIELD rbs10
              WHEN INFIELD(rbs11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe02"
                 SELECT DISTINCT ima25
                   INTO l_ima25
                   FROM ima_file
                  WHERE ima01=g_rbs[l_ac2].rbs10  
                 LET g_qryparam.arg1 = l_ima25
                 LET g_qryparam.default1 = g_rbs[l_ac2].rbs11
                 CALL cl_create_qry() RETURNING g_rbs[l_ac2].rbs11
                 CALL t403_rbs11('d')
                 NEXT FIELD rbs11
              OTHERWISE EXIT CASE
            END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
            RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
 
      ON ACTION controls         
         CALL cl_set_head_visible("","AUTO")
    END INPUT     
    CLOSE t4031_bcl
    COMMIT WORK
   
END FUNCTION
 
FUNCTION t403_gift_b1_fill(p_wc2)
    DEFINE   p_wc2       STRING        
   
    LET g_sql = "SELECT '',a.rbs06,a.rbs07,a.rbs08,a.rbs09,a.rbs10,'',a.rbs11,'',a.rbs12,a.rbsacti, ",  #FUN-BC0078 add rbs12
                "          b.rbs06,b.rbs07,b.rbs08,b.rbs09,b.rbs10,'',b.rbs11,'',b.rbs12,b.rbsacti  ",  #FUN-BC0078 add rbs12
                " FROM rbs_file b LEFT OUTER JOIN rbs_file a  ",
                "   ON ( b.rbs01=a.rbs01 AND b.rbs02=a.rbs02 AND b.rbs03=a.rbs03 AND b.rbsplant=a.rbsplant ",
                "        AND b.rbs04=a.rbs04 AND b.rbs05=a.rbs05 AND b.rbs07=a.rbs07 AND b.rbs08=a.rbs08
                         AND b.rbs06<>a.rbs06 )",
                " WHERE b.rbs01='",g_argv1 CLIPPED,"' AND b.rbs02='",g_argv2 CLIPPED,"'",
                "   AND b.rbs03='",g_argv3 CLIPPED,"' AND b.rbs04='",g_argv4 CLIPPED,"'",
                "   AND b.rbsplant='",g_argv5 CLIPPED,"'" ,
                "   AND b.rbs06='1' "    
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    LET g_sql=g_sql CLIPPED," ORDER BY b.rbs05 "
    
    PREPARE t403_gift_pb1 FROM g_sql
    DECLARE rbs_cs CURSOR FOR t403_gift_pb1
 
    CALL g_rbs.clear()
    LET g_cnt = 1
    #MESSAGE "Searching!"
    FOREACH rbs_cs INTO g_rbs[g_cnt].*  
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
        EXIT FOREACH
        END IF
        IF g_rbs[g_cnt].before1='0' THEN
           LET g_rbs[g_cnt].type1='1'
        ELSE 
           LET g_rbs[g_cnt].type1='0'
        END IF           
        SELECT gfe02 INTO g_rbs[g_cnt].rbs11_desc FROM gfe_file
           WHERE gfe01 = g_rbs[g_cnt].rbs11
        SELECT gfe02 INTO g_rbs[g_cnt].rbs11_1_desc FROM gfe_file
           WHERE gfe01 = g_rbs[g_cnt].rbs11 
        #DISPLAY BY NAME  g_rbs[g_cnt].rbs07_1,g_rbs[g_cnt].rbs08_1,g_rbs[g_cnt].rbs09_1,g_rbs[g_cnt].rbs10_1,
        #                 g_rbs[g_cnt].rbs11_1,g_rbs[g_cnt].rbsacti_1,
        #                 g_rbs[g_cnt].rbs07,g_rbs[g_cnt].rbs08,g_rbs[g_cnt].rbs09,g_rbs[g_cnt].rbs10,
        #                 g_rbs[g_cnt].rbs11,g_rbs[g_cnt].rbsacti
        #DISPLAY BY NAME  g_rbs[g_cnt].type1,g_rbs[g_cnt].before1,g_rbs[g_cnt].after1   
        #CALL t403_rbs10('d',g_cnt)
        #CALL t403_rbs10_1('d',g_cnt)    
       #TQC-C20564 add START
         CALL t403_rbs10('d',g_cnt)
         CALL t403_rbs10_1('d',g_cnt)
       #TQC-C20564 add END
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH 
    IF g_argv4='2' THEN
       CALL cl_set_comp_visible("dummy9,rbs07,rbs07_1",FALSE)       
    END IF
    CALL g_rbs.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION t403_gift_b_fill(p_wc1)              
    DEFINE   p_wc1       STRING        
   
    LET g_sql = "SELECT '',a.rbr06,a.rbr07,a.rbr08,a.rbr09,a.rbr10,a.rbr11,a.rbracti, ",
                "          b.rbr06,b.rbr07,b.rbr08,b.rbr09,b.rbr10,b.rbr11,b.rbracti  ",
                " FROM rbr_file b LEFT OUTER JOIN rbr_file a  ",
                "   ON ( b.rbr01=a.rbr01 AND b.rbr02=a.rbr02 AND b.rbr03=a.rbr03 AND b.rbrplant=a.rbrplant ",
                "        AND b.rbr04=a.rbr04 AND b.rbr05=a.rbr05 AND b.rbr07=a.rbr07 AND b.rbr08=a.rbr08
                         AND b.rbr06<>a.rbr06 )",
                " WHERE b.rbr01='",g_argv1 CLIPPED,"' AND b.rbr02='",g_argv2 CLIPPED,"'",
                "   AND b.rbr03='",g_argv3 CLIPPED,"' AND b.rbr04='",g_argv4 CLIPPED,"'",
                "   AND b.rbrplant='",g_argv5 CLIPPED,"'" ,
                "   AND b.rbr06='1' "    
    IF NOT cl_null(p_wc1) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc1 CLIPPED
    END IF
    LET g_sql=g_sql CLIPPED," ORDER BY b.rbr05 "

    PREPARE t403_gift_pb FROM g_sql
    DECLARE rbr_cs CURSOR FOR t403_gift_pb
 
    CALL g_rbr.clear()
    LET g_cnt = 1
    #MESSAGE "Searching!"
    FOREACH rbr_cs INTO g_rbr[g_cnt].*  
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
        EXIT FOREACH
        END IF
        IF g_rbr[g_cnt].before='0' THEN
           LET g_rbr[g_cnt].type='1'
        ELSE 
           LET g_rbr[g_cnt].type='0'
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    IF g_argv4='2' THEN
       CALL cl_set_comp_visible("dummy2,rbr07,rbr07_1",FALSE)       
    END IF
    CALL g_rbr.deleteElement(g_cnt)
    #MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn1
    LET g_cnt = 0
END FUNCTION

FUNCTION t403_giftb1_init() 
    LET g_rbr[l_ac].type    ='0'
    LET g_rbr[l_ac].before  =' '
    LET g_rbr[l_ac].after   ='1'    
    LET g_rbr[l_ac].rbracti = 'Y'
    LET g_rbr[l_ac].rbr07_1 = NULL
    LET g_rbr[l_ac].rbr08_1 = NULL
    LET g_rbr[l_ac].rbr09_1 = NULL
    LET g_rbr[l_ac].rbr10_1 = NULL 
    LET g_rbr[l_ac].rbr11_1 = NULL     
    LET g_rbr[l_ac].rbracti_1 = NULL   
END FUNCTION

FUNCTION t403_giftb1_find()
   LET g_rbr[l_ac].type  ='1'
   LET g_rbr[l_ac].before='0'
   LET g_rbr[l_ac].after ='1'

   IF g_argv4 = '2' THEN #FUN-BC0078 add 
      SELECT rar04,rar05,rar06,rar07,rar08,raracti 
        INTO g_rbr[l_ac].rbr07_1,g_rbr[l_ac].rbr08_1,g_rbr[l_ac].rbr09_1,g_rbr[l_ac].rbr10_1,
             g_rbr[l_ac].rbr11_1,g_rbr[l_ac].rbracti_1
        FROM rar_file
       WHERE rar01=g_argv1 
         AND rar02=g_argv2
         AND rar03=g_argv4      
         AND rarplant=g_argv5
         AND rar05 = g_rbr[l_ac].rbr08
   #FUN-BC0078 add START
   ELSE
      SELECT rar04,rar05,rar06,rar07,rar08,raracti
        INTO g_rbr[l_ac].rbr07_1,g_rbr[l_ac].rbr08_1,g_rbr[l_ac].rbr09_1,g_rbr[l_ac].rbr10_1,
             g_rbr[l_ac].rbr11_1,g_rbr[l_ac].rbracti_1
        FROM rar_file
       WHERE rar01=g_argv1
         AND rar02=g_argv2
         AND rar03=g_argv4
         AND rarplant=g_argv5
         AND rar05 = g_rbr[l_ac].rbr08
        #AND rar06 = g_rbr[l_ac].rbr09  #TQC-C30004 mark
         AND rar04 = g_rbr[l_ac].rbr07  #TQC-C30004 add
   END IF   
    LET g_rbr[l_ac].rbr07 = g_rbr[l_ac].rbr07_1
    LET g_rbr[l_ac].rbr08 = g_rbr[l_ac].rbr08_1 
    LET g_rbr[l_ac].rbr09 = g_rbr[l_ac].rbr09_1 
    LET g_rbr[l_ac].rbr10 = g_rbr[l_ac].rbr10_1 
    LET g_rbr[l_ac].rbr11 = g_rbr[l_ac].rbr11_1  
    LET g_rbr[l_ac].rbracti = g_rbr[l_ac].rbracti_1 
   DISPLAY BY NAME  g_rbr[l_ac].rbr08,g_rbr[l_ac].rbr09,g_rbr[l_ac].rbr10,
                    g_rbr[l_ac].rbr11,g_rbr[l_ac].rbracti
   #FUN-BC0078 add END
   DISPLAY BY NAME  g_rbr[l_ac].rbr07_1,g_rbr[l_ac].rbr08_1,g_rbr[l_ac].rbr09_1,g_rbr[l_ac].rbr10_1,
                    g_rbr[l_ac].rbr11_1,g_rbr[l_ac].rbracti_1
   DISPLAY BY NAME  g_rbr[l_ac].type,g_rbr[l_ac].before,g_rbr[l_ac].after       
END FUNCTION 

FUNCTION t403_giftb2_init()
   LET g_rbs[l_ac2].type1    ='0'
   LET g_rbs[l_ac2].before1  =' '
   LET g_rbs[l_ac2].after1   ='1'
   LET g_rbs[l_ac2].rbs07_1 = NULL
   LET g_rbs[l_ac2].rbs08_1 = NULL
   LET g_rbs[l_ac2].rbs09_1 = NULL
   LET g_rbs[l_ac2].rbs10_1 = NULL
   LET g_rbs[l_ac2].rbs10_1_desc = NULL
   LET g_rbs[l_ac2].rbs11_1 = NULL
   LET g_rbs[l_ac2].rbs11_1_desc = NULL
   LET g_rbs[l_ac2].rbs12 = 0  #FUN-BC0078 add
   LET g_rbs[l_ac2].rbsacti_1 = NULL
   CALL t403_rbs09()
END FUNCTION 

FUNCTION t403_giftb2_find()
   LET g_rbs[l_ac2].type1  ='1'
   LET g_rbs[l_ac2].before1='0'
   LET g_rbs[l_ac2].after1 ='1'
   
   SELECT ras04,ras05,ras06,ras07,ras08,ras09,rasacti    #FUN-BC0078 add ras09
     INTO g_rbs[l_ac2].rbs07_1,g_rbs[l_ac2].rbs08_1,g_rbs[l_ac2].rbs09_1,
          g_rbs[l_ac2].rbs10_1,g_rbs[l_ac2].rbs11_1,g_rbs[l_ac2].rbs12_1,g_rbs[l_ac2].rbsacti_1  #FUN-BC0078 add rbs12
     FROM ras_file
    WHERE ras01=g_argv1 AND ras02=g_argv2 AND rasplant=g_argv5
      AND ras03=g_argv4 AND ras04=g_rbs[l_ac2].rbs07 AND ras05 = g_rbs[l_ac2].rbs08
      AND ras06=g_rbs[l_ac2].rbs09 
      
   CALL t403_rbs10_1('d',l_ac2)
   IF NOT cl_null(g_rbs[l_ac2].rbs11_1) THEN
      SELECT gfe02 INTO g_rbs[l_ac2].rbs11_1_desc 
        FROM gfe_file
       WHERE gfe01 = g_rbs[l_ac2].rbs11_1  
      DISPLAY BY NAME g_rbs[l_ac2].rbs11_1_desc
   END IF   
   DISPLAY BY NAME g_rbs[l_ac2].rbs07_1,g_rbs[l_ac2].rbs08_1,g_rbs[l_ac2].rbs09_1,g_rbs[l_ac2].rbs10_1,
                   g_rbs[l_ac2].rbs11_1,g_rbs[l_ac2].rbs12,g_rbs[l_ac2].rbsacti_1 #FUN-BC0078 add rbs12
      
   DISPLAY BY NAME g_rbs[l_ac2].type1,g_rbs[l_ac2].before1,g_rbs[l_ac2].after1
END FUNCTION

FUNCTION t403_rbs10_1(p_cmd,p_cnt)
   DEFINE l_n         LIKE type_file.num5
   DEFINE p_cmd       LIKE type_file.chr1 
   DEFINE p_cnt       LIKE type_file.num5 
   DEFINE l_imaacti   LIKE ima_file.imaacti, 
          l_ima02     LIKE ima_file.ima02,
          l_ima25     LIKE ima_file.ima25
   DEFINE l_obaacti   LIKE oba_file.obaacti,
          l_oba02     LIKE oba_file.oba02
   DEFINE l_tqaacti   LIKE tqa_file.tqaacti,
          l_tqa02     LIKE tqa_file.tqa02,
          l_tqa05     LIKE tqa_file.tqa05,
          l_tqa06     LIKE tqa_file.tqa06
   LET g_errno = ' '   
   
   CASE g_rbs[p_cnt].rbs09_1
      WHEN '01'
        IF cl_null(g_rtz.rtz05) THEN 
           SELECT DISTINCT ima02,ima25,imaacti 
             INTO l_ima02,l_ima25,l_imaacti  
             FROM ima_file
            WHERE ima01=g_rbs[p_cnt].rbs10_1  
           CASE
              WHEN SQLCA.sqlcode=100   LET g_errno=100
                                       LET l_ima02=NULL
              WHEN l_imaacti='N'       LET g_errno='9028'
              OTHERWISE
              LET g_errno=SQLCA.sqlcode USING '------'
           END CASE
        ELSE    
           SELECT DISTINCT ima02,ima25,rte07   
             INTO l_ima02,l_ima25,l_imaacti  
             FROM ima_file,rte_file
            WHERE ima01 = rte03 AND ima01=g_rbs[p_cnt].rbs10_1
           CASE
              WHEN SQLCA.sqlcode=100   LET g_errno='art-030'
                                       LET l_ima02=NULL
              WHEN l_imaacti='N'       LET g_errno='9028'
              OTHERWISE
              LET g_errno=SQLCA.sqlcode USING '------'
           END CASE
         END IF  
      WHEN '02'
         SELECT DISTINCT oba02,obaacti 
           INTO l_oba02,l_obaacti
           FROM oba_file
          WHERE oba01=g_rbs[p_cnt].rbs10_1 AND obaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_oba02=NULL
            WHEN l_obaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '03'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbs[p_cnt].rbs10_1 AND tqa03='1' AND tqaacti='Y' 
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '04'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbs[p_cnt].rbs10_1 AND tqa03='2' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '05'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbs[p_cnt].rbs10_1 AND tqa03='3' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '06'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbs[p_cnt].rbs10_1 AND tqa03='4' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '07'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbs[p_cnt].rbs10_1 AND tqa03='5' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '08'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbs[p_cnt].rbs10_1 AND tqa03='6' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '09'
         SELECT DISTINCT tqa02,tqa05,tqa06,tqaacti
           INTO l_tqa02,l_tqa05,l_tqa06,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbs[p_cnt].rbs10_1 AND tqa03='27' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
                                     LET l_tqa05=NULL
                                     LET l_tqa06=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      CASE g_rbs[p_cnt].rbs09_1
         WHEN '01'
            LET g_rbs[p_cnt].rbs10_1_desc = l_ima02
            IF cl_null(g_rbs[p_cnt].rbs11_1) THEN
               LET g_rbs[p_cnt].rbs11_1   = l_ima25
            END IF
            SELECT gfe02 INTO g_rbs[p_cnt].rbs11_1_desc FROM gfe_file
             WHERE gfe01=g_rbs[p_cnt].rbs11_1 AND gfeacti='Y'
         WHEN '02'
            LET g_rbs[p_cnt].rbs11_1 = ''
            LET g_rbs[p_cnt].rbs11_1_desc = ''
            LET g_rbs[p_cnt].rbs10_1_desc = l_oba02
         WHEN '09'
            LET g_rbs[p_cnt].rbs11_1 = ''
            LET g_rbs[p_cnt].rbs11_1_desc = ''
            LET g_rbs[p_cnt].rbs10_1_desc = l_tqa02 CLIPPED,">"
            LET l_tqa02 = l_tqa05
            LET g_rbs[p_cnt].rbs10_1_desc = g_rbs[p_cnt].rbs10_1_desc CLIPPED,":",l_tqa02 CLIPPED,"-"
            LET l_tqa02 = l_tqa06
            LET g_rbs[p_cnt].rbs10_1_desc = g_rbs[p_cnt].rbs10_1_desc CLIPPED,l_tqa02 CLIPPED
        #TQC-C30055 add START
         WHEN '10'
            SELECT lpx02 INTO g_rbs[p_cnt].rbs10_1_desc FROM lpx_file
             WHERE lpx01=g_rbs[p_cnt].rbs10_1 AND lpx15 = 'Y' AND lpx07 = 'Y'
        #TQC-C30055 add END
         OTHERWISE
            LET g_rbs[p_cnt].rbs11_1 = ''
            LET g_rbs[p_cnt].rbs11_1_desc = ''
            LET g_rbs[p_cnt].rbs10_1_desc = l_tqa02
      END CASE
      DISPLAY BY NAME g_rbs[p_cnt].rbs10_1_desc,g_rbs[p_cnt].rbs11_1,g_rbs[p_cnt].rbs11_1_desc
   END IF
END FUNCTION 

FUNCTION t403_rbs09()
   IF g_rbs[l_ac2].rbs09='01' THEN
      CALL cl_set_comp_entry("rbs10",TRUE)
      CALL cl_set_comp_required("rbs10",TRUE)
      CALL cl_set_comp_entry("rbs11",TRUE)
      CALL cl_set_comp_required("rbs11",TRUE)
   ELSE
      CALL cl_set_comp_entry("rbs11",FALSE)
   END IF
#FUN-BC0078 add START
   IF g_rbs[l_ac2].rbs09 = '11' THEN
      LET g_rbs[l_ac2].rbs10 = 'MISCCARD'
      CALL cl_set_comp_entry("rbs10",FALSE)
      CALL cl_set_comp_entry("rbs12",TRUE)
      CALL cl_set_comp_required("rbs12",TRUE)
   ELSE
      CALL cl_set_comp_entry("rbs10",TRUE)
      CALL cl_set_comp_entry("rbs12",FALSE)
      CALL cl_set_comp_required("rbs12",FALSE)
   END IF

#FUN-BC0078 add END
END FUNCTION

FUNCTION t403_rbs10(p_cmd,p_cnt)
   DEFINE l_n         LIKE type_file.num5
   DEFINE p_cmd       LIKE type_file.chr1 
   DEFINE p_cnt       LIKE type_file.num5 

   DEFINE    l_imaacti  LIKE ima_file.imaacti, 
             l_ima02    LIKE ima_file.ima02,
             l_ima25    LIKE ima_file.ima25

   DEFINE    l_obaacti  LIKE oba_file.obaacti,
             l_oba02    LIKE oba_file.oba02

   DEFINE    l_tqaacti  LIKE tqa_file.tqaacti,
             l_tqa02    LIKE tqa_file.tqa02,
             l_tqa05    LIKE tqa_file.tqa05,
             l_tqa06    LIKE tqa_file.tqa06
   DEFINE    l_ima154   LIKE ima_file.ima154  #FUN-BC0078 add
   LET g_errno = ' '    
   CASE g_rbs[p_cnt].rbs09
      WHEN '01'
        IF cl_null(g_rtz.rtz05) THEN  
           SELECT DISTINCT ima02,ima25,ima154,imaacti  #FUN-BC0078 add ima154
             INTO l_ima02,l_ima25,l_ima154,l_imaacti  #FUN-BC0078 add ima154
             FROM ima_file
            WHERE ima01=g_rbs[p_cnt].rbs10  
           CASE
              WHEN SQLCA.sqlcode=100   LET g_errno=100
                                       LET l_ima02=NULL
              WHEN l_imaacti='N'       LET g_errno='9028'
              WHEN l_ima154 = 'Y'      LET g_errno='art-796'  #FUN-BC0078 add 
              OTHERWISE
              LET g_errno=SQLCA.sqlcode USING '------'
           END CASE
        ELSE    
           SELECT DISTINCT ima02,ima25,ima154,rte07   #FUN-BC0078 ima154
             INTO l_ima02,l_ima25,l_ima154,l_imaacti   #FUN-BC0078 ima154
             FROM ima_file,rte_file
            WHERE ima01 = rte03 AND ima01=g_rbs[p_cnt].rbs10
              AND rte01 = g_rtz.rtz04  #TQC-C20564 add
           CASE
              WHEN SQLCA.sqlcode=100   LET g_errno='art-030'
                                       LET l_ima02=NULL
              WHEN l_imaacti='N'       LET g_errno='9028'
              WHEN l_ima154 = 'Y'      LET g_errno='art-796'  #FUN-BC0078 add
              OTHERWISE
              LET g_errno=SQLCA.sqlcode USING '------'
           END CASE
         END IF  
      WHEN '02'
         SELECT DISTINCT oba02,obaacti 
           INTO l_oba02,l_obaacti
           FROM oba_file
          WHERE oba01=g_rbs[p_cnt].rbs10 AND obaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_oba02=NULL
            WHEN l_obaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '03'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbs[p_cnt].rbs10 AND tqa03='1' AND tqaacti='Y' 
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '04'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbs[p_cnt].rbs10 AND tqa03='2' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '05'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbs[p_cnt].rbs10 AND tqa03='3' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '06'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbs[p_cnt].rbs10 AND tqa03='4' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '07'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbs[p_cnt].rbs10 AND tqa03='5' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '08'
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbs[p_cnt].rbs10 AND tqa03='6' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      WHEN '09'
         SELECT DISTINCT tqa02,tqa05,tqa06,tqaacti
           INTO l_tqa02,l_tqa05,l_tqa06,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbs[p_cnt].rbs10 AND tqa03='27' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
                                     LET l_tqa05=NULL
                                     LET l_tqa06=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      CASE g_rbs[p_cnt].rbs09
         WHEN '01'
            LET g_rbs[p_cnt].rbs10_desc = l_ima02
            IF cl_null(g_rbs[p_cnt].rbs11) THEN
               LET g_rbs[p_cnt].rbs11   = l_ima25
            END IF
            SELECT gfe02 INTO g_rbs[p_cnt].rbs11_desc FROM gfe_file
             WHERE gfe01=g_rbs[p_cnt].rbs11 AND gfeacti='Y'
         WHEN '02'
            LET g_rbs[p_cnt].rbs11 = ''
            LET g_rbs[p_cnt].rbs11_desc = ''
            LET g_rbs[p_cnt].rbs10_desc = l_oba02
         WHEN '09'
            LET g_rbs[p_cnt].rbs11 = ''
            LET g_rbs[p_cnt].rbs11_desc = ''
            LET g_rbs[p_cnt].rbs10_desc = l_tqa02 CLIPPED,">"
            LET l_tqa02 = l_tqa05
            LET g_rbs[p_cnt].rbs10_desc = g_rbs[p_cnt].rbs10_desc CLIPPED,":",l_tqa02 CLIPPED,"-"
            LET l_tqa02 = l_tqa06
            LET g_rbs[p_cnt].rbs10_desc = g_rbs[p_cnt].rbs10_desc CLIPPED,l_tqa02 CLIPPED
        #TQC-C30055 add START
         WHEN '10'
            SELECT lpx02 INTO g_rbs[p_cnt].rbs10_desc FROM lpx_file
             WHERE lpx01=g_rbs[p_cnt].rbs10 AND lpx15 = 'Y' AND lpx07 = 'Y'
        #TQC-C30055 add END
         OTHERWISE
            LET g_rbs[p_cnt].rbs11 = ''
            LET g_rbs[p_cnt].rbs11_desc = ''
            LET g_rbs[p_cnt].rbs10_desc = l_tqa02
      END CASE
      DISPLAY BY NAME g_rbs[p_cnt].rbs10_desc,g_rbs[p_cnt].rbs11,g_rbs[p_cnt].rbs11_desc
   END IF
   IF NOT cl_null(g_errno) THEN  #TQC-C30055 add
      LET g_rbs[p_cnt].rbs10 = NULL    #TQC-C30055 add
   END IF  #TQC-C30055 add
END FUNCTION 

FUNCTION t403_rbs11(p_cmd)
    DEFINE p_cmd       LIKE type_file.chr1   
    DEFINE l_gfe02     LIKE gfe_file.gfe02
    DEFINE l_gfeacti   LIKE gfe_file.gfeacti
    DEFINE l_ima25     LIKE ima_file.ima25
    DEFINE l_flag      LIKE type_file.num5,
           l_fac       LIKE ima_file.ima31_fac   
   LET g_errno = ' '
   IF g_rbs[l_ac2].rbs09<>'01' THEN
      RETURN
   END IF
   IF NOT cl_null(g_rbs[l_ac2].rbs10) THEN
      SELECT DISTINCT ima25
        INTO l_ima25
        FROM ima_file
       WHERE ima01=g_rbs[l_ac2].rbs10  
      CALL s_umfchk(g_rbs[l_ac2].rbs10,l_ima25,g_rbs[l_ac2].rbs11)
         RETURNING l_flag,l_fac   
      IF l_flag = 1 THEN
         LET g_errno = 'ams-823'
         RETURN
      END IF
   END IF
   SELECT gfe02,gfeacti
     INTO l_gfe02,l_gfeacti
     FROM gfe_file 
    WHERE gfe01 = g_rbs[l_ac2].rbs11 AND gfeacti = 'Y' 
   CASE 
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'mfg3377'
      WHEN l_gfeacti='N'       LET g_errno ='9028'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------' 
   END CASE
   IF cl_null(g_errno) OR p_cmd='d' THEN 
      LET g_rbs[l_ac2].rbs11_desc=l_gfe02
      DISPLAY BY NAME g_rbs[l_ac2].rbs11_desc
   END IF    
END FUNCTION 

FUNCTION t403_rbs08() 
   DEFINE l_n     LIKE type_file.num5
   LET g_errno = ' '
   LET l_n=0
   SELECT COUNT(*) INTO l_n FROM rbr_file
    WHERE rbr01 = g_argv1 AND rbr02 = g_argv2
      AND rbr03 = g_argv3 AND rbrplant=g_argv5
      AND rbr04 = g_argv4 AND rbr06='1'
      AND rbr07 = g_rbs[l_ac2].rbs07
      AND rbr08 = g_rbs[l_ac2].rbs08 AND rbracti='Y'
   IF l_n<1 THEN
      SELECT COUNT(*) INTO l_n FROM ras_file
       WHERE ras01=g_argv1 AND ras02=g_argv2
         AND ras03=g_argv4
         AND rasplant=g_argv5 
         AND ras04=g_rbs[l_ac2].rbs07
         AND ras05=g_rbs[l_ac2].rbs08
         AND rasacti='Y'
      IF l_n<1 THEN
         LET g_errno = 'art-669'     #當前組別不在第一單身中,也不在原促銷單中
      END IF     
   END IF
END FUNCTION
#FUN-A80104
#FUN-BC0078 add START
FUNCTION t403_1_b1(p_wc)
DEFINE p_wc     STRING
DEFINE l_sql    STRING
   IF g_argv4 = '2' THEN
      LET l_sql = " SELECT rae28,rae29,rae31 FROM rae_file ",
                  " WHERE rae01 = '",g_argv1,"' AND rae02 = '",g_argv2,"'",
                  "   AND raeplant = '",g_argv5,"'"
   ELSE
      LET l_sql = " SELECT rah20,rah21,rah23 FROM rah_file",
                  " WHERE rah01 = '",g_argv1,"' AND rah02 = '",g_argv2,"'",
                  "   AND rahplant = '",g_argv5,"'"
   END IF

   IF NOT cl_null(p_wc) THEN
      LET l_sql = l_sql ," AND ",p_wc CLIPPED
   END IF
   PREPARE t403_1_b1 FROM l_sql
   EXECUTE t403_1_b1 INTO g_rbe.rbe28,g_rbe.rbe29,g_rbe.rbe31
   DISPLAY BY NAME g_rbe.*

END FUNCTION

FUNCTION t403_1_b2(p_wc)
DEFINE p_wc     STRING
DEFINE l_sql    STRING
   IF g_argv4 = '2' THEN
      LET l_sql = " SELECT rbe28t,rbe29t,rbe31t FROM rbe_file ",
                  " WHERE rbe01 = '",g_argv1 CLIPPED ,"' AND rbe02 = '",g_argv2 CLIPPED ,"'",
                  "   AND rbeplant = '",g_argv5 CLIPPED ,"'",
                  "   AND rbe03 = '",g_argv3 CLIPPED ,"'"
   ELSE
     #LET l_sql = " SELECT rbh20,rbh21,rbh23 FROM rbh_file",  #TQC-C20564 mark
      LET l_sql = " SELECT rbh20t,rbh21t,rbh23t FROM rbh_file",   #TQC-C20564 add
                  " WHERE rbh01 = '",g_argv1 CLIPPED ,"' AND rbh02 = '",g_argv2 CLIPPED ,"'",
                  "   AND rbhplant = '",g_argv5,"'",
                  "   AND rbh03 = '",g_argv3 CLIPPED ,"'"
   END IF

   IF NOT cl_null(p_wc) THEN
      LET l_sql = l_sql ," AND ",p_wc CLIPPED
   END IF
   PREPARE t403_1_b2 FROM l_sql
   EXECUTE t403_1_b2 INTO g_rbe.rbe28t,g_rbe.rbe29t,g_rbe.rbe31t
   DISPLAY BY NAME g_rbe.*

END FUNCTION

FUNCTION t403_1_updrbe()

   IF g_argv6<>'N' THEN
      CALL cl_err('','apm-267',0)
      RETURN
   END IF

   LET g_success = 'Y'

#FUN-C60041 -----------------STA
   LET g_rbe.rbe28t = g_rbe.rbe28
   LET g_rbe.rbe29t = g_rbe.rbe29
#FUN-C60041 -----------------END
   DISPLAY BY NAME g_rbe.rbe28,g_rbe.rbe29,g_rbe.rbe31,
                   g_rbe.rbe28t,g_rbe.rbe29t,g_rbe.rbe31t

   CALL cl_set_head_visible("","YES")

   INPUT BY NAME g_rbe.rbe28t,g_rbe.rbe29t,g_rbe.rbe31t
      WITHOUT DEFAULTS

   AFTER INPUT
#FUN-C60041 -----------------STA
     IF cl_null(g_rbe.rbe28t)  THEN
        NEXT FIELD rbe28t
     END IF
     IF cl_null(g_rbe.rbe29t)  THEN
        NEXT FIELD rbe29t
     END IF
#FUN-C60041 -----------------END
      IF g_argv4 = '2' THEN  #組合促銷
         UPDATE rbe_file SET rbe28t = g_rbe.rbe28t,
                             rbe29t = g_rbe.rbe29t,
                             rbe31t = g_rbe.rbe31t,
                             rbe28 = g_rbe.rbe28,
                             rbe29 = g_rbe.rbe29,
                             rbe31 = g_rbe.rbe31
                       WHERE rbe01 = g_argv1  AND rbe02 = g_argv2
                         AND rbe03 = g_argv3
                         AND rbeplant = g_argv5
         IF SQLCA.sqlerrd[3]=0 THEN
            LET g_success='N'
         END IF
      END IF
      IF g_argv4 = '3' THEN  #滿額促銷
         UPDATE rbh_file SET rbh20t = g_rbe.rbe28t,
                             rbh21t = g_rbe.rbe29t,
                             rbh23t = g_rbe.rbe31t,
                             rbh20 = g_rbe.rbe28,
                             rbh21 = g_rbe.rbe29,
                             rbh23 = g_rbe.rbe31
                       WHERE rbh01 = g_argv1  AND rbh02 = g_argv2
                         AND rbh03 = g_argv3
                         AND rbhplant = g_argv5
         IF SQLCA.sqlerrd[3]=0 THEN
            LET g_success='N'
         END IF
      END IF

      IF g_success = 'Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF

   ON ACTION CONTROLR
      CALL cl_show_req_fields()

   ON ACTION CONTROLG
      CALL cl_cmdask()

   ON ACTION CONTROLF
      CALL cl_set_focus_form(ui.Interface.getRootNode())
         RETURNING g_fld_name,g_frm_name
      CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE INPUT

   ON ACTION about
      CALL cl_about()

   ON ACTION HELP
      CALL cl_show_help()

   ON ACTION controls
      CALL cl_set_head_visible("","AUTO")

   END INPUT
END FUNCTION
#FUN-BC0078 add END
