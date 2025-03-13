# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: axmq620_slk.4gl
# Descriptions...: 出貨明細查詢
# Date & Author..: FUN-C40069 12/04/20 By xjll 
# Modify.........: No.FUN-C60072 12/06/20 By qiaozy 去掉一些欄位添加img10,error,將庫位等欄位重新賦值
# Modify.........: No.FUN-C60090 12/07/12 By qiaozy 出貨單相關鏈接 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm      RECORD
              wc      LIKE type_file.chr1000,# Head Where condition 
              wc2     LIKE type_file.chr1000 # Body Where condition  
            END RECORD,
    g_buf             LIKE type_file.chr20,       
    g_oga   RECORD    LIKE oga_file.*,
    g_ogb17           LIKE type_file.chr1,        
    g_ogbslk DYNAMIC ARRAY OF RECORD
            ogbslk03   LIKE ogbslk_file.ogbslk03,
            ogbslk04   LIKE ogbslk_file.ogbslk04,
            ogbslk09   LIKE ogbslk_file.ogbslk09,
            ogbslk091  LIKE ogbslk_file.ogbslk091,
            ogbslk092  LIKE ogbslk_file.ogbslk092,
            ogbslk05   LIKE ogbslk_file.ogbslk05,
            ogbslk12   LIKE ogbslk_file.ogbslk12,
            ogbslk13   LIKE ogbslk_file.ogbslk13,
            ogbslk131  LIKE ogbslk_file.ogbslk131,
            ogbslk1006 LIKE ogbslk_file.ogbslk1006,
            ogbslk14   LIKE ogbslk_file.ogbslk14,
            ogbslk14t  LIKE ogbslk_file.ogbslk14t,
#FUN-C60072----ADD----STR----
            img101     LIKE img_file.img10,
            error1     LIKE type_file.chr1
#FUN-C60072----ADD----END-----
        END RECORD,
    g_ogb    DYNAMIC ARRAY OF RECORD
            ogb03      LIKE ogb_file.ogb03,
            ogb31      LIKE ogb_file.ogb31,
            ogb32      LIKE ogb_file.ogb32,
            ogb04      LIKE ogb_file.ogb04,
            ogb06      LIKE ogb_file.ogb06,
            ogb11      LIKE ogb_file.ogb11,
            ogb1001    LIKE ogb_file.ogb1001,
            ogb17      LIKE ogb_file.ogb17,
            ogb09      LIKE ogb_file.ogb09,
            ogb091     LIKE ogb_file.ogb091,
            ogb092     LIKE ogb_file.ogb092,
            ogb19      LIKE ogb_file.ogb19,
            ogb05      LIKE ogb_file.ogb05,
            ogb12      LIKE ogb_file.ogb12,
            ogb14      LIKE ogb_file.ogb14,
            ogb14t     LIKE ogb_file.ogb14t,
            ogb1002    LIKE ogb_file.ogb1002,
            ogb908     LIKE ogb_file.ogb908,
            ogb44      LIKE ogb_file.ogb44,
            ogb45      LIKE ogb_file.ogb45,
            ogb46      LIKE ogb_file.ogb46,
            ogb47      LIKE ogb_file.ogb47,
#FUN-C60072------ADD-----STR-----
            img10     LIKE img_file.img10,
            error     LIKE type_file.chr1
#FUN-C60072------ADD-----END-----  
        END RECORD,
    g_argv1            LIKE oga_file.oga01,
    g_query_flag       LIKE type_file.num5,   #第一次進入程式時即進入Query之後進入next 
    g_sql              STRING,  
    g_rec_b            LIKE type_file.num10    #單身筆數    
DEFINE p_row,p_col     LIKE type_file.num5       
DEFINE   g_cnt         LIKE type_file.num10     
DEFINE   g_msg         LIKE type_file.chr1000,  
         l_ac          LIKE type_file.num5,
         l_ac2         LIKE type_file.num5,
         l_ac3         LIKE type_file.num5      
 
DEFINE   g_row_count   LIKE type_file.num10   
DEFINE   g_curs_index  LIKE type_file.num10   
DEFINE   g_jump        LIKE type_file.num10     
DEFINE   mi_no_ask     LIKE type_file.num5    
DEFINE g_imxtext   DYNAMIC ARRAY OF RECORD
          color        LIKE type_file.chr50,
          detail   DYNAMIC ARRAY OF RECORD
            size       LIKE type_file.chr50
                   END RECORD
          END RECORD

