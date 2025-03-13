# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Descriptions...: 多屬性子料件
# Date & Author..: 05/10/17 By Will
# Modify.........: No.FUN-640013 06/03/28 By Rayven 增加批量生成多屬性子料件功能
# Modify.........: No.TQC-640118 06/04/09 By Rayven 解析數據時'<=','>='判定修正
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: No.FUN-660078 06/06/14 By rainy aim系統中，用char定義的變數，改為用LIK
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
# Modify.........: No.FUN-7B0018 08/03/04 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-830087 08/03/25 By ve007  修改單數屬性值開窗錯誤的bug
# Modify.........: No.FUN-830132 08/03/28 By hellen 將imaicd_file變成icd專用
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50011 10/07/13 By yangfeng 使子料件显示颜色组和尺码组  
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
   g_rows   DYNAMIC ARRAY OF RECORD          #存放多屬性子料件屬性值                                                                
            lists  DYNAMIC ARRAY OF RECORD                                                  
                   fields  DYNAMIC ARRAY OF STRING   
                   END RECORD
            END RECORD
DEFINE
   g_rows1  DYNAMIC ARRAY OF RECORD          #存放多屬性子料件屬性規格                                                                
            lists1 DYNAMIC ARRAY OF RECORD                                                  
                   fields1 DYNAMIC ARRAY OF STRING   
                   END RECORD
            END RECORD
DEFINE
   g_value1 DYNAMIC ARRAY OF RECORD          #存放多屬性子料件各屬性每行的個數
            value2 DYNAMIC ARRAY OF STRING
            END RECORD
DEFINE g_visible      ARRAY[10] OF LIKE type_file.chr1    #判定欄位是否可見  #No.FUN-690026 VARCHAR(1)
DEFINE g_v1           ARRAY[10] OF LIKE type_file.chr1    #預存0~9  #No.FUN-690026 VARCHAR(1)
DEFINE g_v2           ARRAY[26] OF LIKE type_file.chr1    #預存A~B  #No.FUN-690026 VARCHAR(1)
DEFINE g_v3           ARRAY[26] OF LIKE type_file.chr1    #預存a~z  #No.FUN-690026 VARCHAR(1)
DEFINE a,b,c,i,j,k,g_ac0,g_ac,l_count,l_count1  LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE i0,i1,i2,i3,i4,i5,i6,i7,i8,i9            LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE i00,i01,i02,i03,i04,i05,i06,i07,i08,i09  LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE v1  LIKE imx_file.imx01,                         
       v2  LIKE imx_file.imx02,
       v3  LIKE imx_file.imx03,
       v4  LIKE imx_file.imx04,
       v5  LIKE imx_file.imx05,
       v6  LIKE imx_file.imx06,
       v7  LIKE imx_file.imx07,
       v8  LIKE imx_file.imx08,
       v9  LIKE imx_file.imx09,
       v10 LIKE imx_file.imx10
DEFINE ls_value1,ls_value2,ls_value3,
       ls_value4,ls_value5,ls_value6, 
       ls_value7,ls_value8,ls_value9,ls_value10 LIKE ima_file.ima01,#No.FUN-690026 VARCHAR(40)
       ls_spec1,ls_spec2,ls_spec3,ls_spec4,
       ls_spec5,ls_spec6,ls_spec7,ls_spec8,
       ls_spec9,ls_spec10                       LIKE ima_file.ima02 #No.FUN-690026 VARCHAR(60)
DEFINE g_str,g_msg1,g_msg2,g_msg3,g_msg4        LIKE ze_file.ze03   #No.FUN-690026 VARCHAR(40)
DEFINE 
     l_att          DYNAMIC ARRAY OF RECORD    
        att01       LIKE imx_file.imx01,  
        att01_c     LIKE imx_file.imx01,  
        att02       LIKE imx_file.imx02,   
        att02_c     LIKE imx_file.imx02,  
        att03       LIKE imx_file.imx03,  
        att03_c     LIKE imx_file.imx03,  
        att04       LIKE imx_file.imx04,  
        att04_c     LIKE imx_file.imx04,  
        att05       LIKE imx_file.imx05,  
        att05_c     LIKE imx_file.imx05,  
        att06       LIKE imx_file.imx06,  
        att06_c     LIKE imx_file.imx06,  
        att07       LIKE imx_file.imx07,  
        att07_c     LIKE imx_file.imx07,  
        att08       LIKE imx_file.imx08,  
        att08_c     LIKE imx_file.imx08,  
        att09       LIKE imx_file.imx09,  
        att09_c     LIKE imx_file.imx09,  
        att10       LIKE imx_file.imx10, 
        att10_c     LIKE imx_file.imx10,  
        s_ima01     LIKE ima_file.ima01,
        s_ima02     LIKE ima_file.ima02
                    END RECORD
DEFINE g_b          LIKE type_file.num5         #No.TQC-640118  #判定進單身時是否要清空畫面  #No.FUN-690026 SMALLINT
DEFINE 
     g_att          DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
        att01       LIKE imx_file.imx01,  
        att01_c     LIKE imx_file.imx01,  
        att02       LIKE imx_file.imx02,   
        att02_c     LIKE imx_file.imx02,  
        att03       LIKE imx_file.imx03,  
        att03_c     LIKE imx_file.imx03,  
        att04       LIKE imx_file.imx04,  
        att04_c     LIKE imx_file.imx04,  
        att05       LIKE imx_file.imx05,  
        att05_c     LIKE imx_file.imx05,  
        att06       LIKE imx_file.imx06,  
        att06_c     LIKE imx_file.imx06,  
        att07       LIKE imx_file.imx07,  
        att07_c     LIKE imx_file.imx07,  
        att08       LIKE imx_file.imx08,  
        att08_c     LIKE imx_file.imx08,  
        att09       LIKE imx_file.imx09,  
        att09_c     LIKE imx_file.imx09,  
        att10       LIKE imx_file.imx10, 
        att10_c     LIKE imx_file.imx10,  
        s_ima01     LIKE ima_file.ima01,
        s_ima02     LIKE ima_file.ima02
                    END RECORD,
    g_att_t         RECORD                         #程式變數 (舊值)
        att01       LIKE imx_file.imx01,  
        att01_c     LIKE imx_file.imx01,  
        att02       LIKE imx_file.imx02,   
        att02_c     LIKE imx_file.imx02,  
        att03       LIKE imx_file.imx03,  
        att03_c     LIKE imx_file.imx03,  
        att04       LIKE imx_file.imx04,  
        att04_c     LIKE imx_file.imx04,  
        att05       LIKE imx_file.imx05,  
        att05_c     LIKE imx_file.imx05,  
        att06       LIKE imx_file.imx06,  
        att06_c     LIKE imx_file.imx06,  
        att07       LIKE imx_file.imx07,  
        att07_c     LIKE imx_file.imx07,  
        att08       LIKE imx_file.imx08,  
        att08_c     LIKE imx_file.imx08,  
        att09       LIKE imx_file.imx09,  
        att09_c     LIKE imx_file.imx09,  
        att10       LIKE imx_file.imx10, 
        att10_c     LIKE imx_file.imx10,  
        s_ima01     LIKE ima_file.ima01,
        s_ima02     LIKE ima_file.ima02
                    END RECORD,
    g_value         ARRAY[10] OF LIKE ima_file.ima01,  #No.FUN-690026 VARCHAR(40)
    g_agc           DYNAMIC ARRAY OF RECORD                                                                                    
        agc01       LIKE agc_file.agc01,                                                                                       
        agc02       LIKE agc_file.agc02,                                                                                       
        agc03       LIKE agc_file.agc03,                                                                                       
        agc04       LIKE agc_file.agc04,                                                                                       
        agc05       LIKE agc_file.agc05,                                                                                       
        agc06       LIKE agc_file.agc06                                                                                        
                    END RECORD,
    g_wc,g_sql          LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(1000)
    g_rec_b             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    l_ac                LIKE type_file.num5     #目前處理的ARRAY CNT  #No.FUN-690026 SMALLINT
 
DEFINE ps_value     LIKE ima_file.ima01
DEFINE ps_spec      LIKE ima_file.ima02
DEFINE g_forupd_sql STRING                  #SELECT ... FOR UPDATE  SQL
DEFINE g_cnt        LIKE type_file.num10    #No.FUN-690026 INTEGER
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg        LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(72)
DEFINE g_ima940     LIKE ima_file.ima940    #No.FUN-A50011
DEFINE g_ima941     LIKE ima_file.ima941    #No.FUN-A50011
DEFINE g_sub_ima940     LIKE ima_file.ima940    #No.FUN-A50011
DEFINE g_sub_ima941     LIKE ima_file.ima941    #No.FUN-A50011
 
DEFINE li_i           LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       li_col_count   LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       lc_aga01       LIKE aga_file.aga01,     
       lc_agb03       LIKE agb_file.agb03,           
       lc_agd03       LIKE agd_file.agd03,
       lc_agc04       LIKE agc_file.agc04,
       ls_value       like ima_file.ima01,
       ls_spec        like ima_file.ima02,
       ls_item_text   STRING,           
       lc_index       LIKE type_file.chr2,    #No.FUN-690026 VARCHAR(02)
       l_sp           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
       lr_agd         RECORD LIKE agd_file.*
DEFINE g_agc01        LIKE agc_file.agc01       
 
 
FUNCTION saimi311(p_value)
 
    DEFINE p_value       LIKE ima_file.ima01

    WHENEVER ERROR CALL cl_err_msg_log
 
    LET ps_value = p_value
    IF ps_value IS NULL THEN RETURN END IF
 
    OPEN WINDOW i311_w WITH FORM "aim/42f/aimi311"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    CALL cl_ui_locale("aimi311")
 
    #賦初始值
    SELECT ima02 INTO ps_spec FROM ima_file WHERE ima01 = ps_value
    DISPLAY ps_value TO FORMONLY.ima01_p
    DISPLAY ps_spec TO FORMONLY.ima02_p
    SELECT ima940,ima941 INTO g_ima940,g_ima941 FROM ima_file WHERE ima01 = ps_value     #No.FUN-A50011  
    CALL g_att.clear()
    CALL i311_hide()
    LET g_wc = " 1=1" 
 
    CALL i311_menu()
    CLOSE WINDOW i311_w                 #結束畫面
 
END FUNCTION
 
FUNCTION i311_hide()
DEFINE ls_combo_vals  STRING,         
       ls_combo_txts  STRING            
 
   SELECT sma46 INTO l_sp FROM sma_file
 
   FOR li_i = 1 TO 10
       LET lc_index = li_i USING '&&'
       CALL cl_set_comp_visible("att" || lc_index, FALSE)
       CALL cl_set_comp_visible("att" || lc_index || "_c" , FALSE)
   END FOR
 
   SELECT imaag INTO lc_aga01 FROM ima_file WHERE ima01 = ps_value
   IF lc_aga01 IS NULL OR lc_aga01 = '@CHILD' THEN
      RETURN 
   END IF
 
   SELECT COUNT(*) INTO li_col_count FROM agb_file
    WHERE agb01 = lc_aga01
   IF li_col_count = 0 THEN
      RETURN 
   END IF
 
   # 顯現該有的欄位,置換欄位格式
   FOR li_i = 1 TO li_col_count
       SELECT agb03 INTO lc_agb03 FROM agb_file
        WHERE agb01 = lc_aga01 AND agb02 = li_i
 
       LET lc_agb03 = lc_agb03 CLIPPED
       SELECT * INTO g_agc[li_i].* FROM agc_file
        WHERE agc01 = lc_agb03
 
       LET lc_index = li_i USING '&&'
       CASE g_agc[li_i].agc04
               WHEN '1'
                  CALL cl_set_comp_visible("att" || lc_index,TRUE)
                  CALL cl_set_comp_att_text("att" || lc_index,g_agc[li_i].agc02)
                  CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
               WHEN '2'
                  CALL cl_set_comp_visible("att" || lc_index || "_c",TRUE)
                  CALL cl_set_comp_att_text("att" || lc_index || "_c",g_agc[li_i].agc02)
#No.FUN-640013  --start--
#                  LET g_sql = "SELECT * FROM agd_file WHERE agd01 = '",g_agc[li_i].agc01,"'"
#                  DECLARE agd_curs CURSOR FROM g_sql
#                  LET ls_combo_vals = ""
#                  LET ls_combo_txts = ""
#                  FOREACH agd_curs INTO lr_agd.*
#                    IF SQLCA.sqlcode THEN
#                       EXIT FOREACH
#                    END IF
#                    IF ls_combo_vals IS NULL THEN
#                       LET ls_combo_vals = lr_agd.agd02 CLIPPED
#                    ELSE
#                       LET ls_combo_vals = ls_combo_vals,",",lr_agd.agd02 CLIPPED
#                    END IF
#                    IF ls_combo_txts IS NULL THEN
#                       LET ls_combo_txts = lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
#                    ELSE
#                       LET ls_combo_txts = ls_combo_txts,",",lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
#                    END IF
#                  END FOREACH
#                  CALL cl_set_combo_items("formonly.att" || lc_index || "_c",ls_combo_vals,ls_combo_txts)
#                  CALL cl_chg_comp_att("formonly.att" || lc_index || "_c","NOT NULL|REQUIRED|SCROLL","1|1|1")
#No.FUN-640013  --end--
               WHEN '3'
                  CALL cl_set_comp_visible("att" || lc_index,TRUE)
                  CALL cl_set_comp_att_text("att" || lc_index,g_agc[li_i].agc02)
                  CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")       
       END CASE
   END FOR
 
END FUNCTION
 
FUNCTION i311_q()
   CALL i311_b_askkey()
END FUNCTION
 
FUNCTION i311_b_askkey()
DEFINE l_wc     base.STRINGBUFFER
DEFINE s_wc     STRING
DEFINE lc_sma46 LIKE sma_file.sma46   #FUN-660078
 
    CLEAR FORM
    DISPLAY ps_value TO FORMONLY.ima01_p
    DISPLAY ps_spec TO FORMONLY.ima02_p
 
    CALL g_att.clear()
 
    CONSTRUCT g_wc ON att01,att01_c,att02,att02_c,att03,att03_c,att04,att04_c,
                      att05,att05_c,att06,att06_c,att07,att07_c,att08,att08_c,
                      att09,att09_c,att10,att10_c
         FROM s_att[1].att01,s_att[1].att01_c,s_att[1].att02,s_att[1].att02_c,
              s_att[1].att03,s_att[1].att03_c,s_att[1].att04,s_att[1].att04_c,
              s_att[1].att05,s_att[1].att05_c,s_att[1].att06,s_att[1].att06_c,
              s_att[1].att07,s_att[1].att07_c,s_att[1].att08,s_att[1].att08_c,
              s_att[1].att09,s_att[1].att09_c,s_att[1].att10,s_att[1].att10_c
              
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
     ON ACTION about       
        CALL cl_about()      
 
     ON ACTION help       
        CALL cl_show_help()  
 
     ON ACTION controlg     
        CALL cl_cmdask()   
 
    
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
 
      #No.FUN-640013  --start--
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(att01_c) 
               SELECT agc01 INTO g_agc01
                 FROM agc_file
                WHERE agc02 = g_agc[1].agc02                                  
               CALL cl_init_qry_var()                                        
               LET g_qryparam.form     = "q_agd"                            
               LET g_qryparam.state    = "c"
               LET g_qryparam.arg1     = g_agc01                                 
               CALL cl_create_qry() RETURNING g_qryparam.multiret            
               DISPLAY g_qryparam.multiret TO att01_c                           
               NEXT FIELD att01_c
            WHEN INFIELD(att02_c) 
               SELECT agc01 INTO g_agc01
                 FROM agc_file
                WHERE agc02 = g_agc[2].agc02                                  
               CALL cl_init_qry_var()                                        
               LET g_qryparam.form     = "q_agd"                            
               LET g_qryparam.state    = "c"
               LET g_qryparam.arg1     = g_agc01                                 
               CALL cl_create_qry() RETURNING g_qryparam.multiret            
               DISPLAY g_qryparam.multiret TO att02_c                           
               NEXT FIELD att02_c
            WHEN INFIELD(att03_c) 
               SELECT agc01 INTO g_agc01
                 FROM agc_file
                WHERE agc02 = g_agc[3].agc02                                  
               CALL cl_init_qry_var()                                        
               LET g_qryparam.form     = "q_agd"                            
               LET g_qryparam.state    = "c"
               LET g_qryparam.arg1     = g_agc01                                 
               CALL cl_create_qry() RETURNING g_qryparam.multiret            
               DISPLAY g_qryparam.multiret TO att03_c                           
               NEXT FIELD att03_c
            WHEN INFIELD(att04_c) 
               SELECT agc01 INTO g_agc01
                 FROM agc_file
                WHERE agc02 = g_agc[4].agc02                                  
               CALL cl_init_qry_var()                                        
               LET g_qryparam.form     = "q_agd"                            
               LET g_qryparam.state    = "c"
               LET g_qryparam.arg1     = g_agc01                                 
               CALL cl_create_qry() RETURNING g_qryparam.multiret            
               DISPLAY g_qryparam.multiret TO att04_c                           
               NEXT FIELD att04_c
            WHEN INFIELD(att05_c) 
               SELECT agc01 INTO g_agc01
                 FROM agc_file
                WHERE agc02 = g_agc[5].agc02                                  
               CALL cl_init_qry_var()                                        
               LET g_qryparam.form     = "q_agd"                            
               LET g_qryparam.state    = "c"
               LET g_qryparam.arg1     = g_agc01                                 
               CALL cl_create_qry() RETURNING g_qryparam.multiret            
               DISPLAY g_qryparam.multiret TO att05_c                           
               NEXT FIELD att05_c
            WHEN INFIELD(att06_c) 
               SELECT agc01 INTO g_agc01
                 FROM agc_file
                WHERE agc02 = g_agc[6].agc02                                  
               CALL cl_init_qry_var()                                        
               LET g_qryparam.form     = "q_agd"                            
               LET g_qryparam.state    = "c"
               LET g_qryparam.arg1     = g_agc01                                 
               CALL cl_create_qry() RETURNING g_qryparam.multiret            
               DISPLAY g_qryparam.multiret TO att06_c                           
               NEXT FIELD att06_c
            WHEN INFIELD(att07_c) 
               SELECT agc01 INTO g_agc01
                 FROM agc_file
                WHERE agc02 = g_agc[7].agc02                                  
               CALL cl_init_qry_var()                                        
               LET g_qryparam.form     = "q_agd"                            
               LET g_qryparam.state    = "c"
               LET g_qryparam.arg1     = g_agc01                                 
               CALL cl_create_qry() RETURNING g_qryparam.multiret            
               DISPLAY g_qryparam.multiret TO att07_c                           
               NEXT FIELD att07_c
            WHEN INFIELD(att08_c) 
               SELECT agc01 INTO g_agc01
                 FROM agc_file
                WHERE agc02 = g_agc[8].agc02                                  
               CALL cl_init_qry_var()                                        
               LET g_qryparam.form     = "q_agd"                            
               LET g_qryparam.state    = "c"
               LET g_qryparam.arg1     = g_agc01                                 
               CALL cl_create_qry() RETURNING g_qryparam.multiret            
               DISPLAY g_qryparam.multiret TO att08_c                           
               NEXT FIELD att08_c
            WHEN INFIELD(att09_c) 
               SELECT agc01 INTO g_agc01
                 FROM agc_file
                WHERE agc02 = g_agc[9].agc02                                  
               CALL cl_init_qry_var()                                        
               LET g_qryparam.form     = "q_agd"                            
               LET g_qryparam.state    = "c"
               LET g_qryparam.arg1     = g_agc01                                 
               CALL cl_create_qry() RETURNING g_qryparam.multiret            
               DISPLAY g_qryparam.multiret TO att09_c                           
               NEXT FIELD att09_c
            WHEN INFIELD(att10_c) 
               SELECT agc01 INTO g_agc01
                 FROM agc_file
                WHERE agc02 = g_agc[10].agc02                                  
               CALL cl_init_qry_var()                                        
               LET g_qryparam.form     = "q_agd"                            
               LET g_qryparam.state    = "c"
               LET g_qryparam.arg1     = g_agc01                                 
               CALL cl_create_qry() RETURNING g_qryparam.multiret            
               DISPLAY g_qryparam.multiret TO att10_c                           
               NEXT FIELD att10_c
         END CASE
      #No.FUN-640013  --end--
 
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
#   IF INT_FLAG THEN  RETURN END IF
    IF INT_FLAG THEN     #No.FUN-640013
       LET INT_FLAG = 0  #No.FUN-640013
       RETURN            #No.FUN-640013
    END IF               #No.FUN-640013
    SELECT sma46 INTO lc_sma46 FROM sma_file 
    LET l_wc = base.StringBuffer.Create()
