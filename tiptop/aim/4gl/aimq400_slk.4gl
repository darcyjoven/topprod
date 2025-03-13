# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aimq400_slk.4gl
# Descriptions...: 料件庫存明細數量查詢
# Date & Author..:No.FUN-C40022  2012/04/09 by linlin


DATABASE ds 
GLOBALS "../../config/top.global"
GLOBALS "../../axm/4gl/s_slk.global"
 
DEFINE g_img  DYNAMIC ARRAY OF RECORD
           imgplant    LIKE img_file.imgplant,
           azw08       LIKE azw_file.azw08,
           img02       LIKE img_file.img02,
           imd02       LIKE imd_file.imd02,
           img03       LIKE img_file.img03,    
           img04       LIKE img_file.img04,    
           img01       LIKE img_file.img01,
           ima02       LIKE ima_file.ima02,
           img09       LIKE img_file.img09,
           img10       LIKE type_file.num20_6
       END RECORD 
DEFINE g_imxtext DYNAMIC ARRAY OF RECORD
          color     LIKE type_file.chr50,
          detail    DYNAMIC ARRAY OF RECORD
            size   LIKE type_file.chr50
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
DEFINE   g_sql          STRING 
DEFINE   g_sql1         STRING
DEFINE   g_cnt          LIKE type_file.num10
DEFINE   l_ac           LIKE type_file.num5,
         l_ac2          LIKE type_file.num5