DEFINE  g_imx  DYNAMIC ARRAY OF RECORD
               color    LIKE type_file.chr20,
               imx01    LIKE type_file.num10,
               imx02    LIKE type_file.num10,
               imx03    LIKE type_file.num10,
               imx04    LIKE type_file.num10,
               imx05    LIKE type_file.num10,
               imx06    LIKE type_file.num10,
               imx07    LIKE type_file.num10,
               imx08    LIKE type_file.num10,
               imx09    LIKE type_file.num10,
               imx10    LIKE type_file.num10,
               imx11    LIKE type_file.num10,
               imx12    LIKE type_file.num10,
               imx13    LIKE type_file.num10,
               imx14    LIKE type_file.num10,
               imx15    LIKE type_file.num10
               END RECORD
DEFINE  g_imx_t  RECORD
               color    LIKE type_file.chr20,
               imx01    LIKE type_file.num10,
               imx02    LIKE type_file.num10,
               imx03    LIKE type_file.num10,
               imx04    LIKE type_file.num10,
               imx05    LIKE type_file.num10,
               imx06    LIKE type_file.num10,
               imx07    LIKE type_file.num10,
               imx08    LIKE type_file.num10,
               imx09    LIKE type_file.num10,
               imx10    LIKE type_file.num10,
               imx11    LIKE type_file.num10,
               imx12    LIKE type_file.num10,
               imx13    LIKE type_file.num10,
               imx14    LIKE type_file.num10,
               imx15    LIKE type_file.num10
               END RECORD
 
MAIN           
   OPTIONS     
      INPUT NO WRAP
   DEFER INTERRUPT
   LET g_argv1 = ARG_VAL(1)    #FUN-C60090---ADD----
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF      
   WHENEVER ERROR CALL cl_err_msg_log
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF      
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
               
   OPEN WINDOW q620_w WITH FORM "axm/42f/axmq620_slk"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()    
               
   CALL cl_set_comp_visible("imx11,imx12,imx13,imx14,imx15",FALSE)
   CALL cl_set_comp_visible("ogb1002,ogb908,ogb45,ogb46,ogb47",FALSE) #FUN-C60072--MARK--
   IF NOT cl_null(g_argv1) THEN CALL q620_q() END IF
   CALL q620_menu()     
   CLOSE WINDOW q620_w  
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN 
 