#   LET s_wc = g_wc," AND ima01 like '",ps_value,lc_sma46,   #No.FUN-640013
    LET s_wc = g_wc CLIPPED," AND ima01 like '",ps_value CLIPPED,lc_sma46, #No.FUN-640013
                    "%' AND imaag='@CHILD' AND imaag1='",lc_aga01,"'"
    CALL l_wc.append(s_wc)
    CALL l_wc.replace('att','imx',0)
    CALL l_wc.replace('_c','',0)
    LET g_wc = l_wc.toString()
    CALL i311_b_fill(g_wc)
 
END FUNCTION
 
FUNCTION i311_menu()
 
   WHILE TRUE
      CALL i311_bp("G")
      CASE g_action_choice
         WHEN "query" 
            
            IF cl_chk_act_auth() THEN
               CALL i311_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i311_b()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE  
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
 
END FUNCTION
 
#單身
FUNCTION i311_b()
DEFINE
   l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  #No.FUN-690026 SMALLINT
   l_n             LIKE type_file.num5,    #檢查重復用  #No.FUN-690026 SMALLINT
   l_lock_sw       LIKE type_file.chr1,    #單身鎖住否  #No.FUN-690026 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,    #處理狀態    #No.FUN-690026 VARCHAR(1)
   li_min_num      LIKE agc_file.agc05, 
   li_max_num      LIKE agc_file.agc06,
   l_ret           LIKE type_file.num5,    #No.FUN-690026 SMALLINT
   l_value         LIKE ima_file.ima01,
   l_msg           LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(100)
   l_param_list    STRING,
   l_tmp           STRING,
   l_str_tok       base.StringTokenizer
 
   IF s_shut(0) THEN RETURN END IF
   LET g_action_choice = ""
 
   CALL cl_opmsg('b')
   DISPLAY g_msg CLIPPED AT 2,38       #該操作方法為
 
   IF g_b <> 1 THEN  #No.TQC-640118
      CALL g_att.clear()          #No.FUN-640013
      DISPLAY '' TO FORMONLY.cn2  #No.FUN-640013
   END IF            #No.TQC-640118
   LET g_success = 'Y'         #No.FUN-640013
 
   LET g_forupd_sql = "SELECT imx01,imx01,imx02,imx02,imx03,",
                      "       imx03,imx04,imx04,imx05,imx05,",
                      "       imx06,imx06,imx07,imx07,imx08,",
                      "       imx08,imx09,imx09,imx10,imx10,",
#                     "       imx000,ima02", 
                      "       imx000,ima02,imx00",
                      "  FROM imx_file,ima_file",
                      "   WHERE imx000 = ima01 AND imx000 = ?",
                      " FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i311_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_att WITHOUT DEFAULTS FROM s_att.* 
     ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = TRUE,DELETE ROW=TRUE,APPEND ROW=TRUE) 
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW                 #No.FUN-640013
           LET l_ac = ARR_CURR()   #No.FUN-640013
 
#No.FUN-640013  --start--
#        BEFORE ROW
#            LET p_cmd=''
#            LET l_ac = ARR_CURR()
#            LET l_lock_sw = 'N'            #DEFAULT
#
#            IF g_rec_b>=l_ac THEN
#               BEGIN WORK
#               LET p_cmd='u'
#               LET g_att_t.* = g_att[l_ac].*  #BACKUP
#               OPEN i311_bcl USING g_att_t.s_ima01
#               IF STATUS THEN
#                  CALL cl_err("OPEN i311_bcl:", STATUS, 1)
#                  LET l_lock_sw = "Y"
#               ELSE 
#                  FETCH i311_bcl INTO g_att[l_ac].* 
#                  IF SQLCA.sqlcode THEN
#                     CALL cl_err(g_att_t.s_ima01,SQLCA.sqlcode,1)
#                     LET l_lock_sw = "Y"
#                  END IF
#               END IF
#            END IF
#No.FUN-640013  --end--
 
        #No.FUN-640013  --start--
        #預先將0~9,A~Z,a~z的值傳到傳到數組中
        LET g_v1[1]  = '0' LET g_v1[2]  = '1' LET g_v1[3]  = '2'
        LET g_v1[4]  = '3' LET g_v1[5]  = '4' LET g_v1[6]  = '5'
        LET g_v1[7]  = '6' LET g_v1[8]  = '7' LET g_v1[9]  = '8'
        LET g_v1[10] = '9'
        LET g_v2[1]  = 'A' LET g_v2[2]  = 'B' LET g_v2[3]  = 'C'
        LET g_v2[4]  = 'D' LET g_v2[5]  = 'E' LET g_v2[6]  = 'F'
        LET g_v2[7]  = 'G' LET g_v2[8]  = 'H' LET g_v2[9]  = 'I'
        LET g_v2[10] = 'J' LET g_v2[11] = 'K' LET g_v2[12] = 'L'
        LET g_v2[13] = 'M' LET g_v2[14] = 'N' LET g_v2[15] = 'O'
        LET g_v2[16] = 'P' LET g_v2[17] = 'Q' LET g_v2[18] = 'R'
        LET g_v2[19] = 'S' LET g_v2[20] = 'T' LET g_v2[21] = 'U'
        LET g_v2[22] = 'V' LET g_v2[23] = 'W' LET g_v2[24] = 'X'
        LET g_v2[25] = 'Y' LET g_v2[26] = 'Z'
        LET g_v3[1]  = 'a' LET g_v3[2]  = 'b' LET g_v3[3]  = 'c'
        LET g_v3[4]  = 'd' LET g_v3[5]  = 'e' LET g_v3[6]  = 'f'
        LET g_v3[7]  = 'g' LET g_v3[8]  = 'h' LET g_v3[9]  = 'i'
        LET g_v3[10] = 'j' LET g_v3[11] = 'k' LET g_v3[12] = 'l'
        LET g_v3[13] = 'm' LET g_v3[14] = 'n' LET g_v3[15] = 'o'
        LET g_v3[16] = 'p' LET g_v3[17] = 'q' LET g_v3[18] = 'r'
        LET g_v3[19] = 's' LET g_v3[20] = 't' LET g_v3[21] = 'u'
        LET g_v3[22] = 'v' LET g_v3[23] = 'w' LET g_v3[24] = 'x'
        LET g_v3[25] = 'y' LET g_v3[26] = 'z'
        #No.FUN-640013  --end--
 
        BEFORE FIELD att01 
           IF g_agc[1].agc04 = '1' THEN 
              CALL cl_err_msg('','aim-925',g_agc[1].agc03,0)
           ELSE
              IF g_agc[1].agc04 = '3' THEN
#                CALL cl_err_msg('','aim-926',g_agc[1].agc03||'|'||g_agc[1].agc05||'|'||g_agc[1].agc06,0)  #No.FUN-640013
                 CALL cl_err_msg('','aim-926',g_agc[1].agc03 CLIPPED||'|'||g_agc[1].agc05 CLIPPED||'|'||g_agc[1].agc06 CLIPPED,0)  #No.FUN-640013
              END IF   
           END IF 
 
        BEFORE FIELD att02 
           IF g_agc[2].agc04 = '1' THEN 
              CALL cl_err_msg('','aim-925',g_agc[2].agc03,0)
           ELSE
              IF g_agc[2].agc04 = '3' THEN
#                CALL cl_err_msg('','aim-926',g_agc[2].agc03||'|'||g_agc[2].agc05||'|'||g_agc[2].agc06,0)  #No.FUN-640013
                 CALL cl_err_msg('','aim-926',g_agc[2].agc03 CLIPPED||'|'||g_agc[2].agc05 CLIPPED||'|'||g_agc[2].agc06 CLIPPED,0)  #No.FUN-640013
              END IF   
           END IF 
 
        BEFORE FIELD att03 
           IF g_agc[3].agc04 = '1' THEN 
              CALL cl_err_msg('','aim-925',g_agc[3].agc03,0)
           ELSE
              IF g_agc[3].agc04 = '3' THEN
#                CALL cl_err_msg('','aim-926',g_agc[3].agc03||'|'||g_agc[3].agc05||'|'||g_agc[3].agc06,0)  #No.FUN-640013
                 CALL cl_err_msg('','aim-926',g_agc[3].agc03 CLIPPED||'|'||g_agc[3].agc05 CLIPPED||'|'||g_agc[3].agc06 CLIPPED,0)  #No.FUN-640013
              END IF   
           END IF 
 
        BEFORE FIELD att04 
           IF g_agc[4].agc04 = '1' THEN 
              CALL cl_err_msg('','aim-925',g_agc[4].agc03,0)
           ELSE
              IF g_agc[4].agc04 = '3' THEN
#                CALL cl_err_msg('','aim-926',g_agc[4].agc03||'|'||g_agc[4].agc05||'|'||g_agc[4].agc06,0)  #No.FUN-640013
                 CALL cl_err_msg('','aim-926',g_agc[4].agc03 CLIPPED||'|'||g_agc[4].agc05 CLIPPED||'|'||g_agc[4].agc06 CLIPPED,0)  #No.FUN-640013
              END IF   
           END IF 
 
        BEFORE FIELD att05 
           IF g_agc[5].agc04 = '1' THEN 
              CALL cl_err_msg('','aim-925',g_agc[5].agc03,0)
           ELSE
              IF g_agc[5].agc04 = '3' THEN
#                CALL cl_err_msg('','aim-926',g_agc[5].agc03||'|'||g_agc[5].agc05||'|'||g_agc[5].agc06,0)  #No.FUN-640013
                 CALL cl_err_msg('','aim-926',g_agc[5].agc03 CLIPPED||'|'||g_agc[5].agc05 CLIPPED||'|'||g_agc[5].agc06 CLIPPED,0)  #No.FUN-640013
              END IF   
           END IF 
 
        BEFORE FIELD att06 
           IF g_agc[6].agc04 = '1' THEN 
              CALL cl_err_msg('','aim-925',g_agc[6].agc03,0)
           ELSE
              IF g_agc[6].agc04 = '3' THEN
#                CALL cl_err_msg('','aim-926',g_agc[6].agc03||'|'||g_agc[6].agc05||'|'||g_agc[6].agc06,0)  #No.FUN-640013
                 CALL cl_err_msg('','aim-926',g_agc[6].agc03 CLIPPED||'|'||g_agc[6].agc05 CLIPPED||'|'||g_agc[6].agc06 CLIPPED,0)  #No.FUN-640013
              END IF   
           END IF 
 
        BEFORE FIELD att07 
           IF g_agc[7].agc04 = '1' THEN 
              CALL cl_err_msg('','aim-925',g_agc[7].agc03,0)
           ELSE
              IF g_agc[7].agc04 = '3' THEN
#                CALL cl_err_msg('','aim-926',g_agc[7].agc03||'|'||g_agc[7].agc05||'|'||g_agc[7].agc06,0)  #No.FUN-640013
                 CALL cl_err_msg('','aim-926',g_agc[7].agc03 CLIPPED||'|'||g_agc[7].agc05 CLIPPED||'|'||g_agc[7].agc06 CLIPPED,0)  #No.FUN-640013
              END IF   
           END IF 
 
        BEFORE FIELD att08 
           IF g_agc[8].agc04 = '1' THEN 
              CALL cl_err_msg('','aim-925',g_agc[8].agc03,0)
           ELSE
              IF g_agc[8].agc04 = '3' THEN
#                CALL cl_err_msg('','aim-926',g_agc[8].agc03||'|'||g_agc[8].agc05||'|'||g_agc[8].agc06,0)  #No.FUN-640013
                 CALL cl_err_msg('','aim-926',g_agc[8].agc03 CLIPPED||'|'||g_agc[8].agc05 CLIPPED||'|'||g_agc[8].agc06 CLIPPED,0)  #No.FUN-640013
              END IF   
           END IF 
 
        BEFORE FIELD att09 
           IF g_agc[9].agc04 = '1' THEN 
              CALL cl_err_msg('','aim-925',g_agc[9].agc03,0)
           ELSE
              IF g_agc[9].agc04 = '3' THEN
#                CALL cl_err_msg('','aim-926',g_agc[9].agc03||'|'||g_agc[9].agc05||'|'||g_agc[9].agc06,0)  #No.FUN-640013
                 CALL cl_err_msg('','aim-926',g_agc[9].agc03 CLIPPED||'|'||g_agc[9].agc05 CLIPPED||'|'||g_agc[9].agc06 CLIPPED,0)  #No.FUN-640013
              END IF   
           END IF 
 
        BEFORE FIELD att10 
           IF g_agc[10].agc04 = '1' THEN 
              CALL cl_err_msg('','aim-925',g_agc[10].agc03,0)
           ELSE
              IF g_agc[10].agc04 = '3' THEN
#                CALL cl_err_msg('','aim-926',g_agc[10].agc03||'|'||g_agc[10].agc05||'|'||g_agc[10].agc06,0)  #No.FUN-640013
                 CALL cl_err_msg('','aim-926',g_agc[10].agc03 CLIPPED||'|'||g_agc[10].agc05 CLIPPED||'|'||g_agc[10].agc06 CLIPPED,0)  #No.FUN-640013
              END IF   
           END IF 
 
        AFTER FIELD att01
            IF g_att[l_ac].att01 IS NOT NULL THEN
#No.FUN-640013  --start--
#                  LET li_i = 1
#                   #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的
#                        IF LENGTH(GET_FLDBUF(att01)) <> g_agc[li_i].agc03 THEN
#                           CALL cl_err_msg("","aim-911",g_agc[li_i].agc03,1)
#                           NEXT FIELD att01
#                        END IF
#                        #Add By Lifeng End
#                        LET li_min_num = g_agc[li_i].agc05
#                        LET li_max_num = g_agc[li_i].agc06
#                        IF (g_agc[li_i].agc05 IS NOT NULL) AND
#                           (g_att[l_ac].att01 < li_min_num) THEN
#                           CALL cl_err_msg("","lib-232",g_agc[li_i].agc05 || "|" || g_agc[li_i].agc06,1)
#                           NEXT FIELD att01
#                        END IF
#                        IF (g_agc[li_i].agc06 IS NOT NULL) AND
#                           (g_att[l_ac].att01 > li_max_num) THEN
#                           CALL cl_err_msg("","lib-232",g_agc[li_i].agc05 || "|" || g_agc[li_i].agc06,1)
#                           NEXT FIELD att01
#                        END IF
#                  LET g_value[1] = g_att[l_ac].att01
#                  CALL check_subno() RETURNING l_ret,l_value
#                  IF l_ret != 0 THEN
#                     LET g_att[l_ac].att01 = ""
#                     LET g_value[1] = ""
#                     CALL cl_err_msg('','aim-924',l_value,1)
#                     NEXT FIELD att01
#                  END IF
#No.FUN-640013  --end--
                  CALL i311_make_condition(g_att[l_ac].att01,g_agc[1].agc02,'CHAR','',1,l_ac)  #No.FUN-640013                         
                  IF g_success = 'N' THEN  #No.FUN-640013
                     LET g_success = 'Y'   #No.FUN-640013
                     NEXT FIELD att01      #No.FUN-640013
                  END IF                   #No.FUN-640013
             END IF
 
        AFTER FIELD att02
            IF g_att[l_ac].att02 IS NOT NULL THEN
