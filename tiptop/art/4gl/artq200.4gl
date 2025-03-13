# Prog. Version..: '5.30.06-13.03.14(00008)'     #
#
# Pattern name...: artq200.4gl
# Descriptions...: 營運中心庫存查詢作業
# Date & Author..: FUN-AB0106  l0/11/25 By huangtao
# Modify.........: No:MOD-B10158 11/01/21 By shiwuying 查询下*会退出
# Modify.........: No:FUN-B40094 11/05/09 By wangxin 添加訂單備置量oeb905
# Modify.........: No:FUN-B80079 11/08/10 By pauline 新增產品條碼欄位
# Modify.........: No:FUN-B80153 11/09/05 by pauline 增加期間異動ACTION
# Modify.........: No:FUN-B90081 11/09/09 by pauline 增加匯出EXCEL功能
# Modify.........: No:FUN-C70007 12/07/20 BY nanbing POS相關調整
# Modify.........: No:MOD-CC0018 13/02/01 By Elise (1) 調整將串rta_file調整為LEFT OUTER JOIN
#                                                  (2) tm.wc2請調整為主SQL的where條件

DATABASE ds
GLOBALS "../../config/top.global"
DEFINE  
      tm              RECORD
                      wc    LIKE type_file.chr1000, # Head Where condition 
                      wc2   LIKE type_file.chr1000  # Body Where condition  
                      END RECORD,
      g_rtz            RECORD 
                      rtz01 LIKE rtz_file.rtz01,
                      rtz13 LIKE rtz_file.rtz13,
                      rtz12 LIKE rtz_file.rtz12,
                      rtz03 LIKE rtz_file.rtz03
                      END RECORD,
      g_img         DYNAMIC ARRAY OF RECORD
                      rta05  LIKE rta_file.rta05,       #FUN-B80079 add
                      img01  LIKE img_file.img01,
                      ima02  LIKE ima_file.ima02,
                      img02  LIKE img_file.img02,
                      imd02  LIKE imd_file.imd02,
                      img10  LIKE img_file.img10,
                      oeb905 LIKE oeb_file.oeb905,#已備置量 #FUn-B40094 add
                      img09  LIKE img_file.img09
                    END RECORD,
      sr             RECORD
                      rta05 LIKE rta_file.rta05,       #FUN-B80079 add
                      img01  LIKE img_file.img01,
                      ima02  LIKE ima_file.ima02,
                      img02  LIKE img_file.img02,
                      imd02  LIKE imd_file.imd02,
                      img10  LIKE img_file.img10,
                      img09  LIKE img_file.img09
                    END RECORD, 
      g_sql     STRING,
      g_rec_b         LIKE type_file.num5,      #單身筆數 
      l_ac            LIKE type_file.num5      #目前處理的ARRAY CNT 
      
DEFINE p_row,p_col         LIKE type_file.num5
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5 
 
DEFINE   g_sql_tmp       STRING       
DEFINE   g_cnt           LIKE type_file.num10  
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose
DEFINE   g_msg           LIKE type_file.chr1000 
DEFINE   g_row_count    LIKE type_file.num10   
DEFINE   g_curs_index   LIKE type_file.num10  
DEFINE   g_jump         LIKE type_file.num10 
DEFINE   mi_no_ask       LIKE type_file.num5    
DEFINE   l_sql          STRING                 
DEFINE   g_str          STRING                
DEFINE   l_table        STRING 
DEFINE   g_posdbs       STRING   #FUN-C70007 add
DEFINE   g_db_links     STRING   #FUN-C70007 add 

MAIN

    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF   
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF 
   CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
        RETURNING g_time     
   DROP TABLE q200_tmp  
   CREATE TEMP TABLE q200_tmp(
                      rta05 LIKE ima_file.rta05,        #FUN-B80079 add
                      img01  LIKE img_file.img01,
                      ima02  LIKE ima_file.ima02,
                      img02  LIKE img_file.img02,
                      imd02  LIKE imd_file.imd02,
                      img10  LIKE img_file.img10,
                      img09  LIKE img_file.img09)
   
   LET p_row = 2 LET p_col = 12
   OPEN WINDOW q200_w AT p_row,p_col              #顯示畫面
        WITH FORM "art/42f/artq200"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)     
   CALL cl_ui_init()  
   CALL cl_set_comp_visible('rta05',FALSE)    #FUN-B80079 add 
   CALL q200_menu()
   CLOSE WINDOW i800_w              #結束畫面
   CALL cl_used(g_prog,g_time,2)    #計算使用時間 (退出使間) 
        RETURNING g_time             
