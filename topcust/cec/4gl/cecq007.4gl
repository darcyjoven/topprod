# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: cecq007
# Descriptions...: 
# Date & Author..: 16/08/17  By huanglf160817

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
   DEFINE tm  RECORD                                              
                 wc2 STRING                                     
              END RECORD        
   DEFINE l_where         STRING 
   DEFINE g_sql           STRING                                                                                    
   DEFINE g_str           STRING    
   DEFINE l_table         STRING   
   DEFINE g_msg           LIKE type_file.chr1000
   DEFINE g_rec_b         LIKE type_file.num10
   DEFINE g_cnt           LIKE type_file.num10  
   DEFINE g_cnt1          LIKE type_file.num10   
   DEFINE g_tc_sfc,g_tc_sfc_excel   DYNAMIC ARRAY OF RECORD  
       ima01          LIKE ima_file.ima01,
       tc_sfc01_1     LIKE tc_shb_file.tc_shb12,
       tc_sfc01_2     LIKE tc_shb_file.tc_shb12,
       tc_sfc01_3     LIKE tc_shb_file.tc_shb12,
       tc_sfc01_4     LIKE tc_shb_file.tc_shb12,
       tc_sfc01_5     LIKE tc_shb_file.tc_shb12,
       tc_sfc01_6     LIKE tc_shb_file.tc_shb12,
       tc_sfc01_7     LIKE tc_shb_file.tc_shb12,
       tc_sfc01_8     LIKE tc_shb_file.tc_shb12,
       tc_sfc01_9     LIKE tc_shb_file.tc_shb12,
       tc_sfc01_10    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_11    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_12    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_13    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_14    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_15    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_16    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_17    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_18    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_19    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_20    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_21    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_22    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_23    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_24    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_25    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_26    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_27    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_28    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_29    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_30    LIKE tc_shb_file.tc_shb12,
       
       tc_sfc01_31    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_32    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_33    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_34    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_35    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_36    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_37    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_38    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_39    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_40    LIKE tc_shb_file.tc_shb12
                         END RECORD
   DEFINE g_tc_sfc_attr     DYNAMIC ARRAY OF RECORD
       ima01          STRING,
       tc_sfc01_1     STRING,
       tc_sfc01_2     STRING,
       tc_sfc01_3     STRING,
       tc_sfc01_4     STRING,
       tc_sfc01_5     STRING,
       tc_sfc01_6     STRING,
       tc_sfc01_7     STRING,
       tc_sfc01_8     STRING,
       tc_sfc01_9     STRING,
       tc_sfc01_10    STRING,

       
       tc_sfc01_11    STRING,
       tc_sfc01_12    STRING,
       tc_sfc01_13    STRING,
       tc_sfc01_14    STRING,
       tc_sfc01_15    STRING,
       tc_sfc01_16    STRING,
       tc_sfc01_17    STRING,
       tc_sfc01_18    STRING,
       tc_sfc01_19    STRING,
       tc_sfc01_20    STRING,

       
       tc_sfc01_21    STRING,
       tc_sfc01_22    STRING,
       tc_sfc01_23    STRING,
       tc_sfc01_24    STRING,
       tc_sfc01_25    STRING,
       tc_sfc01_26    STRING,
       tc_sfc01_27    STRING,
       tc_sfc01_28    STRING,
       tc_sfc01_29    STRING,
       tc_sfc01_30    STRING,
       
       tc_sfc01_31    STRING,
       tc_sfc01_32    STRING,
       tc_sfc01_33    STRING,
       tc_sfc01_34    STRING,
       tc_sfc01_35    STRING,
       tc_sfc01_36    STRING,
       tc_sfc01_37    STRING,
       tc_sfc01_38    STRING,
       tc_sfc01_39    STRING,
       tc_sfc01_40    STRING
                END RECORD
   
   DEFINE g_row_count    LIKE type_file.num10  
   DEFINE g_curs_index   LIKE type_file.num10  
   DEFINE g_jump         LIKE type_file.num10  
   DEFINE mi_no_ask      LIKE type_file.num5
   DEFINE g_no_ask       LIKE type_file.num5    
   DEFINE l_ac,l_ac1     LIKE type_file.num5    
   DEFINE g_flag         LIKE type_file.chr1 
   DEFINE g_action_flag  LIKE type_file.chr100
   DEFINE g_cnt2          LIKE type_file.num10
   DEFINE   w    ui.Window      
   DEFINE   f    ui.Form       
   DEFINE   page om.DomNode 
     
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CEC")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   
   OPEN WINDOW q007_w AT 5,10
        WITH FORM "cec/42f/cecq007" ATTRIBUTE(STYLE = g_win_style)  

   CALL cl_ui_init()
   CALL cl_set_act_visible("revert_filter",FALSE)
   
   CALL q007_table()  
   CALL q007_q()   
   CALL q007_menu()
   DROP TABLE cecq007_tmp;
   CLOSE WINDOW q007_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q007_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       
   DEFINE   l_msg   STRING   

   WHILE TRUE
  
        CALL q007_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q007_q()    
            END IF    
            LET g_action_choice = " "

         WHEN "help"
            CALL cl_show_help()
            LET g_action_choice = " "
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            LET g_action_choice = " "
         WHEN "exporttoexcel"     #匯出Excel
            IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel(page,base.TypeInfo.create(g_tc_sfc_excel),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

 
FUNCTION q007_b_fill()

   LET g_sql = " SELECT ima01,tc_sfc01_1,tc_sfc01_2,tc_sfc01_3,tc_sfc01_4,tc_sfc01_5,tc_sfc01_6,",
               "       tc_sfc01_7,tc_sfc01_8,tc_sfc01_9,tc_sfc01_10,tc_sfc01_11,tc_sfc01_12,tc_sfc01_13,tc_sfc01_14,tc_sfc01_15,",
               "       tc_sfc01_16,tc_sfc01_17,tc_sfc01_18,tc_sfc01_19,tc_sfc01_20,tc_sfc01_21,tc_sfc01_22,tc_sfc01_23,tc_sfc01_24,",
               "       tc_sfc01_25,tc_sfc01_26,tc_sfc01_27,tc_sfc01_28,tc_sfc01_29,tc_sfc01_30,tc_sfc01_31,tc_sfc01_32,tc_sfc01_33,",
               "       tc_sfc01_34,tc_sfc01_35,tc_sfc01_36,tc_sfc01_37,tc_sfc01_38,tc_sfc01_39,tc_sfc01_40",
               "   FROM cecq007_tmp ",
               "  ORDER BY ima01 "   


   PREPARE cecq007_pb FROM g_sql
   DECLARE sfb_curs  CURSOR FOR cecq007_pb        #CURSOR


   CALL g_tc_sfc.clear()
   CALL g_tc_sfc_excel.clear()
   CALL g_tc_sfc_attr.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH sfb_curs INTO g_tc_sfc_excel[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
      #CALL q007_color()

      IF g_cnt < = 5000 THEN
         LET g_tc_sfc[g_cnt].* = g_tc_sfc_excel[g_cnt].*
      END IF
      LET g_cnt = g_cnt + 1

   END FOREACH
   IF g_cnt <= 5000 THEN
      CALL g_tc_sfc.deleteElement(g_cnt)
   END IF
   CALL g_tc_sfc_excel.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF g_rec_b > 5000 AND (g_bgjob = 'N' OR cl_null(g_bgjob)) THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||5000,10)
      LET g_rec_b  = 5000   #筆數顯示畫面檔的筆數
   END IF
   DISPLAY g_rec_b TO FORMONLY.cnt 
END FUNCTION


FUNCTION q007_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
  
      CALL q007_b_fill()
    
   LET g_action_choice = " "
   LET g_flag = ' '
   
   CALL cl_set_act_visible("accept,cancel", FALSE)

   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_tc_sfc TO s_tc_sfc.* ATTRIBUTE(COUNT=g_rec_b)
         BEFORE DISPLAY
            CALL DIALOG.setArrayAttributes("s_tc_sfc",g_tc_sfc_attr)    #参数：屏幕变量,属性数组
            CALL ui.Interface.refresh() 
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
      END DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG      
 
      ON ACTION ACCEPT
         LET l_ac = ARR_CURR()
         EXIT DIALOG
   
      ON ACTION data_filter
         LET g_action_choice="data_filter"
         EXIT DIALOG     

      ON ACTION revert_filter         
         LET g_action_choice="revert_filter"
         EXIT DIALOG 
         
      ON ACTION HELP
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   

      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION CANCEL
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

      ON ACTION related_document 
         LET g_action_choice="related_document"          
         EXIT DIALOG

      AFTER DIALOG
         CONTINUE DIALOG

      ON ACTION controls                    
         CALL cl_set_head_visible("","AUTO")
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION



FUNCTION q007_cs()
   DEFINE  l_cnt           LIKE type_file.num5   
   DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01     
   DEFINE  li_chk_bookno   LIKE type_file.num5
 
   CLEAR FORM   #清除畫面
   CALL g_tc_sfc.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL                  
   CALL cl_set_act_visible("revert_filter",FALSE) #FUN-D10105 add
   DIALOG ATTRIBUTE(UNBUFFERED)    

         CONSTRUCT tm.wc2 ON ima01
                        FROM s_tc_sfc[1].ima01
            BEFORE CONSTRUCT
               CALL cl_qbe_init()
         END CONSTRUCT
         #出貨單欄位

         ON ACTION controlp
            CASE
               WHEN INFIELD(ima01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="cq_ima01_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima01
                  NEXT FIELD ima01
            END CASE
       
          
         ON ACTION CONTROLZ
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG 

         ON ACTION about
            CALL cl_about()

         ON ACTION HELP
            CALL cl_show_help()

         ON ACTION EXIT
            LET INT_FLAG = 1
            EXIT DIALOG 

         ON ACTION qbe_save
            CALL cl_qbe_save()

         ON ACTION qbe_select
    	    CALL cl_qbe_select() 

         ON ACTION ACCEPT
            ACCEPT DIALOG 

         ON ACTION CANCEL
            LET INT_FLAG=1
            EXIT DIALOG    
   END DIALOG                                                                                                                                                                     
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET INT_FLAG = 0
      INITIALIZE tm.* TO NULL
      DELETE FROM cecq007_tmp
   END IF

   CALL q007()   
END FUNCTION 

FUNCTION q007_q() 
   
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q007_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "SERCHING!"
    MESSAGE ""
    CALL q007_show()
END FUNCTION

FUNCTION q007_show() 
   CALL q007_b_fill()    
   CALL cl_show_fld_cont()                   
END FUNCTION



FUNCTION q007_table()
   #DROP TABLE cecq007_tmp;  #FUN-D10105 mark
   CREATE TEMP TABLE cecq007_tmp(
       ima01          LIKE ima_file.ima01,
       tc_sfc01_1     LIKE tc_shb_file.tc_shb12,
       tc_sfc01_2     LIKE tc_shb_file.tc_shb12,
       tc_sfc01_3     LIKE tc_shb_file.tc_shb12,
       tc_sfc01_4     LIKE tc_shb_file.tc_shb12,
       tc_sfc01_5     LIKE tc_shb_file.tc_shb12,
       tc_sfc01_6     LIKE tc_shb_file.tc_shb12,
       tc_sfc01_7     LIKE tc_shb_file.tc_shb12,
       tc_sfc01_8     LIKE tc_shb_file.tc_shb12,
       tc_sfc01_9     LIKE tc_shb_file.tc_shb12,
       tc_sfc01_10    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_11    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_12    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_13    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_14    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_15    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_16    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_17    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_18    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_19    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_20    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_21    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_22    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_23    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_24    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_25    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_26    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_27    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_28    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_29    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_30    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_31    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_32    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_33    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_34    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_35    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_36    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_37    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_38    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_39    LIKE tc_shb_file.tc_shb12,
       tc_sfc01_40    LIKE tc_shb_file.tc_shb12)  

END FUNCTION 


FUNCTION q007()
 DEFINE   l_name      LIKE type_file.chr20,           
          l_sql       STRING,                
          l_order     ARRAY[5] OF LIKE abb_file.abb11,   #排列順序    
                         
          l_cnt       LIKE type_file.num5                  
   DEFINE l_wc,l_msg,g_wc,l_sql1,l_sql2,l_sql3   STRING 
   DEFINE l_sic06a,l_sic06b  LIKE sic_file.sic06
   DEFINE l_order1     LIKE type_file.chr100
   DEFINE l_num        LIKE type_file.num5
   DEFINE l_ogc        RECORD LIKE ogc_file.*
   DEFINE l_sfb01_t    LIKE sfb_file.sfb01      #lixh1121107 add
   DEFINE l_ogb03_t    LIKE ogb_file.ogb03      #lixh1121107 add
   DEFINE l_wc2        STRING 
   DEFINE l_ecb06     LIKE ecb_file.ecb06
   DEFINE l_tc_sfc01  LIKE tc_sfc_file.tc_sfc01
   DEFINE l_str       STRING
 
   DEFINE sum1         LIKE tc_shb_file.tc_shb12
   DEFINE l_x          LIKE type_file.chr30
   DEFINE l_sum1       LIKE type_file.chr30
   DEFINE l_ima01      LIKE ima_file.ima01
   DEFINE l_tc_sfcud01 LIKE tc_sfc_file.tc_sfcud01
   DEFINE l_chr        LIKE type_file.chr30
   DEFINE l_i          LIKE type_file.num5
   DISPLAY TIME   #add by wangxy 20121120                  
   LET tm.wc2 = tm.wc2 CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
    
   #LET l_wc2 = cl_replace_str(tm.wc2,'tc_sfc','tc_shb')      #字符替換
   LET g_cnt = 1 
   LET g_cnt1 = 1
   LET g_cnt2 = 1
   LET l_i = 1
   DELETE FROM cecq007_tmp
   CALL cl_set_comp_visible("tc_sfc01_1,tc_sfc01_2,tc_sfc01_3,tc_sfc01_4,tc_sfc01_5,tc_sfc01_6,tc_sfc01_7,tc_sfc01_8,tc_sfc01_9,tc_sfc01_10",FALSE)
   CALL cl_set_comp_visible("tc_sfc01_11,tc_sfc01_12,tc_sfc01_13,tc_sfc01_14,tc_sfc01_15,tc_sfc01_16,tc_sfc01_17,tc_sfc01_18,tc_sfc01_19,tc_sfc01_20",FALSE)
   CALL cl_set_comp_visible("tc_sfc01_21,tc_sfc01_22,tc_sfc01_23,tc_sfc01_24,tc_sfc01_25,tc_sfc01_26,tc_sfc01_27,tc_sfc01_28,tc_sfc01_29,tc_sfc01_30",FALSE)
   CALL cl_set_comp_visible("tc_sfc01_31,tc_sfc01_32,tc_sfc01_33,tc_sfc01_34,tc_sfc01_35,tc_sfc01_36,tc_sfc01_37,tc_sfc01_38,tc_sfc01_39,tc_sfc01_40",FALSE)
   LET l_sql =  "SELECT ima01,0,0,0,0,0,0,0,0,0,0,",
                "0,0,0,0,0,0,0,0,0,0,",
                "0,0,0,0,0,0,0,0,0,0,",
                "0,0,0,0,0,0,0,0,0,0",
                "  FROM ima_file ",
                " WHERE ",tm.wc2 CLIPPED

     LET l_sql = "INSERT INTO cecq007_tmp ",l_sql CLIPPED
     PREPARE q007_ins FROM l_sql
     EXECUTE q007_ins

LET l_sql2 = "  SELECT  tc_sfc01,ima01  FROM  tc_shb_file,tc_sfc_file,cecq007_tmp",
             "   WHERE  tc_shb01 = '1' AND  tc_sfc02 = tc_shb08 AND  ima01 = tc_shb05",  
             "   GROUP BY ima01,tc_sfc01 ORDER BY ima01,tc_sfc01 "
 PREPARE  q007_prep2 FROM l_sql2
 DECLARE  q007_bcs2  CURSOR FOR q007_prep2 
 FOREACH  q007_bcs2  INTO l_tc_sfc01,l_ima01
 CALL get_sum(l_tc_sfc01,l_ima01)
 END FOREACH 

DISPLAY TIME
END FUNCTION 

FUNCTION get_sum(l_tc_sfc01,l_ima01)
DEFINE l_sql STRING 
DEFINE l_str STRING
DEFINE l_tc_sfc01 LIKE tc_sfc_file.tc_sfc01
DEFINE l_ima01 LIKE ima_file.ima01
DEFINE l_tc_shb12_1 LIKE tc_shb_file.tc_shb12
DEFINE l_tc_shb12_2 LIKE tc_shb_file.tc_shb12
DEFINE l_tc_shb121  LIKE tc_shb_file.tc_shb121
DEFINE l_tc_shb122  LIKE tc_shb_file.tc_shb122
DEFINE sum1         LIKE tc_shb_file.tc_shb12
DEFINE l_x          LIKE type_file.chr30
DEFINE l_msg      STRING 
DEFINE l_tc_sfcud01 LIKE tc_sfc_file.tc_sfcud01

    SELECT SUM(tc_shb12) INTO l_tc_shb12_1 FROM tc_shb_file,tc_sfc_file 
    WHERE  tc_shb01='1' AND tc_sfc02 = tc_shb08 AND  tc_shb05= l_ima01 AND tc_sfc01 = l_tc_sfc01

    SELECT SUM(tc_shb12) INTO l_tc_shb12_2 FROM tc_shb_file,tc_sfc_file
    WHERE  tc_shb01='2' AND  tc_sfc02 = tc_shb08 AND  tc_shb05= l_ima01 AND tc_sfc01 = l_tc_sfc01

    SELECT SUM(tc_shb121),SUM(tc_shb122) INTO l_tc_shb121,l_tc_shb122 FROM tc_shb_file,tc_sfc_file
    WHERE  tc_sfc02 = tc_shb08 AND  tc_shb05= l_ima01 AND tc_sfc01 = l_tc_sfc01

          IF cl_null(l_tc_shb12_1) THEN LET l_tc_shb12_1 = 0 END IF 
          IF cl_null(l_tc_shb12_2) THEN LET l_tc_shb12_2 = 0 END IF 
          IF cl_null(l_tc_shb121) THEN LET l_tc_shb121 = 0 END IF 
          IF cl_null(l_tc_shb122) THEN LET l_tc_shb122 = 0 END IF 
    LET sum1 = l_tc_shb12_1 - l_tc_shb12_2 - l_tc_shb121 - l_tc_shb122
    SELECT substr(l_tc_sfc01,2) INTO l_x FROM dual
     IF l_x[1,1] = '0' THEN LET l_x = l_x[2,2] END IF 
    LET l_msg="tc_sfc01_",l_x CLIPPED
    LET l_str="UPDATE cecq007_tmp SET ",l_msg,"= ",sum1
       PREPARE q007_str FROM l_str
       EXECUTE q007_str
     IF NOT cl_null(l_tc_sfc01) THEN
          SELECT DISTINCT tc_sfcud01 INTO g_msg FROM tc_sfc_file WHERE tc_sfc01=l_tc_sfc01
          IF STATUS THEN LET g_msg = l_tc_sfcud01 END IF   #MOD-5A0432
          CALL cl_set_comp_visible(l_msg,TRUE)
          CALL cl_set_comp_att_text(l_msg,g_msg CLIPPED)
       END IF

END FUNCTION 