#No.FUN-640013  --start--
#                  LET li_i = 2
#                   #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的
#                        IF LENGTH(GET_FLDBUF(att02)) <> g_agc[li_i].agc03 THEN
#                           CALL cl_err_msg("","aim-911",g_agc[li_i].agc03,1)
#                           NEXT FIELD att02
#                        END IF
#                        #Add By Lifeng End
#                        LET li_min_num = g_agc[li_i].agc05
#                        LET li_max_num = g_agc[li_i].agc06
#                        IF (g_agc[li_i].agc05 IS NOT NULL) AND
#                           (g_att[l_ac].att02 < li_min_num) THEN
#                           CALL cl_err_msg("","lib-232",g_agc[li_i].agc05 || "|" || g_agc[li_i].agc06,1)
#                           NEXT FIELD att02
#                        END IF
#                        IF (g_agc[li_i].agc06 IS NOT NULL) AND
#                           (g_att[l_ac].att02 > li_max_num) THEN
#                           CALL cl_err_msg("","lib-232",g_agc[li_i].agc05 || "|" || g_agc[li_i].agc06,1)
#                           NEXT FIELD att02
#                        END IF
#                   LET g_value[2] = g_att[l_ac].att02
#                   CALL check_subno() RETURNING l_ret,l_value
#                   IF l_ret != 0 THEN
#                      LET g_att[l_ac].att02 = ""
#                      LET g_value[2] = ""
#                      CALL cl_err_msg('','aim-924',l_value,1)
#                      NEXT FIELD att02
#                   END IF
#No.FUN-640013  --end--
                   CALL i311_make_condition(g_att[l_ac].att02,g_agc[2].agc02,'CHAR','',2,l_ac)  #No.FUN-640013                         
                   IF g_success = 'N' THEN  #No.FUN-640013
                      LET g_success = 'Y'   #No.FUN-640013
                      NEXT FIELD att02      #No.FUN-640013
                   END IF                   #No.FUN-640013
             END IF
 
        AFTER FIELD att03
            IF g_att[l_ac].att03 IS NOT NULL THEN
#No.FUN-640013  --start--
#                  LET li_i = 3
#                   #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的
#                        IF LENGTH(GET_FLDBUF(att03)) <> g_agc[li_i].agc03 THEN
#                           CALL cl_err_msg("","aim-911",g_agc[li_i].agc03,1)
#                           NEXT FIELD att03
#                        END IF
#                        #Add By Lifeng End
#                        LET li_min_num = g_agc[li_i].agc05
#                        LET li_max_num = g_agc[li_i].agc06
#                        IF (g_agc[li_i].agc05 IS NOT NULL) AND
#                           (g_att[l_ac].att03< li_min_num) THEN
#                           CALL cl_err_msg("","lib-232",g_agc[li_i].agc05 || "|" || g_agc[li_i].agc06,1)
#                           NEXT FIELD att03
#                        END IF
#                        IF (g_agc[li_i].agc06 IS NOT NULL) AND
#                           (g_att[l_ac].att03> li_max_num) THEN
#                           CALL cl_err_msg("","lib-232",g_agc[li_i].agc05 || "|" || g_agc[li_i].agc06,1)
#                           NEXT FIELD att03
#                        END IF
#                     LET g_value[3] = g_att[l_ac].att03
#                     CALL check_subno() RETURNING l_ret,l_value
#                     IF l_ret != 0 THEN
#                        LET g_att[l_ac].att03 = ""
#                        LET g_value[3] = ""
#                        CALL cl_err_msg('','aim-924',l_value,1)
#                        NEXT FIELD att03
#                     END IF
#No.FUN-640013  --end--
                     CALL i311_make_condition(g_att[l_ac].att03,g_agc[3].agc02,'CHAR','',3,l_ac)  #No.FUN-640013                         
                     IF g_success = 'N' THEN  #No.FUN-640013
                        LET g_success = 'Y'   #No.FUN-640013
                        NEXT FIELD att03      #No.FUN-640013
                     END IF                   #No.FUN-640013
             END IF
 
        AFTER FIELD att04
            IF g_att[l_ac].att04 IS NOT NULL THEN
                   #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的
#No.FUN-640013  --start--
#                  LET li_i = 4
#                        IF LENGTH(GET_FLDBUF(att04)) <> g_agc[li_i].agc03 THEN
#                           CALL cl_err_msg("","aim-911",g_agc[li_i].agc03,1)
#                           NEXT FIELD att04
#                        END IF
#                        #Add By Lifeng End
#                        LET li_min_num = g_agc[li_i].agc05
#                        LET li_max_num = g_agc[li_i].agc06
#                        IF (g_agc[li_i].agc05 IS NOT NULL) AND
#                           (g_att[l_ac].att04 < li_min_num) THEN
#                           CALL cl_err_msg("","lib-232",g_agc[li_i].agc05 || "|" || g_agc[li_i].agc06,1)
#                           NEXT FIELD att04
#                        END IF
#                        IF (g_agc[li_i].agc06 IS NOT NULL) AND
#                           (g_att[l_ac].att04 > li_max_num) THEN
#                           CALL cl_err_msg("","lib-232",g_agc[li_i].agc05 || "|" || g_agc[li_i].agc06,1)
#                           NEXT FIELD att04
#                        END IF
#                  LET g_value[4] = g_att[l_ac].att04
#                  CALL check_subno() RETURNING l_ret,l_value
#                  IF l_ret != 0 THEN
#                     LET g_att[l_ac].att04 = ""
#                     LET g_value[4] = ""
#                     CALL cl_err_msg('','aim-924',l_value,1)
#                     NEXT FIELD att04
#                  END IF
#No.FUN-640013  --end--
                   CALL i311_make_condition(g_att[l_ac].att04,g_agc[4].agc02,'CHAR','',4,l_ac)  #No.FUN-640013                         
                   IF g_success = 'N' THEN   #No.FUN-640013
                      LET g_success = 'Y'    #No.FUN-640013
                      NEXT FIELD att04       #No.FUN-640013
                   END IF                    #No.FUN-640013
              END IF
 
        AFTER FIELD att05
            IF g_att[l_ac].att05 IS NOT NULL THEN
#No.FUN-640013  --start--
#                  LET li_i = 5
#                   #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的
#                        IF LENGTH(GET_FLDBUF(att05)) <> g_agc[li_i].agc03 THEN
#                           CALL cl_err_msg("","aim-911",g_agc[li_i].agc03,1)
#                           NEXT FIELD att05
#                        END IF
#                        #Add By Lifeng End
#                        LET li_min_num = g_agc[li_i].agc05
#                        LET li_max_num = g_agc[li_i].agc06
#                        IF (g_agc[li_i].agc05 IS NOT NULL) AND
#                           (g_att[l_ac].att05 < li_min_num) THEN
#                           CALL cl_err_msg("","lib-232",g_agc[li_i].agc05 || "|" || g_agc[li_i].agc06,1)
#                           NEXT FIELD att05
#                        END IF
#                        IF (g_agc[li_i].agc06 IS NOT NULL) AND
#                           (g_att[l_ac].att05 > li_max_num) THEN
#                           CALL cl_err_msg("","lib-232",g_agc[li_i].agc05 || "|" || g_agc[li_i].agc06,1)
#                           NEXT FIELD att05
#                        END IF
#                  LET g_value[5] = g_att[l_ac].att05
#                  CALL check_subno() RETURNING l_ret,l_value
#                  IF l_ret != 0 THEN
#                     LET g_att[l_ac].att05 = ""
#                     LET g_value[5] = ""
#                     CALL cl_err_msg('','aim-924',l_value,1)
#                     NEXT FIELD att05
#                  END IF
#No.FUN-640013  --end--
                   CALL i311_make_condition(g_att[l_ac].att05,g_agc[5].agc02,'CHAR','',5,l_ac)  #No.FUN-640013                         
                   IF g_success = 'N' THEN   #No.FUN-640013
                      LET g_success = 'Y'    #No.FUN-640013
                      NEXT FIELD att05       #No.FUN-640013
                   END IF                    #No.FUN-640013
             END IF
 
        AFTER FIELD att06
            IF g_att[l_ac].att06 IS NOT NULL THEN
                   #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的
#No.FUN-640013 --start--
#                  LET li_i = 6
#                        IF LENGTH(GET_FLDBUF(att06)) <> g_agc[li_i].agc03 THEN
#                           CALL cl_err_msg("","aim-911",g_agc[li_i].agc03,1)
#                           NEXT FIELD att06
#                        END IF
#                        #Add By Lifeng End
#                        LET li_min_num = g_agc[li_i].agc05
#                        LET li_max_num = g_agc[li_i].agc06
#                        IF (g_agc[li_i].agc05 IS NOT NULL) AND
#                           (g_att[l_ac].att06 < li_min_num) THEN
#                           CALL cl_err_msg("","lib-232",g_agc[li_i].agc05 || "|" || g_agc[li_i].agc06,1)
#                           NEXT FIELD att06
#                        END IF
#                        IF (g_agc[li_i].agc06 IS NOT NULL) AND
#                           (g_att[l_ac].att06 > li_max_num) THEN
#                           CALL cl_err_msg("","lib-232",g_agc[li_i].agc05 || "|" || g_agc[li_i].agc06,1)
#                           NEXT FIELD att06
#                        END IF
#                 LET g_value[6] = g_att[l_ac].att06
#                 CALL check_subno() RETURNING l_ret,l_value
#                 IF l_ret != 0 THEN
#                     LET g_att[l_ac].att06 = ""
#                     LET g_value[6] = ""
#                    CALL cl_err_msg('','aim-924',l_value,1)
#                    NEXT FIELD att06
#                 END IF
#No.FUN-640013  --end--
                   CALL i311_make_condition(g_att[l_ac].att06,g_agc[6].agc02,'CHAR','',6,l_ac)  #No.FUN-640013                         
                   IF g_success = 'N' THEN   #No.FUN-640013
                      LET g_success = 'Y'    #No.FUN-640013
                      NEXT FIELD att06       #No.FUN-640013
                   END IF                    #No.FUN-640013
               END IF
 
        AFTER FIELD att07
            IF g_att[l_ac].att07 IS NOT NULL THEN
                   #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的
#No.FUN-640013 --start--
#                  LET li_i = 7
#                        IF LENGTH(GET_FLDBUF(att07)) <> g_agc[li_i].agc03 THEN
#                           CALL cl_err_msg("","aim-911",g_agc[li_i].agc03,1)
#                           NEXT FIELD att07
#                        END IF
#                        #Add By Lifeng End
#                        LET li_min_num = g_agc[li_i].agc05
#                        LET li_max_num = g_agc[li_i].agc06
#                        IF (g_agc[li_i].agc05 IS NOT NULL) AND
#                           (g_att[l_ac].att07< li_min_num) THEN
#                           CALL cl_err_msg("","lib-232",g_agc[li_i].agc05 || "|" || g_agc[li_i].agc06,1)
#                           NEXT FIELD att07
#                        END IF
#                        IF (g_agc[li_i].agc06 IS NOT NULL) AND
#                           (g_att[l_ac].att07 > li_max_num) THEN
#                           CALL cl_err_msg("","lib-232",g_agc[li_i].agc05 || "|" || g_agc[li_i].agc06,1)
#                           NEXT FIELD att07
#                        END IF
#                  LET g_value[7] = g_att[l_ac].att07
#                 CALL check_subno() RETURNING l_ret,l_value
#                 IF l_ret != 0 THEN
#                     LET g_att[l_ac].att07 = ""
#                     LET g_value[7] = ""
#                    CALL cl_err_msg('','aim-924',l_value,1)
#                    NEXT FIELD att07
#                 END IF
#No.FUN-640013  --end--
                   CALL i311_make_condition(g_att[l_ac].att07,g_agc[7].agc02,'CHAR','',7,l_ac)  #No.FUN-640013                         
                   IF g_success = 'N' THEN   #No.FUN-640013
                      LET g_success = 'Y'    #No.FUN-640013
                      NEXT FIELD att07       #No.FUN-640013
                   END IF                    #No.FUN-640013
               END IF
 
        AFTER FIELD att08
            IF g_att[l_ac].att08 IS NOT NULL THEN
                   #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的
#No.FUN-640013 --start--
#                  LET li_i = 8
#                        IF LENGTH(GET_FLDBUF(att08)) <> g_agc[li_i].agc03 THEN
#                           CALL cl_err_msg("","aim-911",g_agc[li_i].agc03,1)
#                           NEXT FIELD att08
#                        END IF
#                        #Add By Lifeng End
#                        LET li_min_num = g_agc[li_i].agc05
#                        LET li_max_num = g_agc[li_i].agc06
#                        IF (g_agc[li_i].agc05 IS NOT NULL) AND
#                           (g_att[l_ac].att08 < li_min_num) THEN
#                           CALL cl_err_msg("","lib-232",g_agc[li_i].agc05 || "|" || g_agc[li_i].agc06,1)
#                           NEXT FIELD att08
#                        END IF
#                        IF (g_agc[li_i].agc06 IS NOT NULL) AND
#                           (g_att[l_ac].att08 > li_max_num) THEN
#                           CALL cl_err_msg("","lib-232",g_agc[li_i].agc05 || "|" || g_agc[li_i].agc06,1)
#                           NEXT FIELD att08
#                        END IF
#               LET g_value[8] = g_att[l_ac].att08
#               CALL check_subno() RETURNING l_ret,l_value
#               IF l_ret != 0 THEN
#                     LET g_att[l_ac].att08 = ""
#                     LET g_value[8] = ""
#                  CALL cl_err_msg('','aim-924',l_value,1)
#                  NEXT FIELD att08
#               END IF
#No.FUN-640013  --end--
                   CALL i311_make_condition(g_att[l_ac].att08,g_agc[8].agc02,'CHAR','',8,l_ac)  #No.FUN-640013                         
                   IF g_success = 'N' THEN   #No.FUN-640013
                      LET g_success = 'Y'    #No.FUN-640013
                      NEXT FIELD att08       #No.FUN-640013
                   END IF                    #No.FUN-640013
             END IF
 
        AFTER FIELD att09
            IF g_att[l_ac].att09 IS NOT NULL THEN
#No.FUN-640013 --start--
#                  LET li_i = 9
#                   #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的
#                        IF LENGTH(GET_FLDBUF(att09)) <> g_agc[li_i].agc03 THEN
#                           CALL cl_err_msg("","aim-911",g_agc[li_i].agc03,1)
#                           NEXT FIELD att09
#                        END IF
#                        #Add By Lifeng End
#                        LET li_min_num = g_agc[li_i].agc05
#                        LET li_max_num = g_agc[li_i].agc06
#                        IF (g_agc[li_i].agc05 IS NOT NULL) AND
#                           (g_att[l_ac].att09 < li_min_num) THEN
#                           CALL cl_err_msg("","lib-232",g_agc[li_i].agc05 || "|" || g_agc[li_i].agc06,1)
#                           NEXT FIELD att09
#                        END IF
#                        IF (g_agc[li_i].agc06 IS NOT NULL) AND
#                           (g_att[l_ac].att09 > li_max_num) THEN
#                           CALL cl_err_msg("","lib-232",g_agc[li_i].agc05 || "|" || g_agc[li_i].agc06,1)
#                           NEXT FIELD att09
#                        END IF
#               LET g_value[9] = g_att[l_ac].att09
#               CALL check_subno() RETURNING l_ret,l_value
#               IF l_ret != 0 THEN
#                  LET g_att[l_ac].att09 = ""
#                  LET g_value[9] = ""
#                  CALL cl_err_msg('','aim-924',l_value,1)
#                  NEXT FIELD att09
#               END IF
#No.FUN-640013  --end--
                   CALL i311_make_condition(g_att[l_ac].att09,g_agc[9].agc02,'CHAR','',9,l_ac)  #No.FUN-640013                         
                   IF g_success = 'N' THEN   #No.FUN-640013
                      LET g_success = 'Y'    #No.FUN-640013
                      NEXT FIELD att09       #No.FUN-640013
                   END IF                    #No.FUN-640013
            END IF
 
        AFTER FIELD att10
            IF g_att[l_ac].att10 IS NOT NULL THEN
#No.FUN-640013 --start--
#                  LET li_i = 10
#                   #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的
#                        IF LENGTH(GET_FLDBUF(att10)) <> g_agc[10].agc03 THEN
#                           CALL cl_err_msg("","aim-911",g_agc[10].agc03,1)
#                           NEXT FIELD att10
#                        END IF
#                        #Add By Lifeng End
#                        LET li_min_num = g_agc[10].agc05
#                        LET li_max_num = g_agc[10].agc06
#                        IF (g_agc[li_i].agc05 IS NOT NULL) AND
#                           (g_att[l_ac].att10 < li_min_num) THEN
#                           CALL cl_err_msg("","lib-232",g_agc[10].agc05 || "|" || g_agc[li_i].agc06,1)
#                           NEXT FIELD att10
#                        END IF
#                        IF (g_agc[li_i].agc06 IS NOT NULL) AND
#                           (g_att[l_ac].att10 > li_max_num) THEN
#                           CALL cl_err_msg("","lib-232",g_agc[10].agc05 || "|" || g_agc[li_i].agc06,1)
#                           NEXT FIELD att10
#                        END IF
#               LET g_value[10] = g_att[l_ac].att10
#               CALL check_subno() RETURNING l_ret,l_value
#               IF l_ret != 0 THEN
#                  LET g_att[l_ac].att10 = ""
#                  LET g_value[10] = ""
#                  CALL cl_err_msg('','aim-924',l_value,1)
#                  NEXT FIELD att10
#               END IF
#No.FUN-640013  --end--
                   CALL i311_make_condition(g_att[l_ac].att10,g_agc[10].agc02,'CHAR','',10,l_ac)  #No.FUN-640013                         
                   IF g_success = 'N' THEN   #No.FUN-640013
                      LET g_success = 'Y'    #No.FUN-640013
                      NEXT FIELD att10       #No.FUN-640013
                   END IF                    #No.FUN-640013
             END IF
 
        AFTER FIELD att01_c
            IF g_att[l_ac].att01_c IS NOT NULL THEN
