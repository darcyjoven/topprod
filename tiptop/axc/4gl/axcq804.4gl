# Prog. Version..: '5.30.08-13.07.05(00000)'     #
#
# Pattern name...: axcq804.4gl
# Descriptions...: 發出商品與IMK差異數量表 #FUN-D70058
# Date & Author..: FUN-D70058 13/07/15 By wangrr

DATABASE ds

GLOBALS "../../config/top.global"
DEFINE tm RECORD
       wc     STRING,       
       yy     LIKE type_file.chr4,
       mm     LIKE type_file.chr2,
       c      LIKE type_file.chr1
       END RECORD,
       g_cfc  DYNAMIC ARRAY OF RECORD
       cfc11  LIKE cfc_file.cfc11,
       cfc13  LIKE cfc_file.cfc13,
       ima021 LIKE ima_file.ima021,
       cfc17  LIKE cfc_file.cfc17,
       cfc14  LIKE cfc_file.cfc14,
       imd02  LIKE imd_file.imd02,
       cfc141 LIKE cfc_file.cfc141,
       ime03  LIKE ime_file.ime03,
       cfc142 LIKE cfc_file.cfc142,
       sum1   LIKE cfc_file.cfc15,
       sum2   LIKE cfc_file.cfc15,
       diff   LIKE cfc_file.cfc15
       END RECORD
DEFINE g_sql    STRING 
DEFINE l_ac     LIKE type_file.num5 
DEFINE g_cnt    LIKE type_file.num10 
DEFINE g_rec_b  LIKE type_file.num10
DEFINE g_change_lang    LIKE type_file.chr1
DEFINE l_table  STRING