END MAIN

#QBE 查詢資料
FUNCTION q200_cs()
   CLEAR FORM #清除畫面
   CALL cl_opmsg('q')
   CALL cl_set_comp_visible('rta05',TRUE)    #FUN-B80079 add 
   INITIALIZE tm.* TO NULL
   INITIALIZE g_rtz.* TO NULL
   CALL g_img.clear()  
   CONSTRUCT BY NAME tm.wc ON rtz01,rtz13,rtz12,rtz03
      BEFORE CONSTRUCT
        CALL cl_qbe_init()
      ON ACTION CONTROLP  
          IF INFIELD(rtz01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_rtz01"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO rtz01
              NEXT FIELD rtz01
          END IF
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT

      ON ACTION about    
         CALL cl_about()
 
      ON ACTION help   
         CALL cl_show_help()  
 
      ON ACTION controlg  
         CALL cl_cmdask()
    END CONSTRUCT
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    CALL q200_b_askkey()
    IF INT_FLAG THEN RETURN END IF
    MESSAGE ' WAIT '
    #抓单头的资料curs
    
   #MOD-B10158 Begin---
   #LET g_sql = " SELECT rtz01,rtz13,rtz12,rtz03 FROM rtz_file ",
   #            " WHERE ",tm.wc CLIPPED,
   #            " ORDER BY rtz01"

   #PREPARE q200_prepare FROM g_sql
   #DECLARE q200_cs
   #    SCROLL CURSOR WITH HOLD FOR q200_prepare
   #
   #LET g_sql =  " SELECT COUNT(*) FROM rtz_file WHERE ",tm.wc CLIPPED  
    LET g_sql = " SELECT rtz01,rtz13,rtz12,rtz03 FROM rtz_file,azw_file ",
                "  WHERE ",tm.wc CLIPPED,
                "    AND azw01=rtz01",
                "  ORDER BY rtz01"
    PREPARE q200_prepare FROM g_sql
    DECLARE q200_cs
        SCROLL CURSOR WITH HOLD FOR q200_prepare
    
    LET g_sql =  " SELECT COUNT(*) FROM rtz_file,azw_file ",
                 "  WHERE ",tm.wc CLIPPED,
                 "    AND azw01=rtz01"
   #MOD-B10158 End-----
    CALL cl_set_comp_visible('rta05',FALSE)    #FUN-B80079 add 
    PREPARE q200_precount FROM g_sql
    DECLARE q200_count CURSOR FOR q200_precount   

END FUNCTION 

FUNCTION q200_b_askkey()
    DEFINE lc_qbe_sn      LIKE gbm_file.gbm01 
 #   CONSTRUCT tm.wc2 ON img01,ima02,img02,imd02,img10,oeb905,img09 FROM  #FUN-B40094 add oeb905                                                            #FUN-B80079 mark
 #     s_img[1].img01,s_img[1].ima02,s_img[1].img02,s_img[1].imd02,s_img[1].img10,s_img[1].oeb905,s_img[1].img09 #FUN-B40094 add oeb905                     #FUN-B80079 mark
    CONSTRUCT tm.wc2 ON rta05,img01,ima02,img02,imd02,img10,oeb905,img09 FROM  #FUN-B40094 add oeb905                                                      #FUN-B80079 add
      s_img[1].rta05,s_img[1].img01,s_img[1].ima02,s_img[1].img02,s_img[1].imd02,s_img[1].img10,s_img[1].oeb905,s_img[1].img09 #FUN-B40094 add oeb905      #FUN-B80079 add
      
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
#FUN-B80079 add START
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(rta05)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_ima_q200"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rta05
               NEXT FIELD rta05
         END CASE
#FUN-B80079 add END
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
      ON ACTION about         
         CALL cl_about()  
 
      ON ACTION help     
         CALL cl_show_help()
 
      ON ACTION controlg   
         CALL cl_cmdask() 
         
      ON ACTION qbe_save
         CALL cl_qbe_save()
    END CONSTRUCT
    CALL cl_set_comp_visible('rta05',FALSE)    #FUN-B80079 add 
END FUNCTION

FUNCTION q200_menu()
   WHILE TRUE
     CALL q200_bp("G")
     CASE g_action_choice
       WHEN "query"
         IF cl_chk_act_auth() THEN
            CALL q200_q()
         END IF
       WHEN "help"
          CALL cl_show_help()
        WHEN "exit"
            EXIT WHILE
        WHEN "controlg"
            CALL cl_cmdask()
#FUN-B80153 add START
         WHEN "period_tran"
            IF cl_chk_act_auth() THEN
               IF  l_ac = 0  THEN
                  CONTINUE WHILE
               END IF
               CALL s_aimq102_q1(g_img[l_ac].img01,g_rtz.rtz01,g_img[l_ac].img02,'1')
            END IF
#FUN-B80153 add END
#FUN-B90081 add START
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_img),'','')  
            END IF