#QBE 查詢資料
FUNCTION q620_cs()
   DEFINE   l_cnt LIKE type_file.num5      
 
   IF NOT cl_null(g_argv1) THEN
      LET tm.wc="(oga01='",g_argv1,"'"," OR ","oga011='",g_argv1,"')" 
      LET tm.wc2=" 1=1 "
   ELSE 
      CLEAR FORM #清除畫面
      CALL g_ogbslk.clear()
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL
      CALL cl_set_head_visible("","YES") 
      INITIALIZE g_oga.* TO NULL   
    DIALOG ATTRIBUTE(UNBUFFERED)    
      CONSTRUCT BY NAME tm.wc ON oga09,oga01,oga02,oga03,oga04,oga032,
                                      oga14,oga15,ogaconf,ogapost
 
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
      END CONSTRUCT 
      CONSTRUCT tm.wc2 ON ogbslk03,ogbslk04,ogbslk09,ogbslk091,ogbslk092,ogbslk05,ogbslk12,
                          ogbslk13,ogbslk131,ogbslk1006,ogbslk14,ogbslk14t
                  FROM s_ogbslk[1].ogbslk03,s_ogbslk[1].ogbslk04,s_ogbslk[1].ogbslk09,
                       s_ogbslk[1].ogbslk091,s_ogbslk[1].ogbslk092,s_ogbslk[1].ogbslk05,
                       s_ogbslk[1].ogbslk12,s_ogbslk[1].ogbslk13,s_ogbslk[1].ogbslk131,
                       s_ogbslk[1].ogbslk1006,s_ogbslk[1].ogbslk14,s_ogbslk[1].ogbslk14t
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
      END CONSTRUCT

      ON ACTION CONTROLP    
        IF INFIELD(oga01) THEN  #查詢單据
           CALL cl_init_qry_var()
           LET g_qryparam.form ="q_ogbslk01"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO oga01
           NEXT FIELD oga01
        END IF

         IF INFIELD(oga03) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_occ"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO oga03
            NEXT FIELD oga03
         END IF
         IF INFIELD(oga04) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_occ"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO oga04
            NEXT FIELD oga04
         END IF
         IF INFIELD(oga14) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gen"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO oga14
            NEXT FIELD oga14
         END IF
         IF INFIELD(oga15) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gem"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO oga15
            NEXT FIELD oga15
         END IF
         IF INFIELD(ogbslk04) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ogbslk04"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ogbslk04
            NEXT FIELD ogbslk04
         END IF
         IF INFIELD(ogbslk09) THEN
            CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ogbslk09
            NEXT FIELD ogbslk09
         END IF
         IF INFIELD(ogbslk05) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="q_gfe"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ogbslk05
            NEXT FIELD ogbslk05
         END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         ACCEPT DIALOG

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

      ON ACTION ACCEPT
         ACCEPT DIALOG

      ON ACTION EXIT
         LET INT_FLAG = TRUE
         EXIT DIALOG

      ON ACTION CANCEL
         LET INT_FLAG = TRUE
         EXIT DIALOG
      END DIALOG
   END IF
 
   MESSAGE ' WAIT '
   IF tm.wc2 = " 1=1" THEN   
      LET g_sql=" SELECT oga01 FROM oga_file ",
                " WHERE ",tm.wc CLIPPED,
                "   AND ogaconf != 'X' " 
   ELSE
      LET g_sql=" SELECT UNIQUE oga01 FROM oga_file,ogbslk_file ",
                " WHERE oga01=ogbslk01",
                "   AND ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED,
                "   AND ogaconf != 'X' "
   END IF
 
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')
 
   LET g_sql = g_sql clipped," ORDER BY oga01"
 
   PREPARE q620_prepare FROM g_sql
   DECLARE q620_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q620_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   IF tm.wc2 = " 1=1" THEN  
      LET g_sql=" SELECT COUNT(*) FROM oga_file ",
                " WHERE ",tm.wc CLIPPED,
                "   AND ogaconf != 'X' " 
   ELSE
      LET g_sql=" SELECT COUNT(DISTINCT oga01) FROM oga_file,ogbslk_file ",
                " WHERE oga01=ogbslk01",
                "   AND ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED,
                "   AND ogaconf != 'X' " 
   END IF
   PREPARE q620_pp  FROM g_sql
   DECLARE q620_cnt   CURSOR FOR q620_pp
END FUNCTION
 
FUNCTION q620_menu()
 
   WHILE TRUE
      CALL q620_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q620_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ogbslk),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q620_q()
 
  LET g_row_count = 0
  LET g_curs_index = 0
  CALL cl_navigator_setting( g_curs_index, g_row_count )
  CALL cl_opmsg('q')
  DISPLAY '   ' TO FORMONLY.cnt
  CALL q620_cs()
  IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
  OPEN q620_cs                            # 從DB產生合乎條件TEMP(0-30秒)
  IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
  ELSE
      OPEN q620_cnt
      FETCH q620_cnt INTO g_row_count
      DISPLAY g_row_count TO cnt
      CALL q620_fetch('F')                  # 讀出TEMP第一筆並顯示
  END IF
  MESSAGE ''
END FUNCTION
 