MAIN
   DEFINE p_row,p_col  LIKE type_file.num5

   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   LET p_row = 2 LET p_col = 18
   LET g_sql="cfc11.cfc_file.cfc11,cfc13.cfc_file.cfc13,",
             "ima021.ima_file.ima021,cfc17.cfc_file.cfc17,",
             "cfc14.cfc_file.cfc14,imd02.imd_file.imd02,",
             "cfc141.cfc_file.cfc141,ime03.ime_file.ime03,",
             "cfc142.cfc_file.cfc142,sum1.cfc_file.cfc15,",
             "sum2.cfc_file.cfc15,diff.cfc_file.cfc15"
   LET l_table = cl_prt_temptable('axcq804',g_sql)
   IF l_table=-1 THEN EXIT PROGRAM END IF
   
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.yy = ARG_VAL(8)
   LET tm.mm = ARG_VAL(9)
   LET tm.c = ARG_VAL(10)
   IF cl_null(g_bgjob) OR g_bgjob='N' THEN                          
      OPEN WINDOW q804_w AT p_row,p_col WITH FORM "axc/42f/axcq804" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED)                    
      CALL cl_ui_init()                                             
      CALL q804_tm(0,0) 
      CALL q804_menu()
   ELSE
      CALL q804()                                                   
   END IF 

   CLOSE WINDOW q804_w              
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
FUNCTION q804_menu()
 
   WHILE TRUE
      CALL q804_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q804_tm(0,0)
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q804_out()
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
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_cfc),'','')
            END IF
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF l_ac IS NOT NULL THEN
                  LET g_doc.column1 = "cfc11"
                  LET g_doc.value1 = g_cfc[l_ac].cfc11
                  CALL cl_doc()
               END IF
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION q804_tm(p_row,p_col)
DEFINE lc_qbe_sn       LIKE gbm_file.gbm01    
DEFINE p_row,p_col     LIKE type_file.num5,   
       l_cmd           LIKE type_file.chr1000 

   SELECT ccz01,ccz02,ccz28 INTO g_ccz.ccz01,g_ccz.ccz02,g_ccz.ccz28 FROM ccz_file 
   CALL cl_opmsg('p')
   
   INITIALIZE tm.* TO NULL 
   CLEAR FORM             
   CALL g_cfc.clear() 
   LET tm.yy=g_ccz.ccz01
   LET tm.mm=g_ccz.ccz02  
   LET tm.c='Y'
   DIALOG ATTRIBUTE(UNBUFFERED) 
   
   INPUT BY NAME tm.yy,tm.mm,tm.c
      ATTRIBUTES (WITHOUT DEFAULTS) 
      BEFORE INPUT 
          CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD yy        
         IF NOT cl_null(tm.yy) THEN 
            IF tm.yy > 9999 OR tm.yy < 1000 THEN 
               CALL cl_err('','ask-003',0)
               NEXT FIELD yy
            END IF 
         END IF 
  
      AFTER FIELD mm
         IF NOT cl_null(tm.mm) THEN 
            IF tm.mm >13 OR tm.mm < 1 THEN 
               CALL cl_err('','agl-013',0)
               NEXT FIELD mm
            END IF  
         END IF
   END INPUT
   CONSTRUCT tm.wc ON cfc11,cfc13,cfc17,cfc14,cfc141,cfc142
                 FROM s_cfc[1].cfc11,s_cfc[1].cfc13,s_cfc[1].cfc17,
                      s_cfc[1].cfc14,s_cfc[1].cfc141,s_cfc[1].cfc142
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
   END CONSTRUCT  
 
     ON ACTION locale
        CALL cl_show_fld_cont()
        LET g_action_choice = "locale"
        EXIT DIALOG 
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DIALOG 
 
     ON ACTION about       
        CALL cl_about()    
 
     ON ACTION help        
        CALL cl_show_help()
 
     ON ACTION controlg    
        CALL cl_cmdask()   
 
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT DIALOG

     ON ACTION ACCEPT
         LET INT_FLAG = 0
         ACCEPT DIALOG
            
     ON ACTION CANCEL
         LET INT_FLAG = 1
         EXIT DIALOG  
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(cfc11)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_cfc11"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO cfc11
               NEXT FIELD cfc11
            WHEN INFIELD(cfc14)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_cfc14"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO cfc14
               NEXT FIELD cfc14
            WHEN INFIELD(cfc17)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_cfc17"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO cfc17
               NEXT FIELD cfc17
         END CASE
      ON ACTION qbe_select
         CALL cl_qbe_select()
  
   END DIALOG
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM      
   END IF

 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='axcq804'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axcq804','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", 
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",tm.c CLIPPED,"'"                  
         CALL cl_cmdat('axcq804',g_time,l_cmd) 
      END IF
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL q804()
   CALL q804_show()
   ERROR ""