#FUN-B90081 add END
      END CASE
   END WHILE
END FUNCTION

FUNCTION q200_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count ) 
    CALL cl_opmsg('q')   
    DISPLAY '   ' TO FORMONLY.cnt 
    CALL q200_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q200_cs
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q200_count
       FETCH q200_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q200_fetch('F')
    END IF
	MESSAGE ''
    CALL cl_set_comp_visible('rta05',FALSE)    #FUN-B80079 add 
END FUNCTION

FUNCTION q200_fetch(p_flag)
DEFINE   p_flag          LIKE type_file.chr1,     #處理方式
         l_sql           STRING  
DEFINE   l_n1            LIKE type_file.num10   #FUN-C70007 add
   DELETE FROM q200_tmp     
   INITIALIZE sr.* TO NULL
   CASE p_flag
        WHEN 'N' FETCH NEXT     q200_cs INTO g_rtz.rtz01,g_rtz.rtz13,g_rtz.rtz12,g_rtz.rtz03
        WHEN 'P' FETCH PREVIOUS q200_cs INTO g_rtz.rtz01,g_rtz.rtz13,g_rtz.rtz12,g_rtz.rtz03
        WHEN 'F' FETCH FIRST    q200_cs INTO g_rtz.rtz01,g_rtz.rtz13,g_rtz.rtz12,g_rtz.rtz03
        WHEN 'L' FETCH LAST     q200_cs INTO g_rtz.rtz01,g_rtz.rtz13,g_rtz.rtz12,g_rtz.rtz03
        WHEN '/'
          IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
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
          FETCH ABSOLUTE g_jump q200_cs INTO g_rtz.rtz01,g_rtz.rtz13,g_rtz.rtz12,g_rtz.rtz03
            LET mi_no_ask = FALSE
    END CASE   
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rtz.rtz01,SQLCA.sqlcode,0)
        INITIALIZE g_rtz.* TO NULL  
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
#FUN-B80079 mark START
  #  LET l_sql=  " SELECT img01,ima02,img02,imd02,img10,img09 FROM ",                 
  #                       cl_get_target_table(g_rtz.rtz01,'img_file'),
  #                       " LEFT OUTER JOIN ",
  #                       cl_get_target_table(g_rtz.rtz01,'ima_file'),
  #                       " ON img01=ima01 ",
  #                       " LEFT OUTER JOIN ",
  #                       cl_get_target_table(g_rtz.rtz01,'imd_file'),
  #                       " ON img02=imd01 ",
  #              "  WHERE imgplant= '",g_rtz.rtz01,"'",
  #              "  AND ",tm.wc2 CLIPPED        