#No.FUN-640013 --start--
#                LET g_value[1] = g_att[l_ac].att01_c
#                 CALL check_subno() RETURNING l_ret,l_value
#                 IF l_ret != 0 THEN
#                    LET g_att[l_ac].att01_c = ""
#                    LET g_value[1] = ""
#                    CALL cl_err_msg('','aim-924',l_value,1)
#                    NEXT FIELD att01_c
#                 END IF
#No.FUN-640013  --end--
                 CALL i311_make_condition(g_att[l_ac].att01_c,g_agc[1].agc02,'CHAR','',1,l_ac)  #No.FUN-640013                         
                 IF g_success = 'N' THEN   #No.FUN-640013
                    LET g_success = 'Y'    #No.FUN-640013
                    NEXT FIELD att01_c     #No.FUN-640013
                 END IF                    #No.FUN-640013
            END IF
 
        AFTER FIELD att02_c
            IF g_att[l_ac].att02_c IS NOT NULL THEN
#No.FUN-640013 --start--
#                LET g_value[2] = g_att[l_ac].att02_c
#                 CALL check_subno() RETURNING l_ret,l_value
#                 IF l_ret != 0 THEN
#                    LET g_att[l_ac].att02_c = ""
#                    LET g_value[2] = ""
#                    CALL cl_err_msg('','aim-924',l_value,1)
#                    NEXT FIELD att02_c
#                 END IF
#No.FUN-640013  --end--
                 CALL i311_make_condition(g_att[l_ac].att02_c,g_agc[2].agc02,'CHAR','',2,l_ac)  #No.FUN-640013                         
                 IF g_success = 'N' THEN   #No.FUN-640013
                    LET g_success = 'Y'    #No.FUN-640013
                    NEXT FIELD att02_c     #No.FUN-640013
                 END IF                    #No.FUN-640013
            END IF
 
        AFTER FIELD att03_c
           IF g_att[l_ac].att03_c IS NOT NULL THEN
#No.FUN-640013 --start--
#              LET g_value[3] = g_att[l_ac].att03_c
#                 CALL check_subno() RETURNING l_ret,l_value
#                 IF l_ret != 0 THEN
#                    LET g_att[l_ac].att03_c = ""
#                    LET g_value[3] = ""
#                    CALL cl_err_msg('','aim-924',l_value,1)
#                    NEXT FIELD att03_c
#                 END IF
#No.FUN-640013  --end--
                 CALL i311_make_condition(g_att[l_ac].att03_c,g_agc[3].agc02,'CHAR','',3,l_ac)  #No.FUN-640013                         
                 IF g_success = 'N' THEN   #No.FUN-640013
                    LET g_success = 'Y'    #No.FUN-640013
                    NEXT FIELD att03_c     #No.FUN-640013
                 END IF                    #No.FUN-640013
           END IF
 
        AFTER FIELD att04_c
           IF g_att[l_ac].att04_c IS NOT NULL THEN
#No.FUN-640013 --start--
#              LET g_value[4] = g_att[l_ac].att04_c
#                 CALL check_subno() RETURNING l_ret,l_value
#                 IF l_ret != 0 THEN
#                    LET g_att[l_ac].att04_c = ""
#                    LET g_value[4] = ""
#                    CALL cl_err_msg('','aim-924',l_value,1)
#                    NEXT FIELD att04_c
#                 END IF
#No.FUN-640013  --end--
                 CALL i311_make_condition(g_att[l_ac].att04_c,g_agc[4].agc02,'CHAR','',4,l_ac)  #No.FUN-640013                         
                 IF g_success = 'N' THEN   #No.FUN-640013
                    LET g_success = 'Y'    #No.FUN-640013
                    NEXT FIELD att04_c     #No.FUN-640013
                 END IF                    #No.FUN-640013
           END IF
 
        AFTER FIELD att05_c
           IF g_att[l_ac].att05_c IS NOT NULL THEN
#No.FUN-640013 --start--
#              LET g_value[5] = g_att[l_ac].att05_c
#                 CALL check_subno() RETURNING l_ret,l_value
#                 IF l_ret != 0 THEN
#                    LET g_att[l_ac].att05_c = ""
#                    LET g_value[5] = ""
#                    CALL cl_err_msg('','aim-924',l_value,1)
#                    NEXT FIELD att05_c
#                 END IF
#No.FUN-640013  --end--
                 CALL i311_make_condition(g_att[l_ac].att05_c,g_agc[5].agc02,'CHAR','',5,l_ac)  #No.FUN-640013                         
                 IF g_success = 'N' THEN   #No.FUN-640013
                    LET g_success = 'Y'    #No.FUN-640013
                    NEXT FIELD att05_c     #No.FUN-640013
                 END IF                    #No.FUN-640013
           END IF
 
        AFTER FIELD att06_c
           IF g_att[l_ac].att06_c IS NOT NULL THEN
#No.FUN-640013 --start--
#              LET g_value[6] = g_att[l_ac].att06_c
#                 CALL check_subno() RETURNING l_ret,l_value
#                 IF l_ret != 0 THEN
#                    LET g_att[l_ac].att06_c = ""
#                    LET g_value[6] = ""
#                    CALL cl_err_msg('','aim-924',l_value,1)
#                    NEXT FIELD att06_c
#                 END IF
#No.FUN-640013  --end--
                 CALL i311_make_condition(g_att[l_ac].att06_c,g_agc[6].agc02,'CHAR','',6,l_ac)  #No.FUN-640013                         
                 IF g_success = 'N' THEN   #No.FUN-640013
                    LET g_success = 'Y'    #No.FUN-640013
                    NEXT FIELD att06_c     #No.FUN-640013
                 END IF                    #No.FUN-640013
           END IF
 
        AFTER FIELD att07_c
           IF g_att[l_ac].att07_c IS NOT NULL THEN
#No.FUN-640013 --start--
#              LET g_value[7] = g_att[l_ac].att07_c
#                 CALL check_subno() RETURNING l_ret,l_value
#                 IF l_ret != 0 THEN
#                    LET g_att[l_ac].att07_c = ""
#                    LET g_value[7] = ""
#                    CALL cl_err_msg('','aim-924',l_value,1)
#                    NEXT FIELD att07_c
#                 END IF
#No.FUN-640013  --end--
                 CALL i311_make_condition(g_att[l_ac].att07_c,g_agc[7].agc02,'CHAR','',7,l_ac)  #No.FUN-640013                         
                 IF g_success = 'N' THEN   #No.FUN-640013
                    LET g_success = 'Y'    #No.FUN-640013
                    NEXT FIELD att07_c     #No.FUN-640013
                 END IF                    #No.FUN-640013
           END IF
 
        AFTER FIELD att08_c
           IF g_att[l_ac].att08_c IS NOT NULL THEN
#No.FUN-640013  --start--
#              LET g_value[8] = g_att[l_ac].att08_c
#                 CALL check_subno() RETURNING l_ret,l_value
#                 IF l_ret != 0 THEN
#                    LET g_att[l_ac].att08_c = ""
#                    LET g_value[8] = ""
#                    CALL cl_err_msg('','aim-924',l_value,1)
#                    NEXT FIELD att08_c
#                 END IF
#No.FUN-640013  --end--
                 CALL i311_make_condition(g_att[l_ac].att08_c,g_agc[8].agc02,'CHAR','',8,l_ac)  #No.FUN-640013                         
                 IF g_success = 'N' THEN   #No.FUN-640013
                    LET g_success = 'Y'    #No.FUN-640013
                    NEXT FIELD att08_c     #No.FUN-640013
                 END IF                    #No.FUN-640013
           END IF
 
        AFTER FIELD att09_c
           IF g_att[l_ac].att09_c IS NOT NULL THEN
#No.FUN-640013  --start--
#              LET g_value[9] = g_att[l_ac].att09_c
#                 CALL check_subno() RETURNING l_ret,l_value
#                 IF l_ret != 0 THEN
#                    LET g_att[l_ac].att09_c = ""
#                    LET g_value[9] = ""
#                    CALL cl_err_msg('','aim-924',l_value,1)
#                    NEXT FIELD att09_c
#                 END IF
#No.FUN-640013  --end--
                 CALL i311_make_condition(g_att[l_ac].att09_c,g_agc[9].agc02,'CHAR','',9,l_ac)  #No.FUN-640013                         
                 IF g_success = 'N' THEN   #No.FUN-640013
                    LET g_success = 'Y'    #No.FUN-640013
                    NEXT FIELD att09_c     #No.FUN-640013
                 END IF                    #No.FUN-640013
           END IF
 
        AFTER FIELD att10_c
           IF g_att[l_ac].att10_c IS NOT NULL THEN
#No.FUN-640013  --start--
#              LET g_value[10] = g_att[l_ac].att10_c
#                 CALL check_subno() RETURNING l_ret,l_value
#                 IF l_ret != 0 THEN
#                    LET g_att[l_ac].att10_c = ""
#                    LET g_value[10] = ""
#                    CALL cl_err_msg('','aim-924',l_value,1)
#                    NEXT FIELD att10_c
#                END IF
#No.FUN-640013  --end--
                 CALL i311_make_condition(g_att[l_ac].att10_c,g_agc[10].agc02,'CHAR','',10,l_ac)  #No.FUN-640013                         
                 IF g_success = 'N' THEN   #No.FUN-640013
                    LET g_success = 'Y'    #No.FUN-640013
                    NEXT FIELD att10_c     #No.FUN-640013
                 END IF                    #No.FUN-640013
           END IF
 
#No.FUN-640013  --start--
#        BEFORE INSERT
#            LET l_n = ARR_COUNT()
#            LET p_cmd='a'
#            INITIALIZE g_att[l_ac].* TO NULL      
#            LET g_att_t.* = g_att[l_ac].*     
#            CALL g_value.clear()
#            NEXT FIELD att01
#
#        AFTER INSERT
#           IF INT_FLAG THEN
#              CALL cl_err('',9001,0)
#              LET INT_FLAG = 0
#              CLOSE i311_bcl
#              CANCEL INSERT
#           END IF
#
#           LET ls_value = ps_value
#           LET ls_spec = ps_spec
#
#           FOR li_i = 1 TO li_col_count
#               IF g_value[li_i] IS NOT NULL THEN
#                  LET ls_value = ls_value CLIPPED,l_sp,g_value[li_i]
#                  SELECT agc04 INTO lc_agc04 FROM agc_file
#                   WHERE agc01 = g_agc[li_i].agc01
#                  IF lc_agc04 = '2' THEN
#                     SELECT agd03 INTO lc_agd03 FROM agd_file
#                      WHERE agd01 = g_agc[li_i].agc01
#                        AND agd02 = g_value[li_i]
#                     LET ls_spec = ls_spec CLIPPED,l_sp,lc_agd03
#                  ELSE
#                     LET ls_spec = ls_spec CLIPPED,l_sp,g_value[li_i]
#                  END IF
#               END IF 
#            END FOR 
#
#           #Add By Lifeng Start
#           #先解析ls_value生成要傳給cl_copy_bom的那個l_param_list
#           LET l_str_tok = base.StringTokenizer.create(ls_value,l_sp)
#           LET l_tmp = l_str_tok.nextToken()   #先把第一個部分--名稱去掉
#
#           LET g_sql = "SELECT agb03 FROM agb_file,ima_file WHERE ",
#                        "ima01 = '",ps_value CLIPPED,"' AND agb01 = imaag ",
#                        "ORDER BY agb02"
#           DECLARE param_curs CURSOR FROM g_sql
#           FOREACH param_curs INTO lc_agb03
#             #l_str_tok中的Tokens數量應該和param_curs中的記錄數量完全一致
#             IF cl_null(l_param_list) THEN
#                LET l_param_list = '#',lc_agb03,'#|',l_str_tok.nextToken()
#             ELSE
#                LET l_param_list = l_param_list,'|#',lc_agb03,'#|',l_str_tok.nextToken()
#             END IF
#           END FOREACH
#
#           LET g_att[l_ac].s_ima01 = ls_value
#           LET g_att[l_ac].s_ima02 = ls_spec
#           DISPLAY ls_value TO s_ima01
#           DISPLAY ls_spec  TO s_ima02 
#           LET g_rec_b = g_rec_b + 1
#           DISPLAY g_rec_b TO FORMONLY.cn2 
#
#           #向ima_file中插入新生成的料件記錄
#               IF cl_copy_ima(ps_value,ls_value,ls_spec,l_param_list) = TRUE THEN
#                  #如果向其中成功插入記錄則同步插入屬性記錄到imx_file中去
#                  INSERT INTO imx_file VALUES(ls_value,g_value[1],g_value[2],
#                    g_value[3],g_value[4],g_value[5],g_value[6],g_value[7],
#                    g_value[8],g_value[9],g_value[10])}
#                  #如果向imx_file中插入記錄失敗則也應將ima_file中已經建立的紀錄刪除以保證兩邊
#                  #記錄的完全同步
#                  IF SQLCA.sqlcode THEN
#                     CALL cl_err('Failure to insert imx_file , rollback insert to ima_file !','',1)
#                     DELETE FROM ima_file WHERE ima01 = ls_value
#                  END IF
##                 SELECT ze03 INTO l_msg FROM ze_file
##                  WHERE ze01 = 'aim-924' AND ze02 = g_lang
##                 ERROR l_msg
##                 CALL cl_err_msg('','aim-924',ls_value,1)
#               END IF
#
#
#        AFTER ROW
#           LET l_ac = ARR_CURR()       
#           LET l_ac_t = l_ac                
#           IF INT_FLAG THEN               
#              CALL cl_err('',9001,0)
#              LET INT_FLAG = 0
#              IF p_cmd='u' THEN
#                 LET g_att[l_ac].* = g_att_t.*
#              END IF
#              CLOSE i311_bcl
#              ROLLBACK WORK
#              EXIT INPUT
#           END IF
#           CLOSE i311_bcl
#           COMMIT WORK
#No.FUN-640013  --end--
 
        ON ACTION CONTROLN
            CALL i311_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(att01) AND l_ac > 1 THEN
                LET g_att[l_ac].* = g_att[l_ac-1].*
                DISPLAY g_att[l_ac].* TO s_oxa[l_ac].*
                NEXT FIELD att01
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
  
        #No.FUN-640013  --start--
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(att01_c)
               #No.FUN-830087--begin 
                { SELECT agc01 INTO g_agc01
                   FROM agc_file
                  WHERE agc02 = g_agc[1].agc02  }
                 SELECT agb03 INTO g_agc01
                   FROM agb_file  
                  WHERE agb01 = lc_aga01 
                    AND agb02 = 1
                 #No.FUN-830087 --end--                               
                 CALL cl_init_qry_var()                                        
                 LET g_qryparam.form     = "q_agd"                            
                 LET g_qryparam.default1 = g_att[l_ac].att01_c 
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.arg1     = g_agc01                                 
                 CALL cl_create_qry() RETURNING g_att[l_ac].att01_c            
                 DISPLAY BY NAME g_att[l_ac].att01_c                           
                 NEXT FIELD att01_c
              WHEN INFIELD(att02_c)
               #No.FUN-830087--begin 
                { SELECT agc01 INTO g_agc01
                   FROM agc_file
                  WHERE agc02 = g_agc[2].agc02  }
                 SELECT agb03 INTO g_agc01
                   FROM agb_file  
                  WHERE agb01 = lc_aga01 
                    AND agb02 = 2
                 #No.FUN-830087 --end--                                 
                 CALL cl_init_qry_var()                                        
                 LET g_qryparam.form     = "q_agd"                            
                 LET g_qryparam.default1 = g_att[l_ac].att02_c 
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.arg1     = g_agc01                                 
                 CALL cl_create_qry() RETURNING g_att[l_ac].att02_c            
                 DISPLAY BY NAME g_att[l_ac].att02_c
                 NEXT FIELD att02_c
              WHEN INFIELD(att03_c)
                 #No.FUN-830087--begin 
                { SELECT agc01 INTO g_agc01
                   FROM agc_file
                  WHERE agc02 = g_agc[3].agc02  }
                 SELECT agb03 INTO g_agc01
                   FROM agb_file  
                  WHERE agb01 = lc_aga01 
                    AND agb02 = 3
                 #No.FUN-830087 --end--                                   
                 CALL cl_init_qry_var()                                        
                 LET g_qryparam.form     = "q_agd"                            
                 LET g_qryparam.default1 = g_att[l_ac].att03_c 
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.arg1     = g_agc01                                 
                 CALL cl_create_qry() RETURNING g_att[l_ac].att03_c            
                 DISPLAY BY NAME g_att[l_ac].att03_c                           
                 NEXT FIELD att03_c
              WHEN INFIELD(att04_c) 
                 SELECT agc01 INTO g_agc01
                   FROM agc_file
                  WHERE agc02 = g_agc[4].agc02                                  
                 CALL cl_init_qry_var()                                        
                 LET g_qryparam.form     = "q_agd"                            
                 LET g_qryparam.default1 = g_att[l_ac].att04_c 
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.arg1     = g_agc01                                 
                 CALL cl_create_qry() RETURNING g_att[l_ac].att04_c            
                 DISPLAY BY NAME g_att[l_ac].att04_c                           
                 NEXT FIELD att04_c
              WHEN INFIELD(att05_c) 
                 SELECT agc01 INTO g_agc01
                   FROM agc_file
                  WHERE agc02 = g_agc[5].agc02                                  
                 CALL cl_init_qry_var()                                        
                 LET g_qryparam.form     = "q_agd"                            
                 LET g_qryparam.default1 = g_att[l_ac].att05_c 
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.arg1     = g_agc01                                 
                 CALL cl_create_qry() RETURNING g_att[l_ac].att05_c            
                 DISPLAY BY NAME g_att[l_ac].att05_c                           
                 NEXT FIELD att05_c
              WHEN INFIELD(att06_c) 
                 SELECT agc01 INTO g_agc01
                   FROM agc_file
                  WHERE agc02 = g_agc[6].agc02                                  
                 CALL cl_init_qry_var()                                        
                 LET g_qryparam.form     = "q_agd"                            
                 LET g_qryparam.default1 = g_att[l_ac].att06_c 
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.arg1     = g_agc01                                 
                 CALL cl_create_qry() RETURNING g_att[l_ac].att06_c            
                 DISPLAY BY NAME g_att[l_ac].att06_c                           
                 NEXT FIELD att06_c
              WHEN INFIELD(att07_c) 
                 SELECT agc01 INTO g_agc01
                   FROM agc_file
                  WHERE agc02 = g_agc[7].agc02                                  
                 CALL cl_init_qry_var()                                        
                 LET g_qryparam.form     = "q_agd"                            
                 LET g_qryparam.default1 = g_att[l_ac].att07_c 
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.arg1     = g_agc01                                 
                 CALL cl_create_qry() RETURNING g_att[l_ac].att07_c            
                 DISPLAY BY NAME g_att[l_ac].att07_c                           
                 NEXT FIELD att07_c
              WHEN INFIELD(att08_c) 
                 SELECT agc01 INTO g_agc01
                   FROM agc_file
                  WHERE agc02 = g_agc[8].agc02                                  
                 CALL cl_init_qry_var()                                        
                 LET g_qryparam.form     = "q_agd"                            
                 LET g_qryparam.default1 = g_att[l_ac].att08_c 
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.arg1     = g_agc01                                 
                 CALL cl_create_qry() RETURNING g_att[l_ac].att08_c            
                 DISPLAY BY NAME g_att[l_ac].att08_c                           
                 NEXT FIELD att08_c
              WHEN INFIELD(att09_c) 
                 SELECT agc01 INTO g_agc01
                   FROM agc_file
                  WHERE agc02 = g_agc[9].agc02                                  
                 CALL cl_init_qry_var()                                        
                 LET g_qryparam.form     = "q_agd"                            
                 LET g_qryparam.default1 = g_att[l_ac].att09_c 
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.arg1     = g_agc01                                 
                 CALL cl_create_qry() RETURNING g_att[l_ac].att09_c            
                 DISPLAY BY NAME g_att[l_ac].att09_c                           
                 NEXT FIELD att09_c
              WHEN INFIELD(att10_c) 
                 SELECT agc01 INTO g_agc01
                   FROM agc_file
                  WHERE agc02 = g_agc[10].agc02                                  
                 CALL cl_init_qry_var()                                        
                 LET g_qryparam.form     = "q_agd"                            
                 LET g_qryparam.default1 = g_att[l_ac].att10_c 
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.arg1     = g_agc01                                 
                 CALL cl_create_qry() RETURNING g_att[l_ac].att10_c            
                 DISPLAY BY NAME g_att[l_ac].att10_c                           
                 NEXT FIELD att10_c
           END CASE
        #No.FUN-640013  --end--
          
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
     ON ACTION about         
        CALL cl_about()      
 
     ON ACTION help          
        CALL cl_show_help()  
 