END FUNCTION
FUNCTION q804()
   IF cl_null(tm.wc) THEN LET tm.wc=' 1=1 ' END IF
   CALL cl_del_data(l_table)
   #抓取資料
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " SELECT DISTINCT cfc11,'' cfc13,'' ima021,cfc17,",
             "        '' cfc14,'' imd02,'' cfc141,'' ime03,'' cfc142,",
             "        0 sum1,0 sum2,0 diff ",
             "  FROM cfc_file ",
             " WHERE cfc05=",tm.yy," AND cfc06=",tm.mm,
             "   AND cfc11 NOT LIKE 'MISC%' AND cfc20='N' ",
             "   AND ",tm.wc
   PREPARE q804_ins_pr FROM g_sql
   EXECUTE q804_ins_pr
   IF SQLCA.sqlcode THEN
      CALL cl_err('ins temp table',SQLCA.sqlcode,1)
      RETURN
   END IF
   #本月結存數量=期初數量+本月出貨數量-本月開票數量
   #期初數量
   LET g_sql="UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED," o ",
             "   SET o.sum1= (",
             "      SELECT NVL(SUM(cfc15*cfc18),0) FROM cfc_file c1 ",#轉入數量
             "       WHERE(c1.cfc05<",tm.yy," OR (c1.cfc05=",tm.yy," AND c1.cfc06<",tm.mm,"))",
             "         AND c1.cfc21=0 AND c1.cfc22 =0 AND c1.cfc01=1",
             "         AND c1.cfc11=o.cfc11 AND c1.cfc17=o.cfc17  )"
   PREPARE q804_upd_sum FROM g_sql
   EXECUTE q804_upd_sum
   IF SQLCA.sqlcode THEN
      CALL cl_err('q804_upd_sum',SQLCA.sqlcode,1)
      RETURN
   END IF 
   LET g_sql="UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED," o ",
             "   SET o.sum1=o.sum1- (",
             "      SELECT NVL(SUM(cfc15*cfc18),0) FROM cfc_file c2 ",#轉出數量
             "       WHERE(c2.cfc21<",tm.yy," OR (c2.cfc21=",tm.yy," AND c2.cfc22<",tm.mm,"))",
             "         AND c2.cfc01=-1",
             "         AND c2.cfc11=o.cfc11 AND c2.cfc17=o.cfc17 )"
   PREPARE q804_upd_sum1 FROM g_sql
   EXECUTE q804_upd_sum1
   IF SQLCA.sqlcode THEN
      CALL cl_err('q804_upd_sum1',SQLCA.sqlcode,1)
      RETURN
   END IF 
   #本月出貨數量
   LET g_sql="UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED," o ",
             "   SET o.sum1=o.sum1+ (",
             "      SELECT NVL(SUM(cfc15*cfc18),0) FROM cfc_file c1 ",       #出貨數量
             "       WHERE c1.cfc05=",tm.yy," AND c1.cfc06=",tm.mm,
             "         AND c1.cfc21=0 AND c1.cfc22 =0 AND c1.cfc01=1",
             "         AND c1.cfc00 IN ('1','2','3') ",
             "         AND c1.cfc11=o.cfc11 AND c1.cfc17=o.cfc17",
             "  )"
   PREPARE q804_upd_sum2 FROM g_sql
   EXECUTE q804_upd_sum2
   IF SQLCA.sqlcode THEN
      CALL cl_err('q804_upd_sum2',SQLCA.sqlcode,1)
      RETURN
   END IF
   #本月開票數量
   LET g_sql="UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED," o ",
             "   SET o.sum1=o.sum1- (",
             "      SELECT NVL(SUM(cfc15*cfc18),0) FROM cfc_file c1 ",       
             "       WHERE c1.cfc21=",tm.yy," AND c1.cfc22=",tm.mm,
             "         AND c1.cfc01=-1",
             "         AND c1.cfc00 IN ('1','2','3') ",
             "         AND c1.cfc11=o.cfc11 AND c1.cfc17=o.cfc17 ",
             "  )"
   PREPARE q804_upd_sum3 FROM g_sql
   EXECUTE q804_upd_sum3
   IF SQLCA.sqlcode THEN
      CALL cl_err('q804_upd_sum3',SQLCA.sqlcode,1)
      RETURN
   END IF
   #期末數量
   LET g_sql="UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED," o ",
             "   SET o.sum2=(",
             " SELECT NVL(SUM(imk09),0) FROM imk_file,img_file",
             " WHERE imk01=img01 AND imk02=img02 AND imk03=img03 ",
             "   AND imk04=img04 AND img01=o.cfc11 AND img09=o.cfc17 ",
             "   AND imk05=",tm.yy," AND imk06=",tm.mm,
             ")"
   PREPARE q804_upd_sum4 FROM g_sql
   EXECUTE q804_upd_sum4
   IF SQLCA.sqlcode THEN
      CALL cl_err('q804_upd_sum4',SQLCA.sqlcode,1)
      RETURN
   END IF
   #差異
   LET g_sql="UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED," o ",
             "   SET o.diff=o.sum1-o.sum2 "
   PREPARE q804_upd_sum5 FROM g_sql
   EXECUTE q804_upd_sum5
   IF SQLCA.sqlcode THEN
      CALL cl_err('q804_upd_sum5',SQLCA.sqlcode,1)
      RETURN
   END IF
   #是否顯示無差異資料
   IF tm.c='Y' THEN
      LET g_sql="DELETE FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," o ",
                " WHERE o.diff=0 "
      PREPARE q804_del_pr FROM g_sql
      EXECUTE q804_del_pr
      IF SQLCA.sqlcode THEN
         CALL cl_err('q804_del_pr',SQLCA.sqlcode,1)
         RETURN
      END IF
   END IF
   #抓取品名,規格,倉庫,庫位,批號
   LET g_sql="UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED," o ",
             "   SET o.cfc13=(SELECT ima02 FROM ima_file WHERE ima01=o.cfc11),",
             "       o.ima021=(SELECT ima021 FROM ima_file WHERE ima01=o.cfc11),",
             "       o.cfc14=( ",
             " SELECT DISTINCT cfc14 FROM cfc_file ",
             "  WHERE cfc11=o.cfc11 AND cfc17=o.cfc17 ",
             "    AND cfc05=",tm.yy," AND cfc06=",tm.mm," AND rownum<=1 ),",
             "       o.cfc141=( ",
             " SELECT DISTINCT cfc141 FROM cfc_file ",
             "  WHERE cfc11=o.cfc11 AND cfc17=o.cfc17 ",
             "    AND cfc05=",tm.yy," AND cfc06=",tm.mm," AND rownum<=1 ),",
             "       o.cfc142=( ",
             " SELECT DISTINCT cfc142 FROM cfc_file ",
             "  WHERE cfc11=o.cfc11 AND cfc17=o.cfc17 ",
             "    AND cfc05=",tm.yy," AND cfc06=",tm.mm," AND rownum<=1 )"
             
   PREPARE q804_upd_pr FROM g_sql
   EXECUTE q804_upd_pr
   IF SQLCA.sqlcode THEN
      CALL cl_err('q804_upd_pr',SQLCA.sqlcode,1)
      RETURN
   END IF
   #抓取倉庫名稱,庫位名稱
   LET g_sql="UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED," o ",
             "   SET o.imd02=(SELECT imd02 FROM imd_file WHERE imd01=o.cfc14),",
             "       o.ime03=(SELECT ime03 FROM ime_file WHERE ime01=o.cfc14 AND ime02=o.cfc141)"
   PREPARE q804_upd_pr1 FROM g_sql
   EXECUTE q804_upd_pr1
   IF SQLCA.sqlcode THEN
      CALL cl_err('q804_upd_pr1',SQLCA.sqlcode,1)
      RETURN
   END IF 