DEFINE   l_i            LIKE type_file.num5
DEFINE   g_rec_b        LIKE type_file.num10
DEFINE   g_rec_b2       LIKE type_file.num10
DEFINE   g_wc           STRING
DEFINE   g_wc1          STRING
DEFINE   g_shop1        LIKE type_file.chr1
DEFINE   g_shop2        LIKE type_file.chr1
DEFINE   g_store        LIKE type_file.chr1
DEFINE   g_show1        LIKE type_file.chr1
DEFINE   g_show2        LIKE type_file.chr1
DEFINE   g_azw01        LIKE azw_file.azw01
DEFINE   g_ima01        LIKE ima_file.ima01
DEFINE   lc_qbe_sn      LIKE gbm_file.gbm01
DEFINE   g_row_count    LIKE type_file.num10      
DEFINE   g_curs_index   LIKE type_file.num10 

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   WHENEVER ERROR CALL cl_err_msg_log
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   
   OPEN WINDOW q400_w WITH FORM "aim/42f/aimq400_slk"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   CALL cl_set_comp_visible("imx11,imx12,imx13,imx14,imx15",FALSE)
   CALL q400_menu()
   CLOSE WINDOW q400_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q400_cs()
 DEFINE   l_cnt LIKE type_file.num5   

   DIALOG ATTRIBUTE(UNBUFFERED)
      INPUT g_shop1,g_shop2,g_store,g_show1,g_show2
           FROM FORMONLY.shop1,FORMONLY.shop2,FORMONLY.store,FORMONLY.show1,FORMONLY.show2
         ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
         BEFORE INPUT
            IF g_shop1='Y'  THEN
               DISPLAY g_shop1 TO shop1
               DISPLAY g_plant TO azw01
            END IF     
      END INPUT

      CONSTRUCT g_wc ON azw01 FROM azw01
         BEFORE CONSTRUCT
           CALL cl_qbe_init()
      END CONSTRUCT 
      CONSTRUCT g_wc1 ON ima01 FROM ima01
          BEFORE CONSTRUCT
           CALL cl_qbe_init()
          END CONSTRUCT 
      ON ACTION CONTROLP 
            CASE
               WHEN INFIELD(azw01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form = 'q_azw01'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO azw01
                  NEXT FIELD azw01
               WHEN INFIELD(ima01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form = 'q_ima01_9'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima01
                  NEXT FIELD ima01

               OTHERWISE EXIT CASE 
            END CASE
       ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 ACCEPT DIALOG
                 
       ON ACTION about         
          CALL cl_about()      
 
       ON ACTION HELP          
          CALL cl_show_help()  
 
       ON ACTION controlg      
          CALL cl_cmdask()     
         
       ON ACTION qbe_save
          CALL cl_qbe_save()
 
       ON ACTION qbe_select
          CALL cl_qbe_list() RETURNING lc_qbe_sn
          CALL cl_qbe_display_condition(lc_qbe_sn)

       ON ACTION ACCEPT
          ACCEPT DIALOG

       ON ACTION EXIT
          LET INT_FLAG = TRUE
          EXIT DIALOG

       ON ACTION CANCEL
          LET INT_FLAG = TRUE
          EXIT DIALOG
    END DIALOG 
END FUNCTION

FUNCTION q400_q()
 
    CALL cl_opmsg('q')
    CALL q400_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    IF g_show1 = 'N' THEN
       CLEAR FORM #清除畫面
       CALL g_img.clear()
       CALL cl_opmsg('q')
       CALL cl_set_head_visible("","YES")
       LET g_rec_b = 0
       LET l_ac = 1
       LET l_ac2= 1
    ELSE
       LET l_ac = g_rec_b+1
    END IF

    CALL q400_b_fill()
    MESSAGE ''
    
END FUNCTION 

#QBE 查詢資料
FUNCTION q400_b_fill()
   DEFINE l_sql1   STRING
   DEFINE l_sql2   STRING
   DEFINE l_sql3   STRING
   DEFINE l_sql4   STRING
   DEFINE l_img10  LIKE img_file.img10
   DEFINE l_i      LIKE type_file.num5
   DEFINE l_n      LIKE type_file.num5
   DEFINE l_ima151 LIKE ima_file.ima151

   DEFINE l_img  RECORD
           imgplant    LIKE img_file.imgplant,
           azw08       LIKE azw_file.azw08,
           img02       LIKE img_file.img02,
           imd02       LIKE imd_file.imd02,
           img03       LIKE img_file.img03,      
           img04       LIKE img_file.img04,
           img01       LIKE img_file.img01,
           ima02       LIKE ima_file.ima02,
           img09       LIKE img_file.img09,
           img10       LIKE type_file.num20_6
       END RECORD

   MESSAGE ''
 
   IF g_shop1='N' AND g_shop2='N' AND g_store='N' THEN
      CALL cl_err("","aim1158",0)
      RETURN
   END IF
   CALL g_imx.clear()
   IF cl_null(g_rec_b) THEN LET g_rec_b=0 END IF
 
   IF cl_null(g_wc) THEN
      LET g_wc=" 1=1"
   END IF
   IF cl_null(g_wc1) THEN
      LET g_wc1=" 1=1"
   END IF

   INITIALIZE g_sql,l_sql1,l_sql2,l_sql3,l_sql4 TO NULL

   IF g_shop1='Y' THEN
      LET l_sql1 = "SELECT azw01,azw08,img02,'',img03,img04,img01,'',img09,img10",
                   "  FROM ",cl_get_target_table(g_plant,'img_file'),",",
                             cl_get_target_table(g_plant,'azw_file'),      
                   " WHERE ",g_wc CLIPPED,
                   "   AND azw01=imgplant",
                   "   AND azwacti='Y'",
                   "   AND imgplant='",g_plant,"'"

      IF g_shop1='Y' THEN LET g_sql=l_sql1 CLIPPED END IF
   END IF

   IF g_shop2='Y' THEN
      LET l_sql2 = "SELECT azw01,azw08,img02,'',img03,img04,img01,'',img09,img10",
                   "  FROM ",cl_get_target_table(g_plant,'img_file'),",",
                             cl_get_target_table(g_plant,'azw_file'),      
                   " WHERE ",g_wc CLIPPED,
                   "   AND azw01=imgplant",
                   "   AND azwacti='Y'",
                   "   AND img02 IN (SELECT DISTINCT rtz07 ",
                   "                   FROM ",cl_get_target_table(g_plant,'rtz_file'),
                   "                  WHERE rtz10 IN (select rtz10 from ",
                                                                cl_get_target_table(g_plant,'rtz_file'),
                                                             " WHERE rtz01  IN (SELECT azw01 FROM azw_file WHERE ",g_wc CLIPPED,")))" 

      IF cl_null(g_sql) THEN
         LET g_sql=l_sql2 CLIPPED 
      ELSE
         LET g_sql=g_sql," UNION ",l_sql2 CLIPPED
      END IF
   END IF

   IF g_store='Y' THEN
      LET l_sql3 = "SELECT azw01,azw08,img02,'',img03,img04,img01,'',img09,img10",
                   "  FROM ",cl_get_target_table(g_plant,'img_file'),",",
                             cl_get_target_table(g_plant,'azw_file'),      
                   " WHERE ",g_wc CLIPPED,
                   "   AND azw01=imgplant",
                   "   AND azwacti='Y'",
                   "   AND img02 in (SELECT DISTINCT rvk03 ",
                   "                  FROM ",cl_get_target_table(g_plant,'rvk_file'),",",
                                             cl_get_target_table(g_plant,'rty_file'), 
                   "                 WHERE rty04 is not null AND  rvkacti='Y' AND rtyacti='Y'",
                   "                   AND rvk01=rty04 AND rty01 IN (SELECT azw01 FROM azw_file WHERE ",g_wc CLIPPED,")",
                   "                   AND (rvk04='*' or rvk04 IN (SELECT azw01 FROM azw_file WHERE ",g_wc CLIPPED,")))"
      IF cl_null(g_sql) THEN
         LET g_sql=l_sql3 CLIPPED
      ELSE
         LET g_sql=g_sql," UNION ",l_sql3 CLIPPED
      END IF
   END IF

#   LET g_sql="SELECT DISTINCT azw01,azw08,img02,'',img03,img04,COALESCE(imx00,img01) as A,ima02,img09,SUM(img10)",
#             " FROM (",g_sql CLIPPED,")",
#             " LEFT JOIN ",cl_get_target_table(g_plant,'imx_file')," ON imx000=img01",  
#             "  GROUP BY azw01,azw08,img02,'',img03,img04,A,ima02,img09 ",    
#             "  ORDER BY azw01,img02,img03,img04,img09 "           

   LET l_sql4=g_sql CLIPPED

   LET g_sql="SELECT DISTINCT azw01,azw08,img02,'',img03,img04,imx00,'',img09,SUM(img10)",   #多屬性庫存資料
             " FROM (",g_sql CLIPPED,")",",",
                  cl_get_target_table(g_plant,'ima_file'),",",
                  cl_get_target_table(g_plant,'imx_file'),
             " WHERE ",g_wc1 CLIPPED,
             "   AND imx000=img01",  
             "   AND ima01=imx00",
             "   AND ima151='Y'",
             "   AND ima1010='1'",
             "   AND imaacti='Y'",
             "  GROUP BY azw01,azw08,img02,'',img03,img04,imx00,'',img09 "    

   LET l_sql4="SELECT DISTINCT azw01,azw08,img02,'',img03,img04,img01,'',img09,SUM(img10)",  #非多屬性庫存資料
             " FROM (",l_sql4 CLIPPED,")",",",
                  cl_get_target_table(g_plant,'ima_file'),
             " WHERE ",g_wc1 CLIPPED,
             "   AND img01=ima01",  
             "   AND ima1010='1'",
             "   AND imaacti='Y'",
             "   AND (ima151<>'N' OR imaag<>'@CHILD' OR imaag is null) AND ima151<>'Y'",
             "  GROUP BY azw01,azw08,img02,'',img03,img04,img01,'',img09 "    

   LET g_sql=g_sql," UNION ALL ",l_sql4 CLIPPED,"  ORDER BY azw01,img02,img03,img04 "

   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
   CALL cl_parse_qry_sql(g_sql,'') RETURNING g_sql 
 
   PREPARE q400_prepare FROM g_sql
   DECLARE q400_cs                         #CURSOR
           CURSOR FOR q400_prepare
   FOREACH q400_cs INTO l_img.*
      SELECT ima02 INTO l_img.ima02 FROM ima_file WHERE ima01=l_img.img01
      SELECT imd02 INTO l_img.imd02 FROM imd_file WHERE imd01=l_img.img02
      IF cl_null(l_img.img10) THEN 
         LET l_img.img10=0
      END IF
      IF g_show2='Y' THEN
         IF l_img.img10=0 OR cl_null(l_img.img10) THEN
            SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = l_img.img01
            IF l_ima151= 'Y' THEN
               SELECT COUNT(DISTINCT imx000) INTO l_n FROM imx_file,img_file
                 WHERE imx000=img01 AND imx00=l_img.img01 AND img10 <>0 AND img02 =l_img.img02
                   AND img03 = l_img.img03 AND imgplant = l_img.imgplant
               IF l_n = 0 THEN
                  CONTINUE FOREACH
               END IF
            ELSE
                CONTINUE FOREACH
            END IF 
         END IF
      END IF
      LET g_img[l_ac].*=l_img.*
      LET l_ac = l_ac+1
   END FOREACH
   
   CALL g_img.deleteElement(l_ac)
   LET l_ac = l_ac - 1
   LET g_rec_b = l_ac
   IF g_rec_b=0 THEN
      CALL cl_err("","aim1159",0)
   END IF
     
   INITIALIZE g_wc,g_wc1,g_azw01,g_ima01   TO NULL 
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION

FUNCTION q400_menu()
   CALL g_img.clear()
   CALL g_imx.clear()
   WHILE TRUE
      CALL q400_dialog("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q400_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_img),'','')
            END IF
         WHEN "exit"
            EXIT WHILE
      END CASE
   END WHILE


END FUNCTION

FUNCTION q400_dialog(p_ud)
   DEFINE   p_ud              LIKE type_file.chr1
   DEFINE lc_qbe_sn           LIKE gbm_file.gbm01
   IF p_ud <> "G" THEN
      RETURN
   END IF
   
   IF cl_null(g_shop1) THEN LET g_shop1='Y' END IF 
   IF cl_null(g_shop2) THEN LET g_shop2='N' END IF
   IF cl_null(g_store) THEN LET g_store='N' END IF
   IF cl_null(g_show1) THEN LET g_show1='N' END IF
   IF cl_null(g_show2) THEN LET g_show2='N' END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTE(UNBUFFERED)
    
      DISPLAY ARRAY g_img TO s_img.* ATTRIBUTE(COUNT=g_rec_b)

         BEFORE ROW
            LET l_ac = DIALOG.getCurrentRow("s_img")
            IF l_ac>0 then
               CALL s_settext_slk(g_img[l_ac].img01)
               CALL s_fillimx_slk(g_img[l_ac].img01,g_img[l_ac].img02,g_img[l_ac].img03,g_img[l_ac].img04,g_img[l_ac].imgplant,g_img[l_ac].img09)   
            END IF

      END DISPLAY

      DISPLAY ARRAY g_imx TO s_imx.*
         BEFORE DISPLAY
            CALL cl_show_fld_cont()
         BEFORE ROW
            LET l_ac2 = DIALOG.getCurrentRow("s_imx")
      END DISPLAY
            
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
         

      ON ACTION exporttoexcel 
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_img),'','')
         ACCEPT DIALOG
         
      ON ACTION CLOSE
         LET g_action_choice="exit"
         EXIT DIALOG
         
      ON ACTION about         
         CALL cl_about()     
         
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont() 
          
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask() 

      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")  
         
      ON ACTION accept
         ACCEPT DIALOG
 
      ON ACTION CANCEL
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
        EXIT DIALOG
        
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION s_settext_slk(p_ima01)
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
               "   AND imx01=agd02 ",
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

#
#Usage..........: 函數功能說明：此函數為母料件單身調用，用於帶出各個二維屬性對應的子料件的數量值，并儲存在g_imx中
#                               傳入參數：母料件編號，儲存子料件的表的表名,key列名以及key相應的值                        
#
# Input Parameter: p_ima01            母料件編號
#                  p_keyvalue1        key值1--primary key value1，倉庫
#                  p_library          儲位
#                  p_batch            批號 
#                  p_keyvalue2        key值2--primary key value2，營運中心
#                  p_keyvalue2        key值2--primary key value3, 單位
#
FUNCTION s_fillimx_slk(p_ima01,p_keyvalue1,p_library,p_batch,p_keyvalue2,p_keyvalue3)  
  DEFINE p_ima01             LIKE ima_file.ima01
  DEFINE p_keyvalue1         LIKE type_file.chr20
  DEFINE p_keyvalue2         LIKE type_file.chr20
  DEFINE p_keyvalue3         LIKE type_file.chr20
  DEFINE l_ima151            LIKE ima_file.ima151
  DEFINE l_i,l_j,l_k         LIKE type_file.num5
  DEFINE l_sql               STRING
  DEFINE p_library           LIKE img_file.img03    
  DEFINE p_batch             LIKE img_file.img04    

   SELECT ima151 INTO l_ima151 FROM ima_file
    WHERE ima01 = p_ima01 AND imaacti='Y'
   IF l_ima151 = 'N' OR cl_null(l_ima151) THEN
      RETURN
   END IF

   LET g_keyvalue1=p_keyvalue1
   LET g_keyvalue2=p_keyvalue2
   
   IF cl_null(p_library) THEN LET p_library=' ' END IF
   IF cl_null(p_batch)   THEN LET p_batch=' '   END IF

   LET l_sql = "SELECT SUM(img10) FROM img_file ",
               " WHERE img01=? AND img02='",p_keyvalue1,"'",
               "   AND img03='",p_library,"'",                        
               "   AND img04='",p_batch,"'",                        
               "   AND imgplant='",p_keyvalue2,"' AND img09='",p_keyvalue3,"'"
   PREPARE s_getamount_slk_pre FROM l_sql

   CALL g_imx.clear()

   FOR l_k = 1 TO g_imxtext.getLength() #遍歷母料件二維屬性數組
      LET l_i=g_imx.getLength()+1
      LET g_imx[l_i].color = g_imxtext[l_k].color CLIPPED  #得到顏色屬性值
      FOR l_j = 1 TO g_imxtext[1].detail.getLength()
         CASE l_j
          WHEN 1
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx01
          WHEN 2
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx02
          WHEN 3
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx03
          WHEN 4
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx04
          WHEN 5
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx05
          WHEN 6
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx06
          WHEN 7
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx07
          WHEN 8
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx08
          WHEN 9
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx09
          WHEN 10
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx10
          WHEN 11
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx11
          WHEN 12
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx12
          WHEN 13
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx13
          WHEN 14
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx14
          WHEN 15
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx15
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
FUNCTION s_get_amount_slk(p_j,p_k,p_ima01)
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

    EXECUTE s_getamount_slk_pre USING l_ima01 INTO l_qty

    IF cl_null(l_qty) THEN
       LET l_qty = 0
    END IF

    RETURN l_qty

END FUNCTION
#No.FUN-C40022 ----add