#No.FUN-6B0030------Begin--------------                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("grid01","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
        END INPUT
 
    #No.FUN-640013  --start--
    IF INT_FLAG THEN                                                     
       CALL cl_err('',9001,0)                                            
       LET INT_FLAG = 0                                                  
       CLOSE i311_bcl                                                    
       RETURN
    END IF 
 
    LET b = 0    #新增完后顯示到屏幕上的程序筆數
 
    #判斷哪些欄位可見
    LET a = 1
    FOR a = 1 TO 10
        IF a <= li_col_count THEN
           LET g_visible[a] = 'Y'
        ELSE
           LET g_visible[a] = 'N'
        END IF
    END FOR
 
    #將每個欄位的一個值或多個值解析插入到數組中
    LET g_ac0 = g_att.getLength()
    LET g_ac = 1
    FOR g_ac = 1 TO g_ac0
        IF g_visible[1] = 'Y' THEN          
           IF g_att[g_ac].att01 IS NOT NULL THEN
              CALL i311_make_condition1(g_att[g_ac].att01,g_agc[1].agc02,'CHAR','',1,g_ac) 
           END IF
           IF g_att[g_ac].att01_c IS NOT NULL THEN
              CALL i311_make_condition1(g_att[g_ac].att01_c,g_agc[1].agc02,'CHAR','',1,g_ac) 
           END IF
        END IF
        IF g_visible[2] = 'Y' THEN
           IF g_att[g_ac].att02 IS NOT NULL THEN
              CALL i311_make_condition1(g_att[g_ac].att02,g_agc[2].agc02,'CHAR','',2,g_ac) 
           END IF
           IF g_att[g_ac].att02_c IS NOT NULL THEN
              CALL i311_make_condition1(g_att[g_ac].att02_c,g_agc[2].agc02,'CHAR','',2,g_ac) 
           END IF
        END IF
        IF g_visible[3] = 'Y' THEN
           IF g_att[g_ac].att03 IS NOT NULL THEN
              CALL i311_make_condition1(g_att[g_ac].att03,g_agc[3].agc02,'CHAR','',3,g_ac) 
           END IF
           IF g_att[g_ac].att03_c IS NOT NULL THEN
              CALL i311_make_condition1(g_att[g_ac].att03_c,g_agc[3].agc02,'CHAR','',3,g_ac) 
           END IF
        END IF
        IF g_visible[4] = 'Y' THEN
           IF g_att[g_ac].att04 IS NOT NULL THEN
              CALL i311_make_condition1(g_att[g_ac].att04,g_agc[4].agc02,'CHAR','',4,g_ac) 
           END IF
           IF g_att[g_ac].att04_c IS NOT NULL THEN
              CALL i311_make_condition1(g_att[g_ac].att04_c,g_agc[4].agc02,'CHAR','',4,g_ac) 
           END IF
        END IF
        IF g_visible[5] = 'Y' THEN
           IF g_att[g_ac].att05 IS NOT NULL THEN
              CALL i311_make_condition1(g_att[g_ac].att05,g_agc[5].agc02,'CHAR','',5,g_ac) 
           END IF
           IF g_att[g_ac].att05_c IS NOT NULL THEN
              CALL i311_make_condition1(g_att[g_ac].att05_c,g_agc[5].agc02,'CHAR','',5,g_ac) 
           END IF
        END IF
        IF g_visible[6] = 'Y' THEN
           IF g_att[g_ac].att06 IS NOT NULL THEN
              CALL i311_make_condition1(g_att[g_ac].att06,g_agc[6].agc02,'CHAR','',6,g_ac) 
           END IF
           IF g_att[g_ac].att06_c IS NOT NULL THEN
              CALL i311_make_condition1(g_att[g_ac].att06_c,g_agc[6].agc02,'CHAR','',6,g_ac) 
           END IF
        END IF
        IF g_visible[7] = 'Y' THEN
           IF g_att[g_ac].att07 IS NOT NULL THEN
              CALL i311_make_condition1(g_att[g_ac].att07,g_agc[7].agc02,'CHAR','',7,g_ac) 
           END IF
           IF g_att[g_ac].att07_c IS NOT NULL THEN
              CALL i311_make_condition1(g_att[g_ac].att07_c,g_agc[7].agc02,'CHAR','',7,g_ac) 
           END IF
        END IF
        IF g_visible[8] = 'Y' THEN
           IF g_att[g_ac].att08 IS NOT NULL THEN
              CALL i311_make_condition1(g_att[g_ac].att08,g_agc[8].agc02,'CHAR','',8,g_ac) 
           END IF
           IF g_att[g_ac].att08_c IS NOT NULL THEN
              CALL i311_make_condition1(g_att[g_ac].att08_c,g_agc[8].agc02,'CHAR','',8,g_ac) 
           END IF
        END IF
        IF g_visible[9] = 'Y' THEN
           IF g_att[g_ac].att09 IS NOT NULL THEN
              CALL i311_make_condition1(g_att[g_ac].att09,g_agc[9].agc02,'CHAR','',9,g_ac) 
           END IF
           IF g_att[g_ac].att09_c IS NOT NULL THEN
              CALL i311_make_condition1(g_att[g_ac].att09_c,g_agc[9].agc02,'CHAR','',9,g_ac) 
           END IF
        END IF
        IF g_visible[10] = 'Y' THEN
           IF g_att[g_ac].att10 IS NOT NULL THEN
              CALL i311_make_condition1(g_att[g_ac].att10,g_agc[10].agc02,'CHAR','',10,g_ac) 
           END IF
           IF g_att[g_ac].att10_c IS NOT NULL THEN
              CALL i311_make_condition1(g_att[g_ac].att10_c,g_agc[10].agc02,'CHAR','',10,g_ac) 
           END IF
        END IF
    END FOR
   
    #計算產生的數據筆數
    LET l_count  = 0
    LET l_count1 = 0
    FOR g_ac = 1 TO g_ac0
        IF g_visible[1] = 'Y' THEN
           LET i00 = g_value1[g_ac].value2[1]
           LET l_count1 = i00
           IF g_visible[2] = 'Y' THEN
              LET i01 = g_value1[g_ac].value2[2]
              LET l_count1 = l_count1*i01
              IF g_visible[3] = 'Y' THEN
                 LET i02 = g_value1[g_ac].value2[3]
                 LET l_count1 = l_count1*i02
                 IF g_visible[4] = 'Y' THEN
                    LET i03 = g_value1[g_ac].value2[4]
                    LET l_count1 = l_count1*i03
                    IF g_visible[5] = 'Y' THEN
                       LET i04 = g_value1[g_ac].value2[5]
                       LET l_count1 = l_count1*i04
                       IF g_visible[6] = 'Y' THEN
                          LET i05 = g_value1[g_ac].value2[6]
                          LET l_count1 = l_count1*i05
                          IF g_visible[7] = 'Y' THEN
                             LET i06 = g_value1[g_ac].value2[7]
                             LET l_count1 = l_count1*i06
                             IF g_visible[8] = 'Y' THEN
                                LET i07 = g_value1[g_ac].value2[8]
                                LET l_count1 = l_count1*i07
                                IF g_visible[9] = 'Y' THEN
                                   LET i08 = g_value1[g_ac].value2[9]
                                   LET l_count1 = l_count1*i08
                                   IF g_visible[10] = 'Y' THEN
                                      LET i09 = g_value1[g_ac].value2[10]
                                      LET l_count1 = l_count1*i09
                                   END IF
                                END IF
                             END IF
                          END IF
                       END IF
                    END IF
                 END IF
              END IF
           END IF
        END IF
        LET l_count = l_count + l_count1
    END FOR
 
    #組確認的語句   
    CALL cl_getmsg('aim-137',g_lang) RETURNING g_msg2
    LET g_msg3 = l_count
    CALL cl_getmsg('aim-138',g_lang) RETURNING g_msg4
 
    LET g_msg1 = g_msg2 CLIPPED,g_msg3 CLIPPED,g_msg4 CLIPPED
 
    #確認是否執行操作    
    IF NOT cl_confirm(g_msg1) THEN
       LET g_b = 1  #No.TQC-640118
       RETURN
    END IF
 
    #顯示進度條
    IF l_count > 0 THEN
       CALL cl_progress_bar(l_count)
    END IF
 
    #產生多屬性子料件
    FOR g_ac = 1 TO g_ac0
        IF g_visible[1] = 'Y' THEN
           LET i00 = g_value1[g_ac].value2[1]
           LET i0 = 1
           FOR i0 = 1 TO i00
               LET ls_value1 = ps_value
               LET ls_spec1 = ps_spec
               IF g_rows[g_ac].lists[i0].fields[1] IS NOT NULL THEN
                  LET g_sub_ima940 = g_rows[g_ac].lists[i0].fields[1]     #No.FUN-A50011
                  LET ls_value1 = ls_value1 CLIPPED,l_sp,g_rows[g_ac].lists[i0].fields[1]
                  LET ls_spec1  = ls_spec1  CLIPPED,l_sp,g_rows1[g_ac].lists1[i0].fields1[1]
                  IF g_visible[2] = 'N' THEN
                     CALL i311_insert(ls_value1,ls_spec1,g_ac,i0)
                  END IF
               END IF
               IF g_visible[2] = 'Y' THEN
                  LET i01 = g_value1[g_ac].value2[2]
                  LET i1 = 1
                  FOR i1 = 1 TO i01
                      LET ls_value2 = ls_value1
                      LET ls_spec2 = ls_spec1
                      IF g_rows[g_ac].lists[i1].fields[2] IS NOT NULL THEN
                         LET g_sub_ima941 = g_rows[g_ac].lists[i1].fields[2]    #No.FUN-A50011
                         LET ls_value2 = ls_value2 CLIPPED,l_sp,g_rows[g_ac].lists[i1].fields[2]
                         LET ls_spec2  = ls_spec2  CLIPPED,l_sp,g_rows1[g_ac].lists1[i1].fields1[2]
                         IF g_visible[3] = 'N' THEN
                            CALL i311_insert(ls_value2,ls_spec2,g_ac,i1)
                         END IF
                      END IF
                      IF g_visible[3] = 'Y' THEN
                         LET i02 = g_value1[g_ac].value2[3]
                         LET i2 = 1
                         FOR i2 = 1 TO i02
                             LET ls_value3 = ls_value2
                             LET ls_spec3 = ls_spec2
                             IF g_rows[g_ac].lists[i2].fields[3] IS NOT NULL THEN
                                LET ls_value3 = ls_value3 CLIPPED,l_sp,g_rows[g_ac].lists[i2].fields[3]
                                LET ls_spec3  = ls_spec3  CLIPPED,l_sp,g_rows1[g_ac].lists1[i2].fields1[3]
                                IF g_visible[4] = 'N' THEN
                                   CALL i311_insert(ls_value3,ls_spec3,g_ac,i2)
                                END IF
                             END IF
                             IF g_visible[4] = 'Y' THEN
                                LET i03 = g_value1[g_ac].value2[4]
                                LET i3 = 1
                                FOR i3 = 1 TO i03
                                    LET ls_value4 = ls_value3
                                    LET ls_spec4 = ls_spec3
                                    IF g_rows[g_ac].lists[i3].fields[4] IS NOT NULL THEN
                                       LET ls_value4 = ls_value4 CLIPPED,l_sp,g_rows[g_ac].lists[i3].fields[4]
                                       LET ls_spec4  = ls_spec4  CLIPPED,l_sp,g_rows1[g_ac].lists1[i3].fields1[4]
                                       IF g_visible[5] = 'N' THEN
                                          CALL i311_insert(ls_value4,ls_spec4,g_ac,i3)
                                       END IF
                                    END IF
                                    IF g_visible[5] = 'Y' THEN
                                       LET i04 = g_value1[g_ac].value2[5]
                                       LET i4 = 1
                                       FOR i4 = 1 TO i04
                                           LET ls_value5 = ls_value4
                                           LET ls_spec5 = ls_spec4
                                           IF g_rows[g_ac].lists[i4].fields[5] IS NOT NULL THEN
                                              LET ls_value5 = ls_value5 CLIPPED,l_sp,g_rows[g_ac].lists[i4].fields[5]
                                              LET ls_spec5  = ls_spec5  CLIPPED,l_sp,g_rows1[g_ac].lists1[i4].fields1[5]
                                              IF g_visible[6] = 'N' THEN
                                                 CALL i311_insert(ls_value5,ls_spec5,g_ac,i4)
                                              END IF
                                           END IF                         
                                           IF g_visible[6] = 'Y' THEN
                                              LET i05 = g_value1[g_ac].value2[6]
                                              LET i5 = 1
                                              FOR i5 = 1 TO i05
                                                  LET ls_value6 = ls_value5
                                                  LET ls_spec6 = ls_spec5
                                                  IF g_rows[g_ac].lists[i5].fields[6] IS NOT NULL THEN
                                                     LET ls_value6 = ls_value6 CLIPPED,l_sp,g_rows[g_ac].lists[i5].fields[6]
                                                     LET ls_spec6  = ls_spec6  CLIPPED,l_sp,g_rows1[g_ac].lists1[i5].fields1[6]
                                                     IF g_visible[7] = 'N' THEN
                                                        CALL i311_insert(ls_value6,ls_spec6,g_ac,i5)
                                                     END IF
                                                  END IF
                                                  IF g_visible[7] = 'Y' THEN
                                                     LET i06 = g_value1[g_ac].value2[7]
                                                     LET i6 = 1
                                                     FOR i6 = 1 TO i06
                                                         LET ls_value7 = ls_value6
                                                         LET ls_spec7 = ls_spec6
                                                         IF g_rows[g_ac].lists[i6].fields[7] IS NOT NULL THEN
                                                            LET ls_value7 = ls_value7 CLIPPED,l_sp,g_rows[g_ac].lists[i6].fields[7]
                                                            LET ls_spec7  = ls_spec7  CLIPPED,l_sp,g_rows1[g_ac].lists1[i6].fields1[7]
                                                            IF g_visible[8] = 'N' THEN
                                                               CALL i311_insert(ls_value7,ls_spec7,g_ac,i6)
                                                            END IF
                                                         END IF                         
                                                         IF g_visible[8] = 'Y' THEN
                                                            LET i07 = g_value1[g_ac].value2[8]
                                                            LET i7 = 1
                                                            FOR i7 = 1 TO i07
                                                                LET ls_value8 = ls_value7
                                                                LET ls_spec8 = ls_spec7
                                                                IF g_rows[g_ac].lists[i7].fields[8] IS NOT NULL THEN
                                                                   LET ls_value8 = ls_value8 CLIPPED,l_sp,g_rows[g_ac].lists[i7].fields[8]
                                                                   LET ls_spec8  = ls_spec8  CLIPPED,l_sp,g_rows1[g_ac].lists1[i7].fields1[8]
                                                                   IF g_visible[9] = 'N' THEN
                                                                      CALL i311_insert(ls_value8,ls_spec8,g_ac,i7)
                                                                   END IF
                                                                END IF
                                                                IF g_visible[9] = 'Y' THEN
                                                                   LET i08 = g_value1[g_ac].value2[9]
                                                                   LET i8 = 1
                                                                   FOR i8 = 1 TO i08
                                                                       LET ls_value9 = ls_value8
                                                                       LET ls_spec9 = ls_spec8 
                                                                       IF g_rows[g_ac].lists[i8].fields[9] IS NOT NULL THEN
                                                                          LET ls_value9 = ls_value9 CLIPPED,l_sp,g_rows[g_ac].lists[i8].fields[9]
                                                                          LET ls_spec9  = ls_spec9  CLIPPED,l_sp,g_rows1[g_ac].lists1[i8].fields1[9]
                                                                          IF g_visible[10] = 'N' THEN
                                                                             CALL i311_insert(ls_value9,ls_spec9,g_ac,i8)
                                                                          END IF
                                                                       END IF                         
                                                                       IF g_visible[10] = 'Y' THEN
                                                                          LET i09 = g_value1[g_ac].value2[10]
                                                                          LET i9 = 1
                                                                          FOR i9 = 1 TO i09
                                                                              LET ls_value10 = ls_value9
                                                                              LET ls_spec10 = ls_spec9
                                                                              IF g_rows[g_ac].lists[i9].fields[10] IS NOT NULL THEN
                                                                                 LET ls_value10 = ls_value10 CLIPPED,l_sp,g_rows[g_ac].lists[i9].fields[10]
                                                                                 LET ls_spec10  = ls_spec10  CLIPPED,l_sp,g_rows1[g_ac].lists1[i9].fields1[10]
                                                                                 CALL i311_insert(ls_value10,ls_spec10,g_ac,i9)
                                                                              END IF
                                                                          END FOR
                                                                       END IF   
                                                                   END FOR
                                                                END IF   
                                                            END FOR
                                                         END IF   
                                                     END FOR
                                                  END IF   
                                              END FOR
                                           END IF   
                                       END FOR
                                    END IF           
                                END FOR
                             END IF               
                         END FOR
                      END IF                   
                  END FOR
               END IF   
           END FOR
        END IF                                                                                                   
    END FOR
 
    #No.FUN-640013  --end--
 
    CLOSE i311_bcl
    COMMIT WORK
 
    LET g_b = 0  #No.TQC-640118
 
    #No.FUN-640013  --start--
    IF b > 100 THEN
       CALL cl_err_msg("","aim-139",b CLIPPED,0)
       DISPLAY '100' TO FORMONLY.cn2
       LET g_att.* = l_att.*
       LET g_rec_b = 100
    ELSE
       CALL cl_err_msg("","aim-140",b CLIPPED|| "|" || b CLIPPED,0)
       DISPLAY b TO FORMONLY.cn2
       LET g_att.* = l_att.*
       LET g_rec_b = b
    END IF
    #No.FUN-640013  --end--
    