END FUNCTION
FUNCTION q804_show()
   DISPLAY tm.yy,tm.mm,tm.c TO yy,mm,c
   CALL q804_b_fill()  
END FUNCTION

FUNCTION q804_b_fill()
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " ORDER BY cfc11,cfc17"
   PREPARE axrq804_pb1 FROM g_sql
   DECLARE cfc_cs1  CURSOR FOR axrq804_pb1        #CURSOR

   CALL g_cfc.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
   FOREACH cfc_cs1 INTO g_cfc[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACh
      END IF
   END FOREACH
   CALL g_cfc.deleteElement(g_cnt)
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
FUNCTION q804_out()
   LET g_xgrid.table = l_table
   LET g_xgrid.template='axcq804'
   LET g_xgrid.order_field="cfc11,cfc17"
   LET g_xgrid.headerinfo1=cl_getmsg('agl-172',g_lang),':',tm.yy,"--",
                           cl_getmsg('azz-159',g_lang),':',tm.mm
   CALL cl_xg_view()
END FUNCTION

FUNCTION q804_bp(p_ud)
DEFINE
    p_ud   LIKE type_file.chr1    

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_cfc TO s_cfc.* ATTRIBUTE(COUNT=g_rec_b)   
      BEFORE ROW 
         LET l_ac = ARR_CURR() 
         CALL cl_show_fld_cont()                  
      
     
      ON ACTION query
         LET g_action_choice="query"
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

      ON ACTION cancel
         LET INT_FLAG=FALSE             
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON ACTION CLOSE
         LET g_action_choice="exit"
         EXIT DISPLAY 

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY 

      AFTER DISPLAY  
         CONTINUE DISPLAY 
   END DISPLAY 
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION 
#FUN-D70058 add

 
 