FUNCTION q620_fetch(p_flag)
DEFINE  p_flag  LIKE type_file.chr1                  #處理方式     
 
  CASE p_flag
      WHEN 'N' FETCH NEXT     q620_cs INTO g_oga.oga01
      WHEN 'P' FETCH PREVIOUS q620_cs INTO g_oga.oga01
      WHEN 'F' FETCH FIRST    q620_cs INTO g_oga.oga01
      WHEN 'L' FETCH LAST     q620_cs INTO g_oga.oga01
      WHEN '/'
          IF (NOT mi_no_ask) THEN
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              LET INT_FLAG = 0  
              PROMPT g_msg CLIPPED,': ' FOR g_jump
             ON IDLE g_idle_seconds
                CALL cl_on_idle()

             ON ACTION about        
                CALL cl_about()   

             ON ACTION help          
                CALL cl_show_help()  

             ON ACTION controlg  
                CALL cl_cmdask()    

              END PROMPT
              IF INT_FLAG THEN
                  LET INT_FLAG = 0
                  EXIT CASE
              END IF
          END IF
          LET mi_no_ask = FALSE
          FETCH ABSOLUTE g_jump q620_cs INTO g_oga.oga01
  END CASE

  IF SQLCA.sqlcode THEN
      CALL cl_err(g_oga.oga01,SQLCA.sqlcode,0)
      INITIALIZE g_oga.* TO NULL  #TQC-6B0105
      RETURN
  ELSE
     CASE p_flag
        WHEN 'F' LET g_curs_index = 1
        WHEN 'P' LET g_curs_index = g_curs_index - 1
        WHEN 'N' LET g_curs_index = g_curs_index + 1
        WHEN 'L' LET g_curs_index = g_row_count
        WHEN '/' LET g_curs_index = g_jump
     END CASE

     CALL cl_navigator_setting( g_curs_index, g_row_count )
  END IF
      SELECT * INTO g_oga.* FROM oga_file WHERE oga01 = g_oga.oga01
  IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","oga_file",g_oga.oga01,"",SQLCA.sqlcode,"","",0)  
      RETURN
  END IF

  CALL q620_show()
END FUNCTION
 
FUNCTION q620_show()
   DEFINE l_amount1  LIKE ogbslk_file.ogbslk14t
   DEFINE l_amount2  LIKE ogbslk_file.ogbslk14
   DEFINE l_qty      LIKE ogbslk_file.ogbslk12   

   SELECT occ02 INTO g_buf FROM occ_file WHERE occ01=g_oga.oga04
   IF SQLCA.SQLCODE THEN LET g_buf=' ' END IF
   DISPLAY g_buf TO occ02
   DISPLAY BY NAME g_oga.oga09,g_oga.oga01,g_oga.oga02,g_oga.oga03,g_oga.oga032,
                   g_oga.oga04,g_oga.oga14,g_oga.oga15,g_oga.ogaconf,
                   g_oga.ogapost
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      DISPLAY '!' TO ogaconf
      DISPLAY '!' TO ogapost
   END IF
   CALL q620_b_fill_slk() #母單身
   CALL q620_b_fill()     #詳細資料單身
   SELECT SUM(ogbslk14t),SUM(ogbslk14),SUM(ogbslk12) INTO l_amount1,l_amount2,l_qty 
     FROM ogbslk_file WHERE ogbslk01=g_oga.oga01
   DISPLAY l_amount1 TO amount1
   DISPLAY l_amount2 TO amount2
   DISPLAY l_qty     TO qty  
   CALL cl_show_fld_cont()             
END FUNCTION
 
FUNCTION q620_b_fill_slk()                     
   DEFINE l_sql     LIKE type_file.chr1000  
#FUN-C60072-----ADD----STR----
   DEFINE l_ogb03   LIKE ogb_file.ogb03
   DEFINE l_ogb04   LIKE ogb_file.ogb04
   DEFINE l_ogb09   LIKE ogb_file.ogb09
   DEFINE l_ogb091  LIKE ogb_file.ogb091
   DEFINE l_ogb092  LIKE ogb_file.ogb092
   DEFINE l_img10   LIKE img_file.img10
   DEFINE l_ogb12   LIKE ogb_file.ogb12  
   DEFINE l_cn      LIKE type_file.num5 