END FUNCTION
 
FUNCTION i311_b_fill(p_wc)             #BODY FILL UP
 DEFINE p_wc    LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)
 
    LET g_sql= "SELECT imx01,imx01,imx02,imx02,imx03,imx03,",
               "       imx04,imx04,imx05,imx05,imx06,imx06,",
               "       imx07,imx07,imx08,imx08,imx09,imx09,",
#              "       imx10,imx10,imx000,ima02",          #No.FUN-640013
               "       imx10,imx10,imx000,ima02,imx00", #No.FUN-640013
               "  FROM imx_file,ima_file",
               " WHERE imx000=ima01 AND ",p_wc CLIPPED,
               " ORDER BY imx000"
    PREPARE i311_prepare FROM g_sql    #預備一下
    DECLARE i311_cs CURSOR FOR i311_prepare
 
    CALL g_att.clear()
    LET g_cnt = 1
    FOREACH i311_cs INTO g_att[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt= g_cnt + 1 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_att.deleteElement(g_cnt)
    IF SQLCA.sqlcode THEN
       CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
    END IF
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO cn2  
    LET g_cnt = 0
 
END FUNCTION
 
#No.FUN-640013  --start--
#FUNCTION check_subno()
#DEFINE l_value LIKE ima_file.ima01,
#       l_spec  LIKE ima_file.ima02,
#       l_cnt   LIKE type_file.num5    #No.FUN-690026 SMALLINT
#
#    LET l_value = ps_value
#    LET l_spec = ps_spec
#    FOR li_i = 1 TO li_col_count
#        IF cl_null(g_value[li_i]) THEN
#           RETURN 0,l_value
#        ELSE
#           LET l_value = l_value CLIPPED,l_sp,g_value[li_i]
#        END IF
#    END FOR
#    SELECT COUNT(*) INTO l_cnt FROM ima_file WHERE ima01 = l_value 
#    RETURN l_cnt,l_value
#END FUNCTION
#No.FUN-640013  --end--
 
FUNCTION i311_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_att TO s_att.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
#No.FUN-6B0030------Begin--------------                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("grid01","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
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
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
 
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
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
     ON ACTION about         
        CALL cl_about()      
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.FUN-640013  --start--
#將每個欄位的一個值或多個值解析出來
FUNCTION i311_make_condition(pvalue,pfield,ptype,ptable,p_j,p_ac)
  DEFINE pvalue,pfield,ptype      STRING,                                       
         ptable,lc_table          STRING,                                       
         li_pos,l_pos,p_j,p_ac    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
         l_i,l_j                  LIKE type_file.num5,    #No.FUN-690026 SMALLINT
         l_m                      LIKE agd_file.agd02,    #FUN-660078
         l_m1                     LIKE agd_file.agd02,    #No.FUN-690026  VARCHAR(20)
         ls_like                  base.stringBuffer,                            
         ls_left,ls_right,ls_temp LIKE agd_file.agd02,    #No.FUN-690026 VARCHAR(40)
         p_value_tmp              STRING,
         l_sql                    LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
  DEFINE tok                      base.StringTokenizer,
         li_min_num               LIKE agc_file.agc05, 
         li_max_num               LIKE agc_file.agc06
 
  LET li_min_num = g_agc[p_j].agc05                        
  LET li_max_num = g_agc[p_j].agc06
 
  LET ls_like = base.stringBuffer.Create()                                                                                          
  
  IF li_pos = 0 THEN  #No.TQC-640118                                                                                                                                  
  #判斷條件中是否包含'*'字符（將把*解析為模糊匹配）                                                                                 
     LET li_pos = pvalue.getIndexOf('*',1)                                                                                             
     IF li_pos > 0 THEN                                                                                                                
        LET l_pos = li_pos
        SELECT agc04 INTO lc_agc04 FROM agc_file                      
         WHERE agc01 = g_agc[p_j].agc01                              
        IF lc_agc04 = '2' THEN         
        #如果包含'*'則理解為LIKE關系，且此時數據類型只能為CHAR                                                                         
           CALL ls_like.append(pvalue)                                                                                                    
           CALL ls_like.replace('*','%',0)  #將所有*替換成%
           LET l_m1 = ls_like.toString()
           LET l_sql = "SELECT agd02 FROM agd_file ",
                       " WHERE agd01 = '",g_agc[p_j].agc01,"'",
                       "   AND agd02 LIKE '",l_m1,"'"
           PREPARE i311_p01 FROM l_sql
           DECLARE agd_c1 CURSOR FOR i311_p01
           FOREACH agd_c1 INTO l_m
              IF SQLCA.sqlcode THEN                                                                                                        
                 CALL cl_err('FOREACH:',SQLCA.sqlcode,1)                                                                                   
                 LET g_success = 'N'
                 EXIT FOREACH                                                                                                              
              END IF 
           END FOREACH
           IF l_m IS NULL THEN
              CALL cl_err('','mfg9089',1)                                           
              LET g_success = 'N'                                                   
              RETURN
           END IF                
        ELSE
           IF li_min_num IS NULL OR li_max_num IS NULL OR li_pos <> 1 OR Length(pvalue) <>1 THEN
              CALL cl_err('','mfg9089',1)                                           
              LET g_success = 'N'                                                   
              RETURN
           END IF
        END IF                
     END IF
  END IF  #No.TQC-640118
 
  IF li_pos = 0 THEN  #No.TQC-640118                                                                                                                                  
  #判斷條件中是否包含'?'字符（將被替換為單個位上的模糊匹配）
     LET li_pos = pvalue.getIndexOf('?',1)                                                                                             
     IF li_pos > 0 THEN                                                                                                                
        LET l_pos = li_pos
        #如果包含'?'則理解為LIKE關系，且此時數據類型只能為CHAR                                                                         
        CALL ls_like.append(pvalue)                                                                                                    
        CALL ls_like.replace('?','_',0)  #將所有?替換成_
        LET l_m1 = ls_like.toString()
        SELECT agc04 INTO lc_agc04 FROM agc_file                      
         WHERE agc01 = g_agc[p_j].agc01                              
        IF lc_agc04 = '2' THEN         
           LET l_sql = "SELECT agd02 FROM agd_file ",
                       " WHERE agd01 = '",g_agc[p_j].agc01,"'",
                       "   AND agd02 LIKE '",l_m1,"'"
           PREPARE i311_p02 FROM l_sql
           DECLARE agd_c2 CURSOR FOR i311_p02
           FOREACH agd_c2 INTO l_m
              IF SQLCA.sqlcode THEN                                                                                                        
                 CALL cl_err('FOREACH:',SQLCA.sqlcode,1)                                                                                   
                 LET g_success = 'N'
                 EXIT FOREACH                                                                                                              
              END IF 
           END FOREACH
           IF l_m IS NULL THEN
              CALL cl_err('','mfg9089',1)                                           
              LET g_success = 'N'                                                   
              RETURN
           END IF                
        ELSE
           CALL cl_err('','mfg9089',1)                                           
           LET g_success = 'N'                                                   
           RETURN
        END IF                
     END IF
  END IF  #No.TQC-640118
 
  IF li_pos = 0 THEN  #No.TQC-640118                                                                                                                                  
  #判斷條件是否為'>='形式                                                                                                           
     LET li_pos = pvalue.getIndexOf('>=',1)                                                                                            
     IF li_pos = 1 THEN   
        LET l_pos = li_pos                                                                                                             
        #得到要比較的內容                                                                                                              
        LET ls_right = pvalue.subString(3,pvalue.getLength())
        SELECT agc04 INTO lc_agc04 FROM agc_file                      
         WHERE agc01 = g_agc[p_j].agc01                              
        IF lc_agc04 = '2' THEN
           CALL cl_err('','mfg9089',1)                                           
           LET g_success = 'N'                                                   
           RETURN
        ELSE    
           LET l_i = Length(ls_right)                                                      
           IF l_i <> g_agc[p_j].agc03 THEN
              CALL cl_err_msg("","aim-911",g_agc[p_j].agc03,1)
              LET g_success = 'N'                                                   
              RETURN
           END IF
           CALL i311_cmp(li_min_num,ls_right,l_i,p_j)
           IF g_success = 'N' THEN 
              RETURN
           END IF                        
           CALL i311_cmp(ls_right,li_max_num,l_i,p_j)
           IF g_success = 'N' THEN 
              RETURN
           END IF                        
        END IF 
     END IF
  END IF  #No.TQC-640118
 
  IF li_pos = 0 THEN  #No.TQC-640118                                                                                                                                  
  #判斷條件是否為'<='形式                                                                                                           
     LET li_pos = pvalue.getIndexOf('<=',1)                                                                                            
     IF li_pos = 1 THEN 
        LET l_pos = li_pos                                                                                                               
        #得到要比較的內容                                                                                                              
        LET ls_right = pvalue.subString(3,pvalue.getLength()) 
        SELECT agc04 INTO lc_agc04 FROM agc_file                      
         WHERE agc01 = g_agc[p_j].agc01                              
        IF lc_agc04 = '2' THEN
           CALL cl_err('','mfg9089',1)                                           
           LET g_success = 'N'                                                   
           RETURN
        ELSE    
           LET l_i = Length(ls_right)                                                      
           IF l_i <> g_agc[p_j].agc03 THEN
              CALL cl_err_msg("","aim-911",g_agc[p_j].agc03,1)
              LET g_success = 'N'                                                   
              RETURN
           END IF
           CALL i311_cmp(li_min_num,ls_right,l_i,p_j)
           IF g_success = 'N' THEN 
              RETURN
           END IF                        
           CALL i311_cmp(ls_right,li_max_num,l_i,p_j)
           IF g_success = 'N' THEN 
              RETURN
           END IF                        
        END IF 
     END IF
  END IF  #No.TQC-640118
 
  IF li_pos = 0 THEN  #No.TQC-640118                                                                                                                                  
  #判斷條件是否為'>'形式                                                                                                            
     LET li_pos = pvalue.getIndexOf('>',1)                                                                                             
     IF li_pos = 1 THEN 
        LET l_pos = li_pos                                                                                                               
        #得到要比較的內容                                                                                                              
        LET ls_right = pvalue.subString(2,pvalue.getLength())
        SELECT agc04 INTO lc_agc04 FROM agc_file                      
         WHERE agc01 = g_agc[p_j].agc01                              
        IF lc_agc04 = '2' THEN
           CALL cl_err('','mfg9089',1)                                           
           LET g_success = 'N'                                                   
           RETURN
        ELSE    
           LET l_i = Length(ls_right)                                                      
           IF l_i <> g_agc[p_j].agc03 THEN
              CALL cl_err_msg("","aim-911",g_agc[p_j].agc03,1)
              LET g_success = 'N'                                                   
              RETURN
           END IF
           #No.TQC-640118  --start--
           IF ls_right = li_max_num THEN
              CALL cl_err_msg("","lib-232",g_agc[p_j].agc05 CLIPPED|| "|" || g_agc[p_j].agc06 CLIPPED,1)
              LET g_success = 'N'
              RETURN
           END IF
           #No.TQC-640118  --end--
           CALL i311_cmp(li_min_num,ls_right,l_i,p_j)
           IF g_success = 'N' THEN 
              RETURN
           END IF                        
           CALL i311_cmp(ls_right,li_max_num,l_i,p_j)
           IF g_success = 'N' THEN 
              RETURN
           END IF                        
        END IF 
     END IF
  END IF  #No.TQC-640118
 
  IF li_pos = 0 THEN  #No.TQC-640118                                                                                                                                  
  #判斷條件是否為'<'形式                                                                                                            
     LET li_pos = pvalue.getIndexOf('<',1)                                                                                             
     IF li_pos = 1 THEN                                      
        LET l_pos = li_pos                                                                          
        #得到要比較的內容                                                                                                              
        LET ls_right = pvalue.subString(2,pvalue.getLength())
        SELECT agc04 INTO lc_agc04 FROM agc_file                      
         WHERE agc01 = g_agc[p_j].agc01                              
        IF lc_agc04 = '2' THEN
           CALL cl_err('','mfg9089',1)                                           
           LET g_success = 'N'                                                   
           RETURN
        ELSE    
           LET l_i = Length(ls_right)                                                      
           IF l_i <> g_agc[p_j].agc03 THEN
              CALL cl_err_msg("","aim-911",g_agc[p_j].agc03,1)
              LET g_success = 'N'                                                   
              RETURN
           END IF
           #No.TQC-640118  --start--
           IF ls_right = li_min_num THEN
              CALL cl_err_msg("","lib-232",g_agc[p_j].agc05 CLIPPED|| "|" || g_agc[p_j].agc06 CLIPPED,1)
              LET g_success = 'N'
              RETURN
           END IF
           #No.TQC-640118  --end--
           CALL i311_cmp(li_min_num,ls_right,l_i,p_j)
           IF g_success = 'N' THEN 
              RETURN
           END IF                        
           CALL i311_cmp(ls_right,li_max_num,l_i,p_j)
           IF g_success = 'N' THEN 
              RETURN
           END IF                        
        END IF 
     END IF
  END IF  #No.TQC-640118
 
  IF li_pos = 0 THEN  #No.TQC-640118                                                                                                                                  
  #判斷條件是否為'|'形式
     LET li_pos = pvalue.getIndexOf('|',1)                                         
     IF li_pos > 0 THEN
        LET l_pos = li_pos
        LET tok = base.StringTokenizer.create(pvalue,"|")
        WHILE tok.hasMoreTokens()
          LET l_m = tok.nextToken()
          SELECT agc04 INTO lc_agc04 FROM agc_file                      
           WHERE agc01 = g_agc[p_j].agc01                              
          IF lc_agc04 = '2' THEN         
             LET lc_agd03 = NULL                               
             SELECT agd03 INTO lc_agd03 FROM agd_file                   
              WHERE agd01 = g_agc[p_j].agc01                           
                AND agd02 = l_m
             IF lc_agd03 IS NULL THEN
                CALL cl_err('','mfg9089',1)                                           
                LET g_success = 'N'                                                   
                RETURN
             END IF                
          ELSE        
             LET l_i = Length(l_m)                                                  
             IF l_i <> g_agc[p_j].agc03 THEN
                CALL cl_err_msg("","aim-911",g_agc[p_j].agc03,1)
                LET g_success = 'N'                                                   
                RETURN
             END IF
             IF li_min_num IS NOT NULL THEN
                CALL i311_cmp(li_min_num,l_m,l_i,p_j)
                IF g_success = 'N' THEN 
                   RETURN
                END IF                       
             END IF
             IF li_max_num IS NOT NULL THEN 
                CALL i311_cmp(l_m,li_max_num,l_i,p_j)
                IF g_success = 'N' THEN 
                   RETURN
                END IF                        
             END IF
          END IF 
        END WHILE
     END IF
  END IF  #No.TQC-640118
 
  IF li_pos = 0 THEN  #No.TQC-640118                                                                                                                                  
  #判斷條件是否為'n:m'形式
     LET li_pos = pvalue.getIndexOf(':',1)
     IF li_pos > 0 THEN
        LET l_pos = li_pos
        LET ls_left = pvalue.subString(1,li_pos-1)
        LET ls_right = pvalue.subString(li_pos+1,pvalue.getLength())
        IF ls_left IS NULL OR ls_right IS NULL THEN 
           IF li_min_num IS NULL OR li_max_num IS NULL THEN  #No.TQC-640118
              CALL cl_err('','mfg9089',1)  #No.TQC-640118
           ELSE     #No.TQC-640118                                                                      
              CALL cl_err_msg("","lib-232",g_agc[p_j].agc05 CLIPPED|| "|" || g_agc[p_j].agc06 CLIPPED,1)
           END IF   #No.TQC-640118
           LET g_success = 'N'                                                   
           RETURN
        END IF
        SELECT agc04 INTO lc_agc04 FROM agc_file                      
         WHERE agc01 = g_agc[p_j].agc01                              
        IF lc_agc04 = '2' THEN    
           #No.TQC-640118  --start--                                                                                                     
           LET l_m = NULL                                   
           SELECT agd02 INTO l_m
             FROM agd_file
            WHERE agd01 = g_agc[p_j].agc01
              AND agd02 = ls_left
           IF l_m IS NULL THEN
              CALL cl_err('','mfg9089',1)                                           
              LET g_success = 'N'                                                   
              RETURN
           END IF                
           LET l_m = NULL                                   
           SELECT agd02 INTO l_m
             FROM agd_file
            WHERE agd01 = g_agc[p_j].agc01
              AND agd02 = ls_right
           IF l_m IS NULL THEN
              CALL cl_err('','mfg9089',1)                                           
              LET g_success = 'N'                                                   
              RETURN
           END IF  
           LET l_m = NULL    
           #No.TQC-640118  --end--              
           LET l_sql = "SELECT agd02 FROM agd_file ",                                                                                  
                       " WHERE agd01 = '",g_agc[p_j].agc01,"'",                                                                        
                       "   AND agd02 BETWEEN '",ls_left,"' AND '",ls_right,"'"                                                                                  
           PREPARE i311_p05 FROM l_sql                                                                                                 
           DECLARE agd_c5 CURSOR FOR i311_p05                                                                                          
           FOREACH agd_c5 INTO l_m                                                                                                     
              IF SQLCA.sqlcode THEN                                                                                                    
                 CALL cl_err('FOREACH:',SQLCA.sqlcode,1)                                                                               
                 LET g_success = 'N'                                                                                                   
                 EXIT FOREACH                                                                                                          
              END IF                                                                                                                   
           END FOREACH
           IF l_m IS NULL THEN
              CALL cl_err('','mfg9089',1)                                           
              LET g_success = 'N'                                                   
              RETURN
           END IF               
        ELSE    
           LET l_i = Length(ls_left)                                                      
           LET l_j = Length(ls_right)                                                      
           IF l_i <> g_agc[p_j].agc03 OR l_j <> g_agc[p_j].agc03 THEN
              CALL cl_err_msg("","aim-911",g_agc[p_j].agc03,1)
              LET g_success = 'N'                                                   
              RETURN
           END IF
           IF li_min_num IS NOT NULL THEN
              CALL i311_cmp(li_min_num,ls_left,l_i,p_j)
              IF g_success = 'N' THEN 
                 RETURN
              END IF                        
           END IF
           IF li_max_num IS NOT NULL THEN
              CALL i311_cmp(ls_right,li_max_num,l_i,p_j)
              IF g_success = 'N' THEN 
                 RETURN
              END IF                        
           END IF
           CALL i311_cmp(ls_left,ls_right,l_i,p_j)
           IF g_success = 'N' THEN 
              RETURN
           END IF                       
        END IF 
     END IF
  END IF  #No.TQC-640118
 
  IF l_pos = 0 THEN
     LET l_m = pvalue
     SELECT agc04 INTO lc_agc04 FROM agc_file                      
      WHERE agc01 = g_agc[p_j].agc01                              
     IF lc_agc04 = '2' THEN     
        LET lc_agd03 = NULL                                   
        SELECT agd03 INTO lc_agd03 FROM agd_file                   
         WHERE agd01 = g_agc[p_j].agc01                           
           AND agd02 = l_m
        IF lc_agd03 IS NULL THEN
           CALL cl_err('','mfg9089',1)                                           
           LET g_success = 'N'                                                   
           RETURN
        END IF                
     ELSE         
        LET l_i = Length(l_m)                                                 
        IF l_i <> g_agc[p_j].agc03 THEN
           CALL cl_err_msg("","aim-911",g_agc[p_j].agc03,1)
           LET g_success = 'N'                                                   
           RETURN
        END IF
        IF li_min_num IS NOT NULL THEN
           CALL i311_cmp(li_min_num,l_m,l_i,p_j)
           IF g_success = 'N' THEN 
              RETURN
           END IF                        
        END IF
        IF li_max_num IS NOT NULL THEN
           CALL i311_cmp(l_m,li_max_num,l_i,p_j)
           IF g_success = 'N' THEN 
              RETURN
           END IF                        
        END IF
     END IF 
  END IF     
 
END FUNCTION
 
#將解析出來的值插入到數組中
FUNCTION i311_make_condition1(pvalue,pfield,ptype,ptable,p_j,p_ac)
  DEFINE pvalue,pfield,ptype       STRING,                                       
         ptable,lc_table           STRING,                                       
         li_pos,l_pos,p_j,p_ac,l_i LIKE type_file.num5,   #No.FUN-690026 SMALLINT
         l_m                       LIKE agd_file.agd02,   #FUN-660078
         l_m1                      LIKE agd_file.agd02,   #No.FUN-690026 VARCHAR(20)
         ls_like                   base.stringBuffer,                            
         ls_left,ls_right,ls_temp  LIKE agd_file.agd02,   #No.FUN-690026 VARCHAR(40)
         p_value_tmp               STRING,
         l_sql                     LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)
  DEFINE tok             base.StringTokenizer,
         li_min_num      LIKE agc_file.agc05, 
         li_max_num      LIKE agc_file.agc06
 
  LET li_min_num = g_agc[p_j].agc05                        
  LET li_max_num = g_agc[p_j].agc06
 
  LET ls_like = base.stringBuffer.Create()                                                                                          
 
  IF li_pos = 0 THEN  #No.TQC-640118                                                                                                                                    
  #判斷條件中是否包含'*'字符（將把*解析為模糊匹配）                                                                                 
     LET li_pos = pvalue.getIndexOf('*',1)                                                                                             
     IF li_pos > 0 THEN                                                                                                                
        LET l_pos = li_pos
        LET i = 0
        SELECT agc04 INTO lc_agc04 FROM agc_file                      
         WHERE agc01 = g_agc[p_j].agc01                              
        IF lc_agc04 = '2' THEN         
        #如果包含'*'則理解為LIKE關系，且此時數據類型只能為CHAR                                                                         
           CALL ls_like.append(pvalue)                                                                                                    
           CALL ls_like.replace('*','%',0)  #將所有*替換成%
           LET l_m1 = ls_like.toString()         
           LET l_sql = "SELECT agd02 FROM agd_file ",
                       " WHERE agd01 = '",g_agc[p_j].agc01,"'",
                       "   AND agd02 LIKE '",l_m1,"'"
           PREPARE i311_p03 FROM l_sql
           DECLARE agd_c3 CURSOR FOR i311_p03
           FOREACH agd_c3 INTO l_m
              LET i = i+1
              LET g_rows[p_ac].lists[i].fields[p_j] = l_m
              LET lc_agd03 = NULL                                                                                                       
              SELECT agd03 INTO lc_agd03 FROM agd_file                                                                                  
               WHERE agd01 = g_agc[p_j].agc01                                                                                           
                 AND agd02 = l_m                                                                                                        
              LET g_rows1[p_ac].lists1[i].fields1[p_j] = lc_agd03
              LET g_value1[p_ac].value2[p_j] = i
           END FOREACH              
        ELSE
           LET i = 1
           LET ls_left = li_min_num
           LET ls_right = li_max_num
           LET l_i = Length(ls_right)
           LET g_str = ls_left
           LET g_rows[p_ac].lists[i].fields[p_j] = g_str
           LET g_rows1[p_ac].lists1[i].fields1[p_j] = g_rows[p_ac].lists[i].fields[p_j]
           WHILE TRUE
              LET i = i+1
              CALL i311_add(g_str,l_i)
              LET g_rows[p_ac].lists[i].fields[p_j] = g_str
              LET g_rows1[p_ac].lists1[i].fields1[p_j] = g_rows[p_ac].lists[i].fields[p_j]        
              LET g_value1[p_ac].value2[p_j] = i
              IF g_str = ls_right THEN
                 EXIT WHILE
              END IF
           END WHILE      
        END IF     
     END IF
  END IF  #No.TQC-640118
 
  IF li_pos = 0 THEN  #No.TQC-640118                                                                                                                                    
  #判斷條件中是否包含'?'字符（將被替換為單個位上的模糊匹配）
     LET li_pos = pvalue.getIndexOf('?',1)                                                                                             
     IF li_pos > 0 THEN                                                                                                                
        LET l_pos = li_pos
        LET i = 0
        #如果包含'?'則理解為LIKE關系，且此時數據類型只能為CHAR                                                                         
        CALL ls_like.append(pvalue)                                                                                                    
        CALL ls_like.replace('?','_',0)  #將所有?替換成_
        LET l_m1 = ls_like.toString()      
        LET l_sql = "SELECT agd02 FROM agd_file ",
                    " WHERE agd01 = '",g_agc[p_j].agc01,"'",
                    "   AND agd02 LIKE '",l_m1,"'"
        PREPARE i311_p04 FROM l_sql
        DECLARE agd_c4 CURSOR FOR i311_p04
        FOREACH agd_c4 INTO l_m
           LET i = i+1
           LET g_rows[p_ac].lists[i].fields[p_j] = l_m
           LET lc_agd03 = NULL                                                                                                       
           SELECT agd03 INTO lc_agd03 FROM agd_file                                                                                  
            WHERE agd01 = g_agc[p_j].agc01                                                                                           
              AND agd02 = l_m                                                                                                        
           LET g_rows1[p_ac].lists1[i].fields1[p_j] = lc_agd03
           LET g_value1[p_ac].value2[p_j] = i
        END FOREACH                
     END IF
  END IF  #No.TQC-640118
 
  IF li_pos = 0 THEN  #No.TQC-640118                                                                                                                                    
  #判斷條件是否為'>='形式                                                                                                           
     LET li_pos = pvalue.getIndexOf('>=',1)                                                                                            
     IF li_pos = 1 THEN   
        LET l_pos = li_pos    
        LET i = 1                                                                                                         
        #得到要比較的內容                                                                                                              
        LET ls_right = pvalue.subString(3,pvalue.getLength())
        LET l_i = Length(ls_right)
        LET g_str = ls_right
        LET g_rows[p_ac].lists[i].fields[p_j] = g_str
        LET g_rows1[p_ac].lists1[i].fields1[p_j] = g_rows[p_ac].lists[i].fields[p_j]
        LET g_value1[p_ac].value2[p_j] = i
        IF ls_right <> li_max_num THEN    #No.TQC-640118
           WHILE TRUE
              LET i = i+1
              CALL i311_add(g_str,l_i)
              LET g_rows[p_ac].lists[i].fields[p_j] = g_str
              LET g_rows1[p_ac].lists1[i].fields1[p_j] = g_rows[p_ac].lists[i].fields[p_j]        
              LET g_value1[p_ac].value2[p_j] = i
              IF g_str = li_max_num THEN
                 EXIT WHILE
              END IF
           END WHILE      
        END IF  #No.TQC-640118
     END IF
  END IF  #No.TQC-640118
 
  IF li_pos = 0 THEN  #No.TQC-640118                                                                                                                                    
  #判斷條件是否為'<='形式                                                                                                           
     LET li_pos = pvalue.getIndexOf('<=',1)                                                                                            
     IF li_pos = 1 THEN 
        LET l_pos = li_pos  
        LET i = 1                                                                                                             
        #得到要比較的內容                                                                                                              
        LET ls_right = pvalue.subString(3,pvalue.getLength()) 
        LET l_i = Length(ls_right)
        LET g_str = li_min_num
        LET g_rows[p_ac].lists[i].fields[p_j] = g_str
        LET g_rows1[p_ac].lists1[i].fields1[p_j] = g_rows[p_ac].lists[i].fields[p_j]
        LET g_value1[p_ac].value2[p_j] = i
        IF ls_right <> li_min_num THEN    #No.TQC-640118
           WHILE TRUE
              LET i = i+1
              CALL i311_add(g_str,l_i)
              LET g_rows[p_ac].lists[i].fields[p_j] = g_str
              LET g_rows1[p_ac].lists1[i].fields1[p_j] = g_rows[p_ac].lists[i].fields[p_j]        
              LET g_value1[p_ac].value2[p_j] = i
              IF g_str = ls_right THEN
                 EXIT WHILE
              END IF
           END WHILE      
        END IF  #No.TQC-640118 
     END IF     
  END IF  #No.TQC-640118
 
  IF li_pos = 0 THEN  #No.TQC-640118                                                                                                                                    
  #判斷條件是否為'>'形式                                                                                                            
     LET li_pos = pvalue.getIndexOf('>',1)                                                                                             
     IF li_pos = 1 THEN 
        LET l_pos = li_pos
        LET i = 0                                                                                                               
        #得到要比較的內容                                                                                                              
        LET ls_right = pvalue.subString(2,pvalue.getLength())
        LET l_i = Length(ls_right)
        LET g_str = ls_right
        WHILE TRUE
           LET i = i+1
           CALL i311_add(g_str,l_i)
           LET g_rows[p_ac].lists[i].fields[p_j] = g_str
           LET g_rows1[p_ac].lists1[i].fields1[p_j] = g_rows[p_ac].lists[i].fields[p_j]
           LET g_value1[p_ac].value2[p_j] = i
           IF g_str = li_max_num THEN
              EXIT WHILE
           END IF
        END WHILE   
     END IF
  END IF  #No.TQC-640118
 
  IF li_pos = 0 THEN  #No.TQC-640118                                                                                                                                    
  #判斷條件是否為'<'形式                                                                                                            
     LET li_pos = pvalue.getIndexOf('<',1)                                                                                             
     IF li_pos = 1 THEN                                      
        LET l_pos = li_pos    
        LET i = 1                                                                       
        #得到要比較的內容                                                                                                              
        LET ls_right = pvalue.subString(2,pvalue.getLength())
        LET l_i = Length(ls_right)
        LET g_str = li_min_num
        LET g_rows[p_ac].lists[i].fields[p_j] = g_str
        LET g_rows1[p_ac].lists1[i].fields1[p_j] = g_rows[p_ac].lists[i].fields[p_j]     
        WHILE TRUE
           CALL i311_add(g_str,l_i)
           IF g_str = ls_right THEN
              EXIT WHILE
           END IF
           LET i = i+1
           LET g_rows[p_ac].lists[i].fields[p_j] = g_str
           LET g_rows1[p_ac].lists1[i].fields1[p_j] = g_rows[p_ac].lists[i].fields[p_j]
           LET g_value1[p_ac].value2[p_j] = i
        END WHILE
     END IF
  END IF  #No.TQC-640118
 
  IF li_pos = 0 THEN  #No.TQC-640118                                                                                                                                    
  #判斷條件是否為'|'形式
     LET li_pos = pvalue.getIndexOf('|',1)                                         
     IF li_pos > 0 THEN
        LET l_pos = li_pos
        LET i = 0
        LET tok = base.StringTokenizer.create(pvalue,"|")
        WHILE tok.hasMoreTokens()
          LET i = i+1
          LET g_rows[p_ac].lists[i].fields[p_j] = tok.nextToken()
          LET l_m = g_rows[p_ac].lists[i].fields[p_j]
          LET g_value1[p_ac].value2[p_j] = i
          SELECT agc04 INTO lc_agc04 FROM agc_file                      
           WHERE agc01 = g_agc[p_j].agc01                              
          IF lc_agc04 = '2' THEN                                        
             LET lc_agd03 = NULL
             SELECT agd03 INTO lc_agd03 FROM agd_file                   
              WHERE agd01 = g_agc[p_j].agc01                           
                AND agd02 = l_m
             LET g_rows1[p_ac].lists1[i].fields1[p_j] = lc_agd03
          ELSE                                                          
             LET g_rows1[p_ac].lists1[i].fields1[p_j] = g_rows[p_ac].lists[i].fields[p_j]           
          END IF 
        END WHILE
     END IF
  END IF  #No.TQC-640118
 
  IF li_pos = 0 THEN  #No.TQC-640118                                                                                                                                    
  #判斷條件是否為'n:m'形式
     LET li_pos = pvalue.getIndexOf(':',1)
     IF li_pos > 0 THEN
        LET l_pos = li_pos
        LET ls_left = pvalue.subString(1,li_pos-1)
        LET ls_right = pvalue.subString(li_pos+1,pvalue.getLength())
        SELECT agc04 INTO lc_agc04 FROM agc_file                      
         WHERE agc01 = g_agc[p_j].agc01                              
        IF lc_agc04 = '2' THEN
           LET i = 0
           LET l_sql = "SELECT agd02 FROM agd_file ",
                       " WHERE agd01 = '",g_agc[p_j].agc01,"'",
                       "   AND agd02 BETWEEN '",ls_left,"' AND '",ls_right,"'"
           PREPARE i311_p06 FROM l_sql
           DECLARE agd_c6 CURSOR FOR i311_p06
           FOREACH agd_c6 INTO l_m
              LET i = i+1
              LET g_rows[p_ac].lists[i].fields[p_j] = l_m
              LET lc_agd03 = NULL                                                                                                       
              SELECT agd03 INTO lc_agd03 FROM agd_file                                                                                  
               WHERE agd01 = g_agc[p_j].agc01                                                                                           
                 AND agd02 = l_m                                                                                                        
              LET g_rows1[p_ac].lists1[i].fields1[p_j] = lc_agd03
              LET g_value1[p_ac].value2[p_j] = i
           END FOREACH             
        ELSE 
           LET i = 1
           LET l_i = Length(ls_right)
           LET g_str = ls_left
           LET g_rows[p_ac].lists[i].fields[p_j] = g_str
           LET g_rows1[p_ac].lists1[i].fields1[p_j] = g_rows[p_ac].lists[i].fields[p_j]
           WHILE TRUE
              LET i = i+1
              CALL i311_add(g_str,l_i)
              LET g_rows[p_ac].lists[i].fields[p_j] = g_str
              LET g_rows1[p_ac].lists1[i].fields1[p_j] = g_rows[p_ac].lists[i].fields[p_j]        
              LET g_value1[p_ac].value2[p_j] = i
              IF g_str = ls_right THEN
                 EXIT WHILE
              END IF
           END WHILE     
        END IF 
     END IF
  END IF  #No.TQC-640118
  
  IF l_pos = 0 THEN
     LET l_m = pvalue
     LET g_value1[p_ac].value2[p_j] = 1
     LET g_rows[p_ac].lists[1].fields[p_j] = l_m   
     SELECT agc04 INTO lc_agc04 FROM agc_file                      
      WHERE agc01 = g_agc[p_j].agc01                              
     IF lc_agc04 = '2' THEN    
        LET lc_agd03 = NULL                                    
        SELECT agd03 INTO lc_agd03 FROM agd_file                   
         WHERE agd01 = g_agc[p_j].agc01                           
           AND agd02 = l_m   
        LET g_rows1[p_ac].lists1[1].fields1[p_j] = lc_agd03
     ELSE                                                          
        LET g_rows1[p_ac].lists1[1].fields1[p_j] = g_rows[p_ac].lists[1].fields[p_j]
     END IF 
  END IF 