#FUN-B80079 mark END
#FUN-B80079 add START
    LET l_sql=  " SELECT '',img01,ima02,img02,imd02,img10,img09 FROM ",           
                         cl_get_target_table(g_rtz.rtz01,'img_file'),
                         " LEFT OUTER JOIN ",
                         cl_get_target_table(g_rtz.rtz01,'ima_file'),
                         " ON img01=ima01 ",
                         " LEFT OUTER JOIN ",
                         cl_get_target_table(g_rtz.rtz01,'imd_file'),
                         " ON img02=imd01 ",
                         "  WHERE imgplant= '",g_rtz.rtz01,"'",
                         " AND img01 IN ",
                         " (SELECT DISTINCT img01 FROM ",
                         cl_get_target_table(g_rtz.rtz01, 'img_file'),
                        #" OUTER JOIN ",      #MOD-CC0018 mark
                         " LEFT OUTER JOIN ", #MOD-CC0018 add
                         cl_get_target_table(g_rtz.rtz01, 'rta_file'),
                        #" ON  rta01 = img01 AND " ,tm.wc2 CLIPPED,  #MOD-CC0018 mark
                         " ON  img01 = rta01 WHERE ",tm.wc2 CLIPPED, #MOD-CC0018 add
                         " )"
#FUN-B80079 add END
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
    CALL cl_parse_qry_sql(l_sql,g_rtz.rtz01) RETURNING l_sql
    PREPARE q200_p1 FROM l_sql
    DECLARE q200_curs1 CURSOR FOR q200_p1
    FOREACH q200_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
    #   INSERT INTO q200_tmp VALUES(sr.img01,sr.ima02,sr.img02,sr.imd02,sr.img10,sr.img09)                           #FUN-B80079 mark
       INSERT INTO q200_tmp VALUES(sr.rta05,sr.img01,sr.ima02,sr.img02,sr.imd02,sr.img10,sr.img09)                  #FUN-B80079 add
    END FOREACH
    INITIALIZE sr.* TO NULL
    #FUN-C70007 mark sta---
    #LET l_sql = " SELECT PROD,ima02,WNO,imd02,QTY*(-1),UNIT FROM ds_pos1.POSDB ",
    #                                " LEFT OUTER JOIN ",
    #                                cl_get_target_table(g_rtz.rtz01,'ima_file'),
    #                                " ON PROD=ima01 ",
    #                                " LEFT OUTER JOIN ",
    #                                cl_get_target_table(g_rtz.rtz01,'imd_file'),
    #                                " ON WNO =imd01 ",
    #            " WHERE SHOP = '",g_rtz.rtz01,"'",
    #            " AND TRANS_TYPE <> '1' ",
    #            " AND TRANS_FLG <> 'Y' "
    #FUN-C70007 mark end 
    #FUN-C70007 add sta
    CALL q200_pos(g_rtz.rtz01)
    LET l_sql = " SELECT '', CASE WHEN (FeatureNO = ' ' OR FeatureNO IS NULL)  THEN PLUNO ELSE FeatureNO END ,",
                "        ima02,rtz07,imd02,CASE WHEN td_sale.Type IN (1,2) THEN QTY*(-1) ELSE QTY END,UNIT ",
                " FROM ",g_posdbs,"td_Sale_Detail",g_db_links,",",g_posdbs,"td_Sale",g_db_links,",",
                   cl_get_target_table(g_rtz.rtz01,'rtz_file'),	
                   " LEFT OUTER JOIN ",	
                   cl_get_target_table(g_rtz.rtz01,'imd_file'),	" ON rtz07 =imd01 AND imd20 = rtz01 ,",
                   cl_get_target_table(g_rtz.rtz01,'ima_file'),					
			    " WHERE td_Sale.SHOP = '",g_rtz.rtz01,"'",	
                "  AND ((EXISTS (",
                         "SELECT 1 FROM ",cl_get_target_table(g_rtz.rtz01,'imx_file'),
                         " WHERE imx000 = FeatureNO AND imx00 = PLUNO ) AND FeatureNO = ima01) ",
                     "   OR  ((FeatureNO = ' ' OR FeatureNO IS NULL) AND PLUNO =ima01))",    
			    "   AND    td_sale.Type in (1,2,0) ",			
			    "   AND   rtz01 = td_Sale.SHOP ",		
			    "   AND condition2='A'  "	,
                "   AND td_Sale.SHOP = td_Sale_Detail.SHOP AND td_Sale.SALENO = td_Sale_Detail.SALENO "
    #FUN-C70007 add end        
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
    CALL cl_parse_qry_sql(l_sql,g_rtz.rtz01) RETURNING l_sql
    PREPARE q200_p2 FROM l_sql
    DECLARE q200_curs2 CURSOR FOR q200_p2
    FOREACH q200_curs2 INTO sr.* 
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
    #   INSERT INTO q200_tmp VALUES(sr.img01,sr.ima02,sr.img02,sr.imd02,sr.img10,sr.img09)                            #FUN-B80079 mark
       INSERT INTO q200_tmp VALUES(sr.rta05,sr.img01,sr.ima02,sr.img02,sr.imd02,sr.img10,sr.img09)        #FUN-B80079 add 
        
    END FOREACH   

    
    CALL q200_show()