#FUN-C60072-----ADD----END----- 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
        "SELECT ogbslk03,ogbslk04,ogbslk09,ogbslk091,ogbslk092,ogbslk05,ogbslk12,",
        " ogbslk13,ogbslk131,ogbslk1006,ogbslk14,ogbslk14t,'',''",
        "  FROM ogbslk_file",
        " WHERE ogbslk01 = '",g_oga.oga01,"'"," AND ", tm.wc2 CLIPPED,
        "   AND ",tm.wc2 CLIPPED,
        " ORDER BY 1"
    PREPARE q620_pb_slk FROM l_sql
    DECLARE q620_bcs_slk                       #BODY CURSOR
        CURSOR WITH HOLD FOR q620_pb_slk
 
    FOR g_cnt = 1 TO g_ogbslk.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_ogbslk[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    FOREACH q620_bcs_slk INTO g_ogbslk[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
#FUN-C60072-----ADD-----STR----
        SELECT sum(img10) INTO g_ogbslk[g_cnt].img101 FROM img_file 
         WHERE img02=g_ogbslk[g_cnt].ogbslk09 AND img03=g_ogbslk[g_cnt].ogbslk091
           AND img04=g_ogbslk[g_cnt].ogbslk092 AND img01 IN
               ( SELECT ogb04 FROM ogb_file WHERE ogb01= g_oga.oga01
                    AND ogb03 in (SELECT ogbi03 FROM ogbi_file 
                                   WHERE ogbi01=g_oga.oga01
                                     AND ogbislk02=g_ogbslk[g_cnt].ogbslk03))      

        DECLARE q620_bcs2 CURSOR FOR
         SELECT ogb03,ogb04,ogb09,ogb091,ogb092,ogb12
           FROM ogb_file,ogbi_file,ogbslk_file
          WHERE ogb01=g_oga.oga01 AND ogb01=ogbslk01
            AND ogb01=ogbslk01
            AND ogbslk03=ogbislk02
            AND ogbislk02=g_ogbslk[g_cnt].ogbslk03
            AND ogb_file.ogb01 = ogbi_file.ogbi01
            AND ogb_file.ogb03 = ogbi_file.ogbi03
        LET l_cn=0
        FOREACH q620_bcs2 INTO l_ogb03,l_ogb04,l_ogb09,l_ogb091,l_ogb092,l_ogb12
           SELECT img10 INTO l_img10 FROM img_file
            WHERE img01=l_ogb04 AND img02=l_ogb09
              AND img03=l_ogb091 AND img04=l_ogb092
           IF l_ogb12 > l_img10 OR
              l_ogb12 IS NULL OR
              l_img10 IS NULL THEN
              LET l_cn=l_cn+1
            
           END IF
         
        END FOREACH
        IF l_cn<>0 THEN
           LET g_ogbslk[g_cnt].error1='*'   
           LET l_cn=0
        END IF
#FUN-C60072-----ADD-----END-----
        LET g_cnt = g_cnt+1
    END FOREACH
    CALL g_ogbslk.deleteElement(g_cnt)  
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION

FUNCTION q620_b_fill()                    
   DEFINE l_sql     LIKE type_file.chr1000  
   DEFINE l_cnt     LIKE type_file.num5     

   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
        "SELECT ogb03,ogb31,ogb32,ogb04,ogb06,ogb11,ogb1001,ogb17,ogb09,ogb091,ogb092,",
        " ogb19,ogb05,ogb12,ogb14,ogb14t,ogb1002,ogb908,ogb44,ogb45,ogb46,ogb47,'',''",
        "  FROM ogb_file,ogbslk_file,ogbi_file",
        " WHERE ogb01 = '",g_oga.oga01,"'",
        "   AND ogb01=ogbslk01",
        "   AND ogbslk03=ogbislk02",
        "   AND ogb_file.ogb01 = ogbi_file.ogbi01 ",
        "   AND ogb_file.ogb03 = ogbi_file.ogbi03 ", 
        "   AND ",tm.wc2 CLIPPED,
        " ORDER BY 1"
    PREPARE q620_pb FROM l_sql
    DECLARE q620_bcs                      
        CURSOR WITH HOLD FOR q620_pb

    FOR l_cnt = 1 TO g_ogb.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_ogb[l_cnt].* TO NULL
    END FOR
    LET l_cnt = 1
    FOREACH q620_bcs INTO g_ogb[l_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
#FUN-C60072-----ADD------STR-----
        SELECT img10 INTO g_ogb[l_cnt].img10 FROM img_file
         WHERE img01=g_ogb[l_cnt].ogb04 AND img02=g_ogb[l_cnt].ogb09
           AND img03=g_ogb[l_cnt].ogb091 AND img04=g_ogb[l_cnt].ogb092
        IF g_ogb[l_cnt].ogb12 > g_ogb[l_cnt].img10 OR
           g_ogb[l_cnt].ogb12 IS NULL OR
           g_ogb[l_cnt].img10 IS NULL THEN
           LET g_ogb[l_cnt].error='*'
        END IF 
#FUN-C60072-----ADD------END------           
        LET l_cnt = l_cnt+1
    END FOREACH
    CALL g_ogb.deleteElement(l_cnt)   
END FUNCTION 

FUNCTION q620_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     

   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTE(UNBUFFERED)  
      DISPLAY ARRAY g_ogbslk TO s_ogbslk.* ATTRIBUTE(COUNT=g_rec_b) 
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
        LET l_ac = DIALOG.getCurrentRow("s_ogbslk")
        IF l_ac>0 then
           CALL q620_settext_slk(g_ogbslk[l_ac].ogbslk04)       #加載二維屬性顏色和尺寸
           CALL q620_fillimx_slk(g_ogbslk[l_ac].ogbslk04,g_oga.oga01,g_ogbslk[l_ac].ogbslk03)  #加載對應的數量
        END IF
      END DISPLAY
    
      DISPLAY ARRAY g_imx TO s_imx.*
         BEFORE DISPLAY
            CALL cl_show_fld_cont()
         BEFORE ROW
            LET l_ac2 = DIALOG.getCurrentRow("s_imx")
      END DISPLAY
      
      DISPLAY ARRAY g_ogb TO s_ogb.* 

         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )

         BEFORE ROW
            LET l_ac3 = ARR_CURR()
            CALL cl_show_fld_cont()    
      END DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION first
         CALL q620_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DIALOG               
 
      ON ACTION previous
         CALL q620_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DIALOG        
 
      ON ACTION jump
         CALL q620_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
  	ACCEPT DIALOG        
 
      ON ACTION next
         CALL q620_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	ACCEPT DIALOG            
 
      ON ACTION last
         CALL q620_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	ACCEPT DIALOG         
 
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
         LET l_ac = ARR_CURR()
         EXIT DIALOG  
 
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
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION

# Usage..........:服飾版本母料件的二維屬性加載（顏色、尺寸） CALL s_set_text_slk(p_ima01)
# Input Parameter: p_ima01 母料件編號
FUNCTION q620_settext_slk(p_ima01)
   DEFINE p_ima01     LIKE ima_file.ima01
   DEFINE l_ima151    LIKE ima_file.ima151
   DEFINE l_index     STRING
   DEFINE l_sql       STRING
   DEFINE l_i,l_j     LIKE type_file.num5
   DEFINE lc_agd02    LIKE agd_file.agd02
   DEFINE lc_agd02_2  LIKE agd_file.agd02
   DEFINE lc_agd03    LIKE agd_file.agd03
   DEFINE lc_agd03_2  LIKE agd_file.agd03
   DEFINE l_imx01     LIKE imx_file.imx01
   DEFINE l_imx02     LIKE imx_file.imx02
   DEFINE ls_value    STRING
   DEFINE ls_desc     STRING
   DEFINE l_repeat1   LIKE type_file.chr1,
          l_repeat2   LIKE type_file.chr1
   DEFINE l_colarray  DYNAMIC ARRAY OF RECORD
          color       LIKE type_file.chr50
                      END RECORD
   DEFINE l_agd04     LIKE agd_file.agd04

   SELECT ima151 INTO l_ima151 FROM ima_file
    WHERE ima01 = p_ima01 AND imaacti='Y' AND ima1010='1' #檢查料件
   IF l_ima151 = 'N' OR cl_null(l_ima151) THEN
      CALL cl_set_comp_visible("color,number,count",FALSE)
      FOR l_i = 1 TO 20
         LET l_index = l_i USING '&&'
         CALL cl_set_comp_visible("imx" || l_index,FALSE)
      END FOR
      RETURN
   ELSE
        CALL cl_set_comp_visible("color,number,count",TRUE)
   END IF

#抓取母料件多屬性資料
   LET l_sql = "SELECT DISTINCT(imx02),agd04 FROM imx_file,agd_file",
               " WHERE imx00 = '",p_ima01,"'",
               "   AND imx02=agd02",
               "   AND agd01 IN ",
               " (SELECT ima941 FROM ima_file WHERE ima01='",p_ima01,"')",
               " ORDER BY agd04"
   PREPARE s_f3_pre FROM l_sql
   DECLARE s_f2_cs CURSOR FOR s_f3_pre

   CALL g_imxtext.clear()
   FOREACH s_f2_cs INTO l_imx02,l_agd04
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare2:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      LET g_imxtext[1].detail[g_imxtext[1].detail.getLength()+1].size=l_imx02 CLIPPED
   END FOREACH

   LET l_sql = "SELECT DISTINCT(imx01),agd04 FROM imx_file,agd_file",
               " WHERE imx00 = '",p_ima01,"'",
               "   AND imx01=agd02",
               "   AND agd01 IN ",
               " (SELECT ima940 FROM ima_file WHERE ima01='",p_ima01,"')",
               " ORDER BY agd04"
   PREPARE s_colslk_pre FROM l_sql
   DECLARE s_colslk_cs CURSOR FOR s_colslk_pre

   CALL l_colarray.clear()
   FOREACH s_colslk_cs INTO l_imx01,l_agd04
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare2:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      LET l_colarray[l_colarray.getLength()+1].color=l_imx01 CLIPPED
   END FOREACH

   FOR l_i = 1 TO l_colarray.getLength()
      LET g_imxtext[l_i].* = g_imxtext[1].*
      LET g_imxtext[l_i].color = l_colarray[l_i].color
   END FOR

   FOR l_i = 1 TO g_imxtext.getLength()
      LET lc_agd02 = g_imxtext[l_i].color CLIPPED
      LET ls_value = ls_value,lc_agd02,","
      SELECT agd03 INTO lc_agd03 FROM agd_file,ima_file
       WHERE agd01 = ima940 AND agd02 = lc_agd02
         AND ima01 = p_ima01
      LET ls_desc = ls_desc,lc_agd02,":",lc_agd03 CLIPPED,","
   END FOR
   CALL cl_set_combo_items("color",ls_value.subString(1,ls_value.getLength()-1),ls_desc.subString(1,ls_desc.getLength()-1))
   FOR l_i = 1 TO g_imxtext[1].detail.getLength()
      LET l_index = l_i USING '&&'
      LET lc_agd02_2 = g_imxtext[1].detail[l_i].size CLIPPED
      SELECT agd03 INTO lc_agd03_2 FROM agd_file,ima_file
       WHERE agd01 = ima941 AND agd02 = lc_agd02_2
         AND ima01 = p_ima01
      CALL cl_set_comp_visible("imx" || l_index,TRUE)
      CALL cl_set_comp_att_text("imx" || l_index,lc_agd03_2)
   END FOR
   FOR l_i = g_imxtext[1].detail.getLength()+1 TO 20
      LET l_index = l_i USING '&&'
      CALL cl_set_comp_visible("imx" || l_index,FALSE)
   END FOR
END FUNCTION

#Usage..........: 函數功能說明：此函數為母料件單身調用，用於帶出各個二維屬性對應的子料件的數量值，并儲存在g_imx中
#                               傳入參數：母料件編號，儲存子料件的表的表名,key列名以及key相應的值
#                 如訂單使用此函數：CALL s_fillimx_slk(p_ima01,g_oea.oea01,g_oeaslk[l_ac2].oeaslk03)
#
# Input Parameter: p_ima01            母料件編號
#                  p_keyvalue1        key值1--primary key value1，單據編號
#                  p_keyvalue2        key值2--primary key value2，母料件項次
#
FUNCTION q620_fillimx_slk(p_ima01,p_keyvalue1,p_keyvalue2)
  DEFINE p_ima01             LIKE ima_file.ima01
  DEFINE p_keyvalue1         LIKE type_file.chr20
  DEFINE p_keyvalue2         LIKE type_file.chr20
  DEFINE l_ima151            LIKE ima_file.ima151
  DEFINE l_i,l_j,l_k         LIKE type_file.num5
  DEFINE l_sql               STRING

   SELECT ima151 INTO l_ima151 FROM ima_file
    WHERE ima01 = p_ima01 AND imaacti='Y'
   IF l_ima151 = 'N' OR cl_null(l_ima151) THEN
      RETURN
   END IF

   LET l_sql = "SELECT SUM(ogb12) FROM ogb_file,ogbi_file ",
                        " WHERE ogb04= ?",
                        "   AND ogb01=ogbi01 ",
                        "   AND ogb03=ogbi03 ",
                        "   AND ogbi01='",p_keyvalue1,"'",
                        "   AND ogbislk02='",p_keyvalue2,"'"
   PREPARE q620_getamount_slk_pre FROM l_sql

   CALL g_imx.clear()
   FOR l_k = 1 TO g_imxtext.getLength() #遍歷母料件二維屬性數組
      LET l_i=g_imx.getLength()+1
      LET g_imx[l_i].color = g_imxtext[l_k].color CLIPPED  #得到顏色屬性值
      FOR l_j = 1 TO g_imxtext[1].detail.getLength()
         CASE l_j
          WHEN 1
             CALL q620_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx01
          WHEN 2
             CALL q620_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx02
          WHEN 3
             CALL q620_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx03
          WHEN 4
             CALL q620_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx04
          WHEN 5
             CALL q620_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx05
          WHEN 6
             CALL q620_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx06
          WHEN 7
             CALL q620_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx07
          WHEN 8
             CALL q620_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx08
          WHEN 9
             CALL q620_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx09
          WHEN 10
             CALL q620_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx10
          WHEN 11
             CALL q620_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx11
          WHEN 12
             CALL q620_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx12
          WHEN 13
             CALL q620_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx13
          WHEN 14
             CALL q620_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx14
          WHEN 15
             CALL q620_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx15
         END CASE

      END FOR
   END FOR
   FOR l_i =  g_imx.getLength() TO 1 STEP -1    #如果二維屬性單身的數量全部為零，刪除數據

      IF (g_imx[l_i].imx01 IS NULL OR g_imx[l_i].imx01 = 0) AND
         (g_imx[l_i].imx02 IS NULL OR g_imx[l_i].imx02 = 0) AND
         (g_imx[l_i].imx03 IS NULL OR g_imx[l_i].imx03 = 0) AND
         (g_imx[l_i].imx04 IS NULL OR g_imx[l_i].imx04 = 0) AND
         (g_imx[l_i].imx05 IS NULL OR g_imx[l_i].imx05 = 0) AND
         (g_imx[l_i].imx06 IS NULL OR g_imx[l_i].imx06 = 0) AND
         (g_imx[l_i].imx07 IS NULL OR g_imx[l_i].imx07 = 0) AND
         (g_imx[l_i].imx08 IS NULL OR g_imx[l_i].imx08 = 0) AND
         (g_imx[l_i].imx09 IS NULL OR g_imx[l_i].imx09 = 0) AND
         (g_imx[l_i].imx10 IS NULL OR g_imx[l_i].imx10 = 0) AND
         (g_imx[l_i].imx11 IS NULL OR g_imx[l_i].imx11 = 0) AND
         (g_imx[l_i].imx12 IS NULL OR g_imx[l_i].imx12 = 0) AND
         (g_imx[l_i].imx13 IS NULL OR g_imx[l_i].imx13 = 0) AND
         (g_imx[l_i].imx14 IS NULL OR g_imx[l_i].imx14 = 0) AND
         (g_imx[l_i].imx15 IS NULL OR g_imx[l_i].imx15 = 0)
         THEN
          CALL g_imx.deleteElement(l_i)
      END IF
   END FOR
END FUNCTION

#得到對應的子料件的數量
FUNCTION q620_get_amount_slk(p_j,p_k,p_ima01)
   DEFINE l_sql     STRING
   DEFINE p_j       LIKE type_file.num5
   DEFINE p_k       LIKE type_file.num5
   DEFINE p_ima01   LIKE ima_file.ima01
   DEFINE l_ps      LIKE sma_file.sma46
   DEFINE l_qty     LIKE rvb_file.rvb07
   DEFINE l_ima01   LIKE ima_file.ima01
   DEFINE l_azw05   LIKE azw_file.azw05
   DEFINE l_dbs     LIKE type_file.chr21
   
   SELECT sma46 INTO l_ps FROM sma_file
   IF cl_null(l_ps) THEN
      LET l_ps=' '
   END IF
   LET l_ima01 = p_ima01,l_ps,g_imxtext[p_k].color,l_ps,g_imxtext[p_k].detail[p_j].size  #得到子料件編號
   
   EXECUTE q620_getamount_slk_pre USING l_ima01 INTO l_qty
   
   IF cl_null(l_qty) THEN
      LET l_qty = 0
   END IF
   
   RETURN l_qty

END FUNCTION
-----END FUN-C40069-----