END FUNCTION
 
#將新生成的子料件插入到數據庫中
FUNCTION i311_insert(ls_value,ls_spec,p_ac,p_i)
 DEFINE ls_value           LIKE ima_file.ima01,    #No.FUN-690026 VARCHAR(40)
        ls_spec            LIKE ima_file.ima02,    #No.FUN-690026 VARCHAR(60)
        p_ac,p_i           LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_param_list       STRING,                                                      
        l_tmp              STRING,                                                      
        l_str_tok          base.StringTokenizer
 DEFINE l_flag             LIKE type_file.chr1     #No.FUN-7B0018
 
    #先解析ls_value生成要傳給cl_copy_bom的那個l_param_list
    LET l_str_tok = base.StringTokenizer.create(ls_value,l_sp)
    LET l_tmp = l_str_tok.nextToken()   #先把第一個部分--名稱去掉
 
    LET g_sql = "SELECT agb03 FROM agb_file,ima_file WHERE ",
                 "ima01 = '",ps_value CLIPPED,"' AND agb01 = imaag ",
                 "ORDER BY agb02"
    DECLARE param_curs CURSOR FROM g_sql
    FOREACH param_curs INTO lc_agb03
      #l_str_tok中的Tokens數量應該和param_curs中的記錄數量完全一致
      IF cl_null(l_param_list) THEN
         LET l_param_list = '#',lc_agb03,'#|',l_str_tok.nextToken()
      ELSE
         LET l_param_list = l_param_list,'|#',lc_agb03,'#|',l_str_tok.nextToken()
      END IF
    END FOREACH
 