END FUNCTION

FUNCTION q200_show()
   DISPLAY BY NAME g_rtz.*   # 顯示單頭值
   CALL q200_b_fill() #單身
   CALL cl_show_fld_cont()
END FUNCTION


FUNCTION q200_b_fill() 
   DEFINE l_sql     LIKE type_file.chr1000
   
   LET g_rec_b=0
   LET g_cnt = 1
   CALL g_img.clear()
   DECLARE q200_curs3 CURSOR FOR 
  #    SELECT img01,ima02,img02,imd02,SUM(img10),'',img09   #FUN-B40094 add ''        #FUN-B80079 mark
  #     FROM q200_tmp GROUP BY img01,ima02,img02,imd02,img09                          #FUN-B80079 mark
      SELECT rta05,img01,ima02,img02,imd02,SUM(img10),'',img09   #FUN-B40094 add ''  #FUN-B80079 add
       FROM q200_tmp GROUP BY img01,ima02,rta05,img02,imd02,img09                    #FUN-B80079 add 
   FOREACH q200_curs3 INTO g_img[g_cnt].*
       IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       #FUN-B40094 add -------STA-------
       SELECT SUM(oeb905 * oeb05_fac) INTO g_img[g_cnt].oeb905				
         FROM oeb_file,oea_file				
        WHERE oeb04 = g_img[g_cnt].img01 AND oeb01 = oea01 AND 				
              oea00 <> '0' AND oeb19 = 'Y' AND oeb70 = 'N' AND 				
              oeb12 > oeb24 AND oeb09 = g_img[g_cnt].img02			
       IF cl_null(g_img[g_cnt].oeb905) THEN LET g_img[g_cnt].oeb905 = 0 END IF				
       #FUN-B40094 add -------END-------
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
	      EXIT FOREACH
       END IF
   END FOREACH
   CALL g_img.deleteElement(g_cnt)
   LET g_rec_b= g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION

FUNCTION q200_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
   IF p_ud <> "G" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_img TO s_img.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

    #FUN-B80153 add START
     BEFORE ROW
        LET l_ac = ARR_CURR()
    #FUN-B80153 add END

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q200_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
          END IF
          ACCEPT DISPLAY         
 
 
      ON ACTION previous
         CALL q200_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY            
 
 
      ON ACTION jump
         CALL q200_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY           
 
 
      ON ACTION next
         CALL q200_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY            
 
 
      ON ACTION last
         CALL q200_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY            
 
 
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

#FUN-B80153 add START
      ON ACTION period_tran
         LET g_action_choice="period_tran"
         EXIT DISPLAY
#FUN-B80153 add END

#FUN-B90081 add START
      ON ACTION exporttoexcel      
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
#FUN-B90081 add END

      AFTER DISPLAY
         CONTINUE DISPLAY
         
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO") 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#FUN-AB0106       
FUNCTION q200_pos(l_rtz01)
DEFINE l_rtz01    LIKE rtz_file.rtz01
DEFINE l_db_links LIKE ryg_file.ryg02
DEFINE l_ryg00    LIKE ryg_file.ryg00
DEFINE l_ryg02    LIKE ryg_file.ryg02

   SELECT ryg00,ryg02 INTO l_ryg00,l_ryg02 FROM  azw_file,ryg_file 
    WHERE azw01 = ryg01  AND  rygacti = 'Y' AND azw01 = l_rtz01
   LET g_posdbs = s_dbstring(l_ryg00) 
   IF l_ryg02 IS NULL OR l_ryg02 = ' ' THEN
     LET g_db_links = '@dscpos'
   ELSE
     LET g_db_links = '@',l_ryg02 CLIPPED
   END IF
END FUNCTION 