#    FOR b = 1 TO li_col_count
#        LET c = g_value1[p_ac].value2[b]
#        IF c > 1 THEN
#           LET d = '-----'
#           LET g_att[p_ac].s_ima01 = d
#           LET g_att[p_ac].s_ima02 = d
#           DISPLAY d TO s_ima01
#           DISPLAY d TO s_ima02
#           EXIT FOR
#        END IF
#    END FOR 
#           
#    IF c = 1 THEN
#       LET g_att[p_ac].s_ima01 = ls_value
#       LET g_att[p_ac].s_ima02 = ls_spec
#       DISPLAY ls_value TO s_ima01
#       DISPLAY ls_spec  TO s_ima02
#    END IF
 
    #進度加1
    CALL cl_progressing(" ")
 
    #向ima_file中插入新生成的料件記錄
    IF cl_copy_ima(ps_value,ls_value,ls_spec,l_param_list) = TRUE THEN
       #如果向其中成功插入記錄則同步插入屬性記錄到imx_file中去
      UPDATE ima_file SET imaag1 = ps_value,ima940 = g_sub_ima940,
                          ima941 = g_sub_ima941
        WHERE ima01 = ls_value               #No.FUN-A50011  
       IF i0 > 0 THEN          
          LET v1  = g_rows[p_ac].lists[i0].fields[1]
       ELSE
          LET v1  = NULL
       END IF
       IF i1 > 0 THEN
          LET v2  = g_rows[p_ac].lists[i1].fields[2]
       ELSE
          LET v2  = NULL
       END IF
       IF i2 > 0 THEN
          LET v3  = g_rows[p_ac].lists[i2].fields[3]
       ELSE
          LET v3  = NULL
       END IF
       IF i3 > 0 THEN
          LET v4  = g_rows[p_ac].lists[i3].fields[4]
       ELSE
          LET v4  = NULL
       END IF
       IF i4 > 0 THEN
          LET v5  = g_rows[p_ac].lists[i4].fields[5]
       ELSE
          LET v5  = NULL
       END IF
       IF i5 > 0 THEN
          LET v6  = g_rows[p_ac].lists[i5].fields[6]
       ELSE
          LET v6  = NULL
       END IF
       IF i6 > 0 THEN
          LET v7  = g_rows[p_ac].lists[i6].fields[7]
       ELSE
          LET v7  = NULL
       END IF
       IF i7 > 0 THEN
          LET v8  = g_rows[p_ac].lists[i7].fields[8]
       ELSE
          LET v8  = NULL
       END IF
       IF i8 > 0 THEN
          LET v9  = g_rows[p_ac].lists[i8].fields[9]
       ELSE
          LET v9  = NULL
       END IF
       IF i9 > 0 THEN
          LET v10 = g_rows[p_ac].lists[i9].fields[10]
       ELSE
          LET v10 = NULL
       END IF
       INSERT INTO imx_file VALUES(ls_value,ps_value,v1,v2,v3,v4,v5,v6,v7,v8,v9,v10)
       #如果向imx_file中插入記錄失敗則也應將ima_file中已經建立的紀錄刪除以保證兩邊
       #記錄的完全同步
       IF SQLCA.sqlcode THEN
#         CALL cl_err('Failure to insert imx_file , rollback insert to ima_file !','',1)
          CALL cl_err3("ins","imx_file",ls_value,"",SQLCA.sqlcode,"","",1)   #NO.FUN-640266
          DELETE FROM ima_file WHERE ima01 = ls_value
          #No.FUN-7B0018 080304 add --begin
#         IF NOT s_industry('std') THEN      #No.FUN-830132 mark               
          IF s_industry('std') THEN          #No.FUN-830132 add
             LET l_flag = s_del_imaicd(ls_value,'')
          END IF
          #No.FUN-7B0018 080304 add --end
       ELSE 
          LET b = b+1
          IF b <= 100 THEN
             LET l_att[b].att01 = v1
             LET l_att[b].att01_c = v1
             LET l_att[b].att02 = v2
             LET l_att[b].att02_c = v2
             LET l_att[b].att03 = v3
             LET l_att[b].att03_c = v3
             LET l_att[b].att04 = v4
             LET l_att[b].att04_c = v4
             LET l_att[b].att05 = v5
             LET l_att[b].att05_c = v5
             LET l_att[b].att06 = v6
             LET l_att[b].att06_c = v6
             LET l_att[b].att07 = v7
             LET l_att[b].att07_c = v7
             LET l_att[b].att08 = v8
             LET l_att[b].att08_c = v8
             LET l_att[b].att09 = v9
             LET l_att[b].att09_c = v9
             LET l_att[b].att10 = v10
             LET l_att[b].att10_c = v10
             LET l_att[b].s_ima01 = ls_value
             LET l_att[b].s_ima02 = ls_spec
          END IF
       END IF
    END IF
END FUNCTION 
 
#比較輸入的值，確認其合理性
FUNCTION i311_cmp(ls_left,ls_right,l_i,p_j)
  DEFINE ls_left,ls_right  STRING,
         l_i,l_i0,l_e,p_j  LIKE type_file.num5,    #No.FUN-690026 SMALLINT
         l_f,l_g           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
         li_min_num        LIKE agc_file.agc05, #No.TQC-640118
         li_max_num        LIKE agc_file.agc06  #No.TQC-640118
 
  LET li_min_num = g_agc[p_j].agc05  #No.TQC-640118                      
  LET li_max_num = g_agc[p_j].agc06  #No.TQC-640118
  
  LET l_i0 = 0
  FOR l_i0 = 1 TO l_i
      LET l_e  = 0
      LET l_f = ls_left.subString(l_i0,l_i0)
      LET l_g = ls_right.subString(l_i0,l_i0)
      IF l_e MATCHES '[0-9]' AND l_f MATCHES '[0-9]' THEN
         LET l_e = 1
      END IF
      IF l_f MATCHES '[A-Z]' AND l_g MATCHES '[A-Z]' THEN
         LET l_e = 1
      END IF
      IF l_f MATCHES '[a-z]' AND l_g MATCHES '[a-z]' THEN
         LET l_e = 1
      END IF
      IF l_e = 0 THEN
         IF li_min_num IS NULL OR li_max_num IS NULL THEN  #No.TQC-640118
            CALL cl_err('','mfg9089',1)  #No.TQC-640118
         ELSE     #No.TQC-640118                                                                      
            CALL cl_err_msg("","lib-232",g_agc[p_j].agc05 CLIPPED|| "|" || g_agc[p_j].agc06 CLIPPED,1)
         END IF   #No.TQC-640118
         LET g_success = 'N'
         RETURN
      END IF
  END FOR
 
  LET l_i0 = 0
  FOR l_i0 = 1 TO l_i
      LET l_f = ls_left.subString(l_i0,l_i0)
      LET l_g = ls_right.subString(l_i0,l_i0)
      IF l_e MATCHES '[0-9]' AND l_f MATCHES '[0-9]' THEN
         IF l_f > l_g THEN
            IF li_min_num IS NULL OR li_max_num IS NULL THEN  #No.TQC-640118
               CALL cl_err('','mfg9089',1)  #No.TQC-640118
            ELSE     #No.TQC-640118                                                                      
               CALL cl_err_msg("","lib-232",g_agc[p_j].agc05 CLIPPED|| "|" || g_agc[p_j].agc06 CLIPPED,1)
            END IF   #No.TQC-640118
            LET g_success = 'N'
            RETURN
         ELSE
            IF l_f < l_g THEN
               EXIT FOR
            END IF
         END IF
      END IF
      IF l_f MATCHES '[A-Z]' AND l_g MATCHES '[A-Z]' THEN
         IF l_f > l_g THEN
            IF li_min_num IS NULL OR li_max_num IS NULL THEN  #No.TQC-640118
               CALL cl_err('','mfg9089',1)  #No.TQC-640118
            ELSE     #No.TQC-640118                                                                      
               CALL cl_err_msg("","lib-232",g_agc[p_j].agc05 CLIPPED|| "|" || g_agc[p_j].agc06 CLIPPED,1)
            END IF   #No.TQC-640118
            LET g_success = 'N'
            RETURN
         ELSE
            IF l_f < l_g THEN
               EXIT FOR
            END IF
         END IF
      END IF
      IF l_f MATCHES '[a-z]' AND l_g MATCHES '[a-z]' THEN
         IF l_f > l_g THEN
            IF li_min_num IS NULL OR li_max_num IS NULL THEN  #No.TQC-640118
               CALL cl_err('','mfg9089',1)  #No.TQC-640118
            ELSE     #No.TQC-640118                                                                      
               CALL cl_err_msg("","lib-232",g_agc[p_j].agc05 CLIPPED|| "|" || g_agc[p_j].agc06 CLIPPED,1)
            END IF   #No.TQC-640118
            LET g_success = 'N'
            RETURN
         ELSE
            IF l_f < l_g THEN
               EXIT FOR
            END IF
         END IF
      END IF
  END FOR
END FUNCTION
 
#具體解析範圍輸入的數據
FUNCTION i311_add(l_str,l_i)
  DEFINE l_str           LIKE ze_file.ze03,     #No.FUN-690026 VARCHAR(40)
         l_i,l_i0,l_j    LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
  #從數值的低位開始解析
  FOR l_i0 = l_i TO 1 STEP -1
      LET l_j = 0
      #當為最低位時
      IF l_i0 = l_i THEN 
         IF l_str[l_i0] MATCHES '[0-8]' THEN  #當為0~8時加1
            LET l_str[l_i0] = l_str[l_i0]+1
            EXIT FOR
         ELSE  
            IF l_str[l_i0] = '9' THEN         #當為9時置0
               LET l_str[l_i0] = '0'
            END IF
         END IF
         IF l_str[l_i0] MATCHES '[A-Y]' THEN
            FOR l_j = 1 TO 25
                IF g_v2[l_j] = l_str[l_i0] THEN   #當為A~Y時令其為下一個字母
                   LET l_str[l_i0] = g_v2[l_j+1]
                   EXIT FOR
                END IF
            END FOR
         ELSE
            IF l_str[l_i0] = 'Z' THEN             #當為Z時置為A
               LET l_str[l_i0] = 'A'
            END IF
         END IF
         IF l_str[l_i0] MATCHES '[a-y]' THEN
            FOR l_j = 1 TO 25
                IF g_v3[l_j] = l_str[l_i0] THEN   #當a~y時令其為下一個字母
                   LET l_str[l_i0] = g_v3[l_j+1]
                   EXIT FOR
                END IF
            END FOR
         ELSE
            IF l_str[l_i0] = 'z' THEN             #當為z時置為a
               LET l_str[l_i0] = 'a'
            END IF   
         END IF
      ELSE                                        #當非最低位時       
         IF l_str[l_i0] MATCHES '[0-8]' AND (l_str[l_i0+1] = '0'
            OR l_str[l_i0+1] = 'A' OR l_str[l_i0+1] = 'a') THEN 
            LET l_str[l_i0] = l_str[l_i0]+1
            EXIT FOR
         ELSE
            IF l_str[l_i0] = '9' AND l_str[l_i0+1] = '0' THEN
               LET l_str[l_i0] = '0'
            END IF 
         END IF
         IF l_str[l_i0] MATCHES '[A-Y]' AND (l_str[l_i0+1] = '0'
            OR l_str[l_i0+1] = 'A' OR l_str[l_i0+1] = 'a') THEN
            FOR l_j = 1 TO 25
                IF g_v2[l_j] = l_str[l_i0] THEN
                   LET l_str[l_i0] = g_v2[l_j+1]
                   EXIT FOR
                END IF
            END FOR
         ELSE
            IF l_str[l_i0] = 'Z' AND (l_str[l_i0+1] = '0'
               OR l_str[l_i0+1] = 'A' OR l_str[l_i0+1] = 'a') THEN
               LET l_str[l_i0] = 'A'
            END IF
         END IF
         IF l_str[l_i0] MATCHES '[a-y]' AND (l_str[l_i0+1] = '0'
            OR l_str[l_i0+1] = 'A' OR l_str[l_i0+1] = 'a') THEN
            FOR l_j = 1 TO 25
                IF g_v3[l_j] = l_str[l_i0] THEN
                   LET l_str[l_i0] = g_v3[l_j+1]
                   EXIT FOR
                END IF
            END FOR
         ELSE
            IF l_str[l_i0] = 'z' AND (l_str[l_i0+1] = '0'
               OR l_str[l_i0+1] = 'A' OR l_str[l_i0+1] = 'a') THEN
               LET l_str[l_i0] = 'a'
            END IF
         END IF
      END IF
  END FOR
  
  LET g_str = l_str
 
END FUNCTION
#No.FUN-640013  --end--
 
 
