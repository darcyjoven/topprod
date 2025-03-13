# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: s_gifts.4gl
# Descriptions...:
# Date & Author..:NO.FUN-B30012 11/03/08 By huangtao   
# Input Parameter: p_type   單據別   00-贈品發放單,01-訂單,02-銷售單,03-銷退單  
#                  p_no     單號 
#                  p_plant  機構別
#                  p_date   單據日期
#                  p_oea87  會員編號
# Return code....:
# Modify.........: No:FUN-B20060 11/04/07 By zhangll 增加oeb72赋值
# Modify.........: No:FUN-B60122 11/06/23 By shiwuying 單位取值錯誤
# Modify.........: No:FUN-BB0085 11/11/17 By xianghui 增加數量欄位小數取位
# Modify.........: No:FUN-BC0071 11/12/26 By huangtao  換贈添加券和送抵現值
# Modify.........: No:FUN-BB0086 12/01/29 By tanxc 增加數量欄位小數取位 
# Modify.........: No:TQC-C20379 12/02/22 By huangtao 修改換贈bug
# Modify.........: No:TQC-C20407 12/02/23 By huangtao 修改換贈bug
# Modify.........: No:TQC-C20501 12/02/27 By huangtao 修改換贈bug
# Modify.........: No:TQC-C30064 12/03/03 By pauline 會員卡為可儲值才顯示送抵現值選項
# Modify.........: No:TQC-C30072 12/03/03 By pauline 將換贈券號寫入"禮券銷售明細" rxe_file 
# Modify.........: No:TQC-C50165 12/05/21 By fanbj 隱藏mod_lqw ACTION
# Modify.........: No:TQC-C50167 12/05/21 By fanbj 過濾未確認的料件
# Modify.........: No:TQC-C50148 12/06/08 By yangtt 修改可發贈品bug
# Modify.........: No:FUN-C50097 12/06/13 By SunLM  對非空字段進行判斷ogb50,51,52             
# Modify.......... No:CHI-C80060 12/08/27 By pauline 令oeb72預設值為null
# Modify.........: No:TQC-C60131 12/09/19 By yuhuabao 出貨單帶出可換贈品資料時候，沒有訂單號及訂單項次，但訂單項次默認給0
# Modify.........: No:FUN-C90049 12/10/19 By Lori 預設成本倉與非成本倉改從s_get_defstore取
# Modify.........: No:FUN-CA0152 12/11/13 By xumeimei 基础价格從s_fetch_price_new取

DATABASE ds
GLOBALS "../../config/top.global"
DEFINE g_type        LIKE  rxd_file.rxd00,
       g_no          LIKE  rxd_file.rxd01,  
       g_org         LIKE  azp_file.azp03,   
       g_date        LIKE  type_file.dat,
       g_oea87       LIKE  oea_file.oea87,
        
       g_sql         STRING,

       g_temp        DYNAMIC ARRAY OF RECORD
           num            LIKE type_file.num5,
           sel            LIKE type_file.chr1,
           rxn04          LIKE rxn_file.rxn04,
           rar03          LIKE rar_file.rar03,
           rar02          LIKE rar_file.rar02,
           lqw04          LIKE lqw_file.lqw04,          #FUN-BC0071  add
           lqw05          LIKE lqw_file.lqw05,          #FUN-BC0071  add 
           rah21          LIKE rah_file.rah21,
           rah23          LIKE rah_file.rah23,
           ima01          LIKE ima_file.ima01,
           ima02          LIKE ima_file.ima02,
           rar06          LIKE rar_file.rar06,
           rar07          LIKE rar_file.rar07,
           qty            LIKE type_file.num5,
           qty1           LIKE type_file.num5,
           ras09          LIKE ras_file.ras09,          #FUN-BC0071  add
           lqw08_1        LIKE lqw_file.lqw08           #FUN-BC0071  add
                     END RECORD,
         g_temp_t    RECORD
           num            LIKE type_file.num5,
           sel            LIKE type_file.chr1,
           rxn04          LIKE rxn_file.rxn04,
           rar03          LIKE rar_file.rar03,
           rar02          LIKE rar_file.rar02,
           lqw04          LIKE lqw_file.lqw05,          #FUN-BC0071  add
           lqw05          LIKE lqw_file.lqw06,          #FUN-BC0071  add 
           rah21          LIKE rah_file.rah21,
           rah23          LIKE rah_file.rah23,
           ima01          LIKE ima_file.ima01,
           ima02          LIKE ima_file.ima02,
           rar06          LIKE rar_file.rar06,
           rar07          LIKE rar_file.rar07,
           qty            LIKE type_file.num5,
           qty1           LIKE type_file.num5,
           ras09          LIKE ras_file.ras09,          #FUN-BC0071  add
           lqw08_1        LIKE lqw_file.lqw08           #FUN-BC0071  add
                     END RECORD,
#FUN-BC0071 ------------------STA
         g_lqw        DYNAMIC ARRAY OF RECORD
           lqw07           LIKE lqw_file.lqw07,
           lqw08           LIKE lqw_file.lqw08,
           lqw08_desc      LIKE lpx_file.lpx02,
           lqw09           LIKE lqw_file.lqw09,    
           lqw10           LIKE lqw_file.lqw10, 
           lqw11           LIKE lqw_file.lqw11, 
           lqw11_desc      LIKE lrz_file.lrz02,
           lqw12           LIKE lqw_file.lqw12,
           lqw13           LIKE lqw_file.lqw13
                      END RECORD,

         g_lqw_t      RECORD
           lqw07           LIKE lqw_file.lqw07,
           lqw08           LIKE lqw_file.lqw08,
           lqw08_desc      LIKE lpx_file.lpx02,
           lqw09           LIKE lqw_file.lqw09,    
           lqw10           LIKE lqw_file.lqw10, 
           lqw11           LIKE lqw_file.lqw11, 
           lqw11_desc      LIKE lrz_file.lrz02,
           lqw12           LIKE lqw_file.lqw12,
           lqw13           LIKE lqw_file.lqw13
                      END RECORD
DEFINE l_ac1         LIKE type_file.num5
DEFINE g_rec_b1      LIKE type_file.num5
DEFINE g_flag        LIKE type_file.chr1
DEFINE p_cmd         LIKE type_file.chr1
DEFINE g_lqw_flag    LIKE type_file.chr1
DEFINE g_ins_flag    LIKE type_file.chr1
#FUN-BC0071 ------------------END
        
DEFINE g_rec_b       LIKE type_file.num5
DEFINE l_ac          LIKE type_file.num5
DEFINE l_ac_t        LIKE type_file.num5       #FUN-BC0071  add
DEFINE g_member      LIKE type_file.chr1
DEFINE g_num         LIKE type_file.num5 
DEFINE g_lpj16       LIKE lpj_file.lpj16     #TQC-C30064 add

FUNCTION s_gifts(p_type,p_no,p_plant,p_date,p_oea87)
DEFINE  p_type     LIKE  rxd_file.rxd00,
        p_no       LIKE  rxd_file.rxd01,
        p_plant    LIKE  rxd_file.rxdplant,
        p_date     LIKE  type_file.dat,
        p_oea87    LIKE  oea_file.oea87
DEFINE  l_rxd      RECORD LIKE rxd_file.*
DEFINE  l_oeaconf  LIKE  oea_file.oeaconf
DEFINE  l_ogaconf  LIKE  oga_file.ogaconf
DEFINE  l_rxmconf  LIKE  rxm_file.rxmconf
DEFINE  l_oeb1001  LIKE  oeb_file.oeb1001
DEFINE  l_ogb1001  LIKE  ogb_file.ogb1001
DEFINE  l_oeb03    LIKE  oeb_file.oeb03
DEFINE  l_ogb03    LIKE  ogb_file.ogb03 
DEFINE  l_n        LIKE  type_file.num5

    WHENEVER ERROR CALL cl_err_msg_log
    CALL s_showmsg_init()                  #FUN-BC0071 ADD
   IF cl_null(p_type) OR cl_null(p_no) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   LET g_type = p_type
   LET g_no = p_no
   LET g_org=p_plant
   LET g_date=p_date
   LET g_oea87=p_oea87
   LET g_num = 0
   IF NOT cl_null(g_oea87) THEN 
      LET g_member='Y'
   ELSE 
      LET g_member='N' 
   END IF 
  #TQC-C30064 add START
   IF g_member THEN  #若為會原則判斷此會員卡是否可儲值
      SELECT lpj16 INTO g_lpj16 FROM lpj_file WHERE lpj03 = g_oea87  
   END IF
  #TQC-C30064 add END
   DROP TABLE  s_gifts_tmp;
   CREATE TEMP TABLE  s_gifts_tmp(
           num            LIKE type_file.num5,
           sel            LIKE type_file.chr1,
           rxn04          LIKE rxn_file.rxn04,
           rar03          LIKE rar_file.rar03,
           rar02          LIKE rar_file.rar02,
           lqw04          LIKE lqw_file.lqw04,          #FUN-BC0071  add
           lqw05          LIKE lqw_file.lqw05,          #FUN-BC0071  add 
           rah21          LIKE rah_file.rah21,
           rah23          LIKE rah_file.rah23,
           ima01          LIKE ima_file.ima01,
           ima02          LIKE ima_file.ima02,
           ras08          LIKE ras_file.ras08,
           rar06          LIKE rar_file.rar06,
           rar07          LIKE rar_file.rar07,
           qty            LIKE type_file.num5,
           qty1           LIKE type_file.num5,
           ras09          LIKE ras_file.ras09,          #FUN-BC0071  add
           lqw08_1        LIKE lqw_file.lqw08);         #FUN-BC0071  add
   DELETE FROM  s_gifts_tmp WHERE 1=1;
   
   CALL g_temp.clear()
    IF g_type = '01' OR g_type = '02' THEN
       IF cl_null(g_oaz.oaz88) THEN
          CALL cl_err('','axm-837',0)
          RETURN
       END IF  
    END IF
#FUN-BC0071 ------------------STA    
    OPEN WINDOW s_gifts_w AT 10,20 WITH FORM "sub/42f/s_gifts"
          ATTRIBUTE(STYLE=g_win_style)

    CALL cl_ui_locale("s_gifts")
    CALL cl_set_comp_visible("s_lqw",FALSE)           
    CALL cl_set_comp_visible("num",FALSE)  
    IF g_type = '00' THEN
       CALL cl_set_comp_visible("rxn04",TRUE)
    ELSE
       CALL cl_set_comp_visible("rxn04",FALSE) 
    END IF 
##FUN-BC0071 ------------------END
      
    IF g_type = '01' OR g_type = '02' THEN
       LET g_sql = " SELECT * FROM rxd_file ",
                   " WHERE rxd00 = '",p_type,"'",
                   " AND rxd01 = '",p_no,"'"
    END IF
    IF g_type = '00' THEN
       LET g_sql = " SELECT * FROM rxd_file ",
                    " WHERE rxd00 = '02' ",
                    " AND rxd01 IN (SELECT rxn04 FROM rxn_file ",
                                    " WHERE rxn00 = '1' ",
                                    " AND rxn01 = '",p_no,"'",
                                    " AND rxnplant = '",g_org,"')"
    END IF  
    PREPARE pre_rxd_file FROM g_sql
    DECLARE sel_rxd_file CURSOR FOR pre_rxd_file
    FOREACH sel_rxd_file INTO l_rxd.*
       IF g_type = '01' THEN
          SELECT oeaconf INTO l_oeaconf FROM oea_file
           WHERE oea01 = l_rxd.rxd01
           IF l_oeaconf = 'Y' OR l_oeaconf = 'X' THEN
               CALL cl_err('','art-370',0)
               CLOSE WINDOW s_gifts_w
               RETURN
           END IF
           SELECT COUNT(*) INTO l_n FROM oeb_file 
             WHERE oeb01 =  l_rxd.rxd01
               AND oeb1001 = g_oaz.oaz88
           IF l_n> 0 THEN
                 IF cl_confirm('art-808') THEN
#FUN-BC0071 -----------------STA
                    DELETE FROM lqw_file WHERE lqw00 = g_type AND lqw01 = g_no   
                    #FUN-CA0152---------mark----str
                    #SELECT oeb03 INTO l_oeb03 FROM oeb_file 
                    # WHERE oeb01 = l_rxd.rxd01 AND oeb1001 = g_oaz.oaz88 AND oeb04 = 'MISCCARD'
                    #IF STATUS = 0 AND NOT cl_null(l_oeb03) THEN
                    #   DELETE FROM rxc_file WHERE rxc00 =g_type AND rxc01 = g_no AND rxc02 = l_oeb03
                    #END IF
                    #FUN-CA0152---------mark----end
#FUN-BC0071 -----------------END   
                    #FUN-CA0152---------add-----str
                    DELETE FROM rxc_file 
                     WHERE rxc00 =g_type
                       AND rxc01 = g_no
                       AND rxc02 IN (SELECT oeb03 FROM oeb_file
                                      WHERE oeb01 = l_rxd.rxd01
                                        AND oeb1001 = g_oaz.oaz88)
                    #FUN-CA0152---------add-----end
                    DELETE FROM oeb_file WHERE oeb01 = l_rxd.rxd01
                                           AND oeb1001 = g_oaz.oaz88
                 ELSE
                    CLOSE WINDOW s_gifts_w
                    RETURN
                 END IF
           END IF
       END IF

       IF g_type = '02' THEN
          SELECT ogaconf INTO l_ogaconf FROM oga_file
           WHERE oga01 = l_rxd.rxd01
           IF l_ogaconf = 'Y' OR l_ogaconf ='X' THEN
               CALL cl_err('','art-370',0)
               CLOSE WINDOW s_gifts_w
               RETURN
           END IF
           SELECT COUNT(*) INTO l_n FROM ogb_file
            WHERE ogb01 = l_rxd.rxd01
              AND (ogb31 = ' ' OR ogb31 IS NULL)
              AND  ogb1001 = g_oaz.oaz88
            IF l_n > 0 THEN
                  IF cl_confirm('art-808') THEN
#FUN-BC0071 ---------------------STA
                      DELETE FROM lqw_file WHERE lqw00 = g_type AND lqw01 = g_no   
                      #FUN-CA0152---------mark----str
                      #SELECT ogb03 INTO l_ogb03 FROM ogb_file 
                      # WHERE ogb01 = l_rxd.rxd01 AND ogb1001 = g_oaz.oaz88  
                      #IF STATUS = 0 AND NOT cl_null(l_ogb03) THEN
                      #   DELETE FROM rxc_file WHERE rxc00 =g_type AND rxc01 = g_no AND rxc02 = l_ogb03
                      #END IF
                      #FUN-CA0152---------mark----end
#FUN-BC0071 ---------------------END
                      #FUN-CA0152---------add-----str
                      DELETE FROM rxc_file 
                       WHERE rxc00 =g_type 
                         AND rxc01 = g_no 
                         AND rxc02 IN (SELECT ogb03 FROM ogb_file
                                        WHERE ogb01 = l_rxd.rxd01
                                          AND ogb1001 = g_oaz.oaz88)
                      #FUN-CA0152---------add-----end
                      DELETE FROM ogb_file WHERE ogb01 = l_rxd.rxd01
                                             AND ogb1001 = g_oaz.oaz88
                      DELETE FROM rxe_file WHERE rxe01 = g_no  #TQC-C30072 add
                  ELSE
                      CLOSE WINDOW s_gifts_w
                      RETURN
                  END IF
            END IF
        END IF
        IF g_type = '00' THEN
          SELECT rxmconf INTO l_rxmconf FROM rxm_file
           WHERE rxm00 = '1'
             AND rxm01 = g_no
             AND rxmplant = g_org
          IF l_rxmconf = 'Y' OR l_rxmconf = 'X' THEN
             CALL cl_err('','art-370',0)
             CLOSE WINDOW s_gifts_w
             RETURN
          END IF
          SELECT COUNT(*) INTO l_n FROM rxo_file
           WHERE rxo01 = g_no
             AND rxo00 = '1'
             AND rxoplant = g_org
            IF l_n > 0 THEN
                IF cl_confirm('art-808') THEN
                    DELETE FROM rxo_file WHERE rxo01 = g_no
                                           AND rxo00 = '1'
                                           AND rxoplant = g_org
                    DELETE FROM lqw_file WHERE lqw00 = g_type AND lqw01 = g_no   #FUN-BC0071 add
                ELSE
                    CLOSE WINDOW s_gifts_w
                    RETURN
                END IF
            END IF
        END IF
    #FUN-BC0071 -------------mark ------------begin    
    #   OPEN WINDOW s_gifts_w AT 10,20 WITH FORM "sub/42f/s_gifts"
    #      ATTRIBUTE(STYLE=g_win_style)

    #    CALL cl_ui_locale("s_gifts")
    #    CALL cl_set_comp_visible("num",FALSE)  
    #    IF g_type = '00' THEN
    #       CALL cl_set_comp_visible("rxn04",TRUE)
    #    ELSE
    #       CALL cl_set_comp_visible("rxn04",FALSE) 
    #    END IF 
    #FUN-BC0071 -------------mark-------------end
       IF l_rxd.rxd02 = '2' THEN
          CALL s_gifts_303(g_type,l_rxd.rxd01,l_rxd.rxd03,l_rxd.rxd05,l_rxd.rxdplant)
       END IF
       IF l_rxd.rxd02 = '3' THEN
          CALL s_gifts_304(g_type,l_rxd.rxd01,l_rxd.rxd03,l_rxd.rxd04,l_rxd.rxdplant)
       END IF
    END FOREACH
    LET g_ins_flag = 'Y'         #FUN-BC0071 add
    LET g_lqw_flag = 'N'         #FUN-BC0071 add
    LET l_ac_t = 1               #FUN-BC0071 add
    CALL s_gifts_b_fill()
    WHILE TRUE
      IF g_lqw_flag = 'N' THEN
         CALL s_gifts_i()
         IF g_lqw_flag = 'N' THEN
            EXIT WHILE
         END IF
      ELSE
         IF l_ac > 0 THEN                  #FUN-CA0152 add
            CALL g_lqw.clear()             #TQC-C20501 
            CALL s_lqw_b_fill()
            CALL s_lqw_show()
            CALL s_lqw_b()
            CONTINUE WHILE
         ELSE                              #FUN-CA0152 add
            EXIT WHILE                     #FUN-CA0152 add
         END IF                            #FUN-CA0152 add
      END IF
    END WHILE

    IF g_ins_flag = 'Y' THEN
      #將勾選的資料新增到訂單單身/出貨單單身/贈品發放單單身二
       IF g_type = '01' THEN
          CALL ins_oeb()
       END IF
       IF g_type = '02' THEN
          CALL ins_ogb()
       END IF
       IF g_type = '00' THEN
          CALL ins_rxo()
       END IF
    ELSE
       DELETE FROM lqw_file WHERE lqw00 = g_type AND lqw01 = g_no
    END IF
    DROP TABLE s_gifts_tmp
   
   CLOSE WINDOW s_gifts_w

END FUNCTION  

FUNCTION s_gifts_303(p_type,p_rxd01,p_rxd03,p_rxd05,p_rxdplant )
DEFINE  p_type     LIKE  rxd_file.rxd00
DEFINE  p_rxd01    LIKE  rxd_file.rxd01
DEFINE  p_rxd03    LIKE  rxd_file.rxd03
DEFINE  p_rxd05    LIKE  rxd_file.rxd05
DEFINE  p_rxdplant LIKE  rxd_file.rxdplant

DEFINE  l_type     LIKE  rxd_file.rxd00
DEFINE  l_rxd01    LIKE  rxd_file.rxd01
DEFINE  l_rxd03    LIKE  rxd_file.rxd03
DEFINE  l_rxd05    LIKE  rxd_file.rxd05
DEFINE  l_rxdplant LIKE  rxd_file.rxdplant

DEFINE  l_rae      RECORD LIKE rae_file.*
DEFINE  l_sql      STRING
DEFINE  l_sql1     STRING                         #FUN-BC0071 add
DEFINE  l_length   LIKE type_file.num5            #FUN-BC0071 add
DEFINE  l_rar05    LIKE rar_file.rar05
DEFINE  l_rar06    LIKE rar_file.rar06
DEFINE  l_rar07    LIKE rar_file.rar07
DEFINE  l_rar08    LIKE rar_file.rar08
DEFINE  l_ras06    LIKE ras_file.ras06
DEFINE  l_ras07    LIKE ras_file.ras07
DEFINE  l_ima01    LIKE ima_file.ima01
DEFINE  l_ima02    LIKE ima_file.ima02
DEFINE  l_flag     LIKE type_file.num5
DEFINE  l_rtz04    LIKE rtz_file.rtz04
DEFINE  l_except   LIKE type_file.num5
DEFINE  l_rte04    LIKE rte_file.rte04
DEFINE  l_rte05    LIKE rte_file.rte05
DEFINE  l_rte06    LIKE rte_file.rte06
DEFINE  l_qty      LIKE type_file.num5
DEFINE  l_qty1     LIKE type_file.num5
DEFINE  l_addmoney LIKE rar_file.rar07
DEFINE  l_oga87    LIKE oga_file.oga87
DEFINE  l_ras08    LIKE ras_file.ras08
DEFINE  l_tqa05    LIKE tqa_file.tqa05
DEFINE  l_tqa06    LIKE tqa_file.tqa06
DEFINE  l_rtz05    LIKE rtz_file.rtz05
DEFINE  l_lpx32    LIKE lpx_file.lpx32            #FUN-BC0071 add
DEFINE  l_ras09    LIKE ras_file.ras09            #FUN-BC0071 add
DEFINE  l_lqw08    LIKE lqw_file.lqw08            #FUN-BC0071 add
DEFINE  l_member   LIKE oea_file.oea87            #FUN-BC0071 add 

   LET l_type = p_type 
   LET l_rxd01 = p_rxd01
   LET l_rxd03 = p_rxd03
   LET l_rxd05 =  p_rxd05 
   LET l_rxdplant = p_rxdplant
   
   
   SELECT * INTO l_rae.* FROM rae_file
    WHERE rae02 = l_rxd03 AND raeplant = l_rxdplant
    IF cl_null(l_rae.rae31) THEN
       LET l_rae.rae31 = 0
    END IF
   IF (l_type = '01' OR l_type = '02') AND l_rae.rae28 = '2' THEN
      RETURN
   END IF
   IF l_type = '00' AND l_rae.rae28 = '1' THEN
      RETURN
   END IF 
   LET l_sql =  " SELECT rar05,rar06,rar07,rar08 FROM rar_file ",
                " WHERE rar02 = '",l_rxd03,"'",
                " AND rar03 = '2' ",
                " AND rarplant = '",l_rxdplant,"'"
   PREPARE pre_rar_file1 FROM l_sql
   DECLARE sel_rar_file1 CURSOR FOR pre_rar_file1
    FOREACH sel_rar_file1 INTO l_rar05,l_rar06,l_rar07,l_rar08
        LET l_sql = " SELECT ras06,ras07 FROM ras_file ",
                    " WHERE ras02 = '",l_rxd03,"'",
                     " AND ras03 = '2'",
                     " AND ras05 = '",l_rar05,"'",
                     " AND rasplant = '",l_rxdplant,"'"
        PREPARE pre_ras_file1 FROM l_sql
        DECLARE sel_ras_file1 CURSOR FOR pre_ras_file1
        #LET l_sql = " SELECT ima01,ima02 FROM ima_file WHERE 1=1 "                  #TQC-C50167 mark
        LET l_sql = " SELECT ima01,ima02 FROM ima_file WHERE 1=1 AND ima1010 = '1' " #TQC-C50167 add
        LET l_length = l_sql.getLength()
        LET l_sql1 = ""                                     #FUN-BC0071 add
        FOREACH sel_ras_file1 INTO l_ras06,l_ras07
           IF l_ras06 = '01' THEN
              LET l_sql = l_sql," AND ima01 = '",l_ras07,"'"
           END IF
           IF l_ras06 = '02' THEN
              LET l_sql = l_sql," AND ima131 = '",l_ras07,"'"
           END IF
           IF l_ras06 = '03' THEN
              LET l_sql = l_sql," AND ima1004 = '",l_ras07,"'"
           END IF
           IF l_ras06 = '04' THEN
              LET l_sql = l_sql," AND ima1005 = '",l_ras07,"'"
           END IF
           IF l_ras06 = '05' THEN
              LET l_sql = l_sql," AND ima1006 = '",l_ras07,"'"
           END IF
           IF l_ras06 = '06' THEN
              LET l_sql = l_sql," AND ima1007 = '",l_ras07,"'"
           END IF 
           IF l_ras06 = '07' THEN
              LET l_sql = l_sql," AND ima1008 = '",l_ras07,"'"
           END IF 
           IF l_ras06 = '08' THEN
              LET l_sql = l_sql," AND ima1009 = '",l_ras07,"'"
           END IF 
           IF l_ras06 = '09' THEN
              SELECT tqa05,tqa06 INTO l_tqa05,l_tqa06 FROM tqa_file
               WHERE tqa01 = l_ras07 AND tqa03 = '27'
              SELECT rtz05 INTO l_rtz05 FROM rtz_file
               WHERE rtz01= g_org
              LET l_sql = l_sql," AND ima01 IN (SELECT rtg03 FROM rtg_file ",
                                                " WHERE rtg01= '",l_rtz05,"'",
                                                " rtg05 <= '",l_tqa06,"'",
                                                " rtg04 >= '",l_tqa05,"')"
           END IF 
#FUN-BC0071 -----------------------STA
           IF l_ras06 = '10' THEN
              SELECT lpx32 INTO l_lpx32 FROM lpx_file 
               WHERE lpx01 = l_ras07 
               LET l_sql = l_sql," AND ima01 = '",l_lpx32,"'"
           END IF

           IF l_ras06 = '11' THEN
              LET l_sql1 = " AND ras07 = 'MISCCARD'"
           END IF
#FUN-BC0071 -----------------------END
           
        END FOREACH
         IF l_rae.rae29 = '1' THEN
              LET l_qty = 1
              LET l_qty1 = 1
           ELSE
              LET l_qty = l_rxd05
              LET l_qty1 = l_qty
           END IF
           IF l_type = '01' OR l_type = '02' THEN
              IF g_member = 'Y' THEN
                 LET l_addmoney  = l_rar08*l_qty
              ELSE
                 LET l_addmoney  = l_rar07*l_qty
              END IF
           END IF
           IF l_type = '00' THEN
              SELECT oga87 INTO l_oga87 FROM oga_file 
               WHERE oga01 = l_rxd01
              IF NOT cl_null(l_oga87 ) THEN
                 LET l_addmoney  = l_rar08*l_qty
              ELSE
                 LET l_addmoney  = l_rar07*l_qty
              END IF
           END IF
#FUN-BC0071 -----------------------STA
        IF NOT cl_null(l_sql1) THEN
          #IF l_sql.getLength() = l_length THEN   #TQC-C30064 mark
           IF l_sql.getLength() = l_length AND g_lpj16 = 'Y' THEN  #TQC-C30064 add
              LET l_sql = " SELECT ras08,ras09 FROM ras_file ",        
                          " WHERE ras02 = '",l_rxd03,"'",
                          " AND ras03 = '2'",
                          " AND ras05 = '",l_rar05,"'",
                          " AND rasplant = '",l_rxdplant,"'",
                          " AND ras06 = '11' ",l_sql1
              PREPARE sel_ras_pre FROM l_sql
              EXECUTE sel_ras_pre INTO l_ras08,l_ras09        
              IF cl_null(l_ras09) THEN
                 LET l_ras09 = 0
              END IF
             
              IF cl_null(g_oea87) THEN
                 CONTINUE FOREACH
              END IF
              SELECT MAX(num)+1 INTO g_num FROM s_gifts_tmp
              IF cl_null(g_num) THEN LET g_num = 1 END IF
              INSERT INTO s_gifts_tmp VALUES (g_num,'N',l_rxd01,'2',l_rxd03,0,l_rar05,l_rae.rae29,l_rae.rae31,
                                            'MISCCARD',g_oea87,l_ras08,l_rar06*l_qty,l_addmoney,l_qty,l_qty1,l_ras09,' ')
           END IF
        ELSE
#FUN-BC0071 -----------------------END         
           PREPARE pre_ima_file1 FROM l_sql
           DECLARE sel_ima_file1 CURSOR FOR pre_ima_file1
           FOREACH sel_ima_file1 INTO l_ima01,l_ima02
              LET l_ras08 = ''
              LET l_ras09 = ''
              CALL s_rtz04_except(g_org) RETURNING l_flag,l_rtz04
              CALL s_prod_strategy( l_ima01,l_rtz04,g_org )
                   RETURNING  l_except,l_rte04, l_rte05, l_rte06
              IF l_flag THEN
                 IF NOT l_except THEN
                    CONTINUE FOREACH
                 END IF
              END IF   
              LET l_sql = " SELECT ras08,ras09 FROM ras_file ",        #FUN-BC0071 add ras09
                          " WHERE ras02 = '",l_rxd03,"'",
                          " AND ras03 = '2'",
                          " AND ras05 = '",l_rar05,"'",
                          " AND rasplant = '",l_rxdplant,"'",
                          " AND ras06 = '01' ",
                          " AND ras07 = '",l_ima01,"'"
              PREPARE pre_ima_num1 FROM l_sql
              EXECUTE  pre_ima_num1 INTO l_ras08,l_ras09          #FUN-BC0071 add l_ras09
              IF cl_null(l_ras08) THEN
                 #SELECT ima25 INTO l_ras08 FROM ima_file #FUN-B60122
                 SELECT ima31 INTO l_ras08 FROM ima_file #FUN-B60122
                  WHERE ima01 = l_ima01
              END IF
#FUN-BC0071 --------------STA
              IF cl_null(l_ras09) THEN
                 LET l_ras09 = 0
              END IF
              LET l_sql = " SELECT ras07 FROM ras_file ",
                          " WHERE ras02 = '",l_rxd03,"'",
                          " AND ras03 = '2'",
                          " AND ras05 = '",l_rar05,"'",
                          " AND ras04 = 0 ",
                          " AND rasplant = '",l_rxdplant,"'",
                          " AND ras06 = '10' "
              PREPARE pre_sel_lqw08 FROM l_sql
              EXECUTE pre_sel_lqw08 INTO l_lqw08 
              IF STATUS = 100 OR cl_null(l_lqw08) THEN
                 LET l_lqw08 = ' '
              END IF
#FUN-BC0071 --------------END
              LET g_num = g_num + 1
#FUN-BC0071 --------------STA
#             INSERT INTO s_gifts_tmp VALUES (g_num,'N',l_rxd01,'2',l_rxd03,l_rae.rae29,l_rae.rae31,
#                                          l_ima01,l_ima02,l_ras08,l_rar06*l_qty,l_addmoney,l_qty,l_qty1)
              INSERT INTO s_gifts_tmp VALUES (g_num,'N',l_rxd01,'2',l_rxd03,0,l_rar05,l_rae.rae29,l_rae.rae31,
                                            l_ima01,l_ima02,l_ras08,l_rar06*l_qty,l_addmoney,l_qty,l_qty1,l_ras09,l_lqw08)
#FUN-BC0071 --------------END
           END FOREACH  
        END IF                    #FUN-BC0071 add    
    END FOREACH
   

END FUNCTION


FUNCTION s_gifts_304(p_type,p_rxd01,p_rxd03,p_rxd04,p_rxdplant )
DEFINE  p_type     LIKE  rxd_file.rxd00
DEFINE  p_rxd01    LIKE  rxd_file.rxd01
DEFINE  p_rxd03    LIKE  rxd_file.rxd03
DEFINE  p_rxd04    LIKE  rxd_file.rxd04
DEFINE  p_rxdplant LIKE  rxd_file.rxdplant

DEFINE  l_type     LIKE  rxd_file.rxd00
DEFINE  l_rxd01    LIKE  rxd_file.rxd01
DEFINE  l_rxd03    LIKE  rxd_file.rxd03
DEFINE  l_rxd04    LIKE  rxd_file.rxd04
DEFINE  l_rxdplant LIKE  rxd_file.rxdplant

DEFINE  l_rah      RECORD LIKE rah_file.*
DEFINE  l_sql      STRING
DEFINE  l_sql1     STRING                         #FUN-BC0071 add
DEFINE  l_length   LIKE type_file.num5            #FUN-BC0071 add
DEFINE  l_rar04    LIKE rar_file.rar04
DEFINE  l_rar05    LIKE rar_file.rar05
DEFINE  l_rar06    LIKE rar_file.rar06
DEFINE  l_rar07    LIKE rar_file.rar07
DEFINE  l_rar08    LIKE rar_file.rar08
DEFINE  l_ras06    LIKE ras_file.ras06
DEFINE  l_ras07    LIKE ras_file.ras07
DEFINE  l_ima01    LIKE ima_file.ima01
DEFINE  l_ima02    LIKE ima_file.ima02
DEFINE  l_ras08    LIKE ras_file.ras08
DEFINE  l_flag     LIKE type_file.num5
DEFINE  l_rtz04    LIKE rtz_file.rtz04
DEFINE  l_except   LIKE type_file.num5
DEFINE  l_rte04    LIKE rte_file.rte04
DEFINE  l_rte05    LIKE rte_file.rte05
DEFINE  l_rte06    LIKE rte_file.rte06
DEFINE  l_qty      LIKE type_file.num5
DEFINE  l_qty1     LIKE type_file.num5
DEFINE  l_addmoney LIKE rar_file.rar07
DEFINE  l_oga87    LIKE oga_file.oga87
DEFINE  l_rai04    LIKE rai_file.rai04
DEFINE  l_rai04_1  LIKE rai_file.rai04
DEFINE  l_tqa05    LIKE tqa_file.tqa05
DEFINE  l_tqa06    LIKE tqa_file.tqa06
DEFINE  l_rtz05    LIKE rtz_file.rtz05
DEFINE  l_lpx32    LIKE lpx_file.lpx32            #FUN-BC0071 add
DEFINE  l_ras09    LIKE ras_file.ras09            #FUN-BC0071 add
DEFINE  l_lqw08    LIKE lqw_file.lqw08            #FUN-BC0071 add


   LET l_type = p_type
   LET l_rxd01 = p_rxd01 
   LET l_rxd03 = p_rxd03
   LET l_rxd04 =  p_rxd04 
   LET l_rxdplant = p_rxdplant
   SELECT * INTO l_rah.* FROM rah_file
    WHERE rah02 = l_rxd03 AND rahplant = l_rxdplant
    IF cl_null(l_rah.rah23) THEN
       LET l_rah.rah23 = 0
    END IF
   IF (l_type = '01' OR l_type = '02') AND l_rah.rah20 = '2' THEN
      RETURN
   END IF
   IF l_type = '00' AND l_rah.rah20 = '1' THEN
      RETURN
   END IF 

   LET l_sql =  " SELECT rar04,rar05,rar06,rar07,rar08 FROM rar_file ",
                " WHERE rar02 = '",l_rxd03,"'",
                " AND rar03 = '3' ",
                " AND rarplant = '",l_rxdplant,"'"
   IF l_rah.rah12 = 'N' THEN
      LET l_sql = l_sql," AND rar04 IN (SELECT MAX(rai03) FROM rai_file WHERE rai02 = '",l_rxd03,"'",
                                                           " AND rai04 <= '",l_rxd04,"'",
                                                           " AND raiplant = '",l_rxdplant,"')"
   ELSE
      LET l_sql = l_sql," AND rar04 IN (SELECT rai03 FROM rai_file WHERE rai02 = '",l_rxd03,"'",
                                                           " AND rai04 <= '",l_rxd04,"'",
                                                           " AND raiplant = '",l_rxdplant,"')"
   END IF
   LET l_sql = l_sql," ORDER BY rar04 "
   
   PREPARE pre_rar_file2 FROM l_sql
   DECLARE sel_rar_file2 CURSOR FOR pre_rar_file2
   FOREACH sel_rar_file2 INTO l_rar04,l_rar05,l_rar06,l_rar07,l_rar08
       LET l_sql = " SELECT ras06,ras07 FROM ras_file ",
                    " WHERE ras02 = '",l_rxd03,"'",
                     " AND ras03 = '3'",
                     " AND ras04 = '",l_rar04,"'",
                     " AND ras05 = '",l_rar05,"'",
                     " AND rasplant = '",l_rxdplant,"'"
        PREPARE pre_ras_file2 FROM l_sql
        DECLARE sel_ras_file2 CURSOR FOR pre_ras_file2
        #LET l_sql = " SELECT ima01,ima02 FROM ima_file WHERE 1=1 "                  #TQC-C50167 mark
        LET l_sql = " SELECT ima01,ima02 FROM ima_file WHERE 1=1 AND ima1010 = '1' " #TQC-C50167 add      
        LET l_length = l_sql.getLength()
        LET l_sql1 = ""                                     #FUN-BC0071 add
        FOREACH sel_ras_file2 INTO l_ras06,l_ras07
           IF l_ras06 = '01' THEN
              LET l_sql = l_sql," AND ima01 = '",l_ras07,"'"
           END IF
           IF l_ras06 = '02' THEN
              LET l_sql = l_sql," AND ima131 = '",l_ras07,"'"
           END IF
           IF l_ras06 = '03' THEN
              LET l_sql = l_sql," AND ima1004 = '",l_ras07,"'"
           END IF
           IF l_ras06 = '04' THEN
              LET l_sql = l_sql," AND ima1005 = '",l_ras07,"'"
           END IF
           IF l_ras06 = '05' THEN
              LET l_sql = l_sql," AND ima1006 = '",l_ras07,"'"
           END IF
           IF l_ras06 = '06' THEN
              LET l_sql = l_sql," AND ima1007 = '",l_ras07,"'"
           END IF 
           IF l_ras06 = '07' THEN
              LET l_sql = l_sql," AND ima1008 = '",l_ras07,"'"
           END IF 
           IF l_ras06 = '08' THEN
              LET l_sql = l_sql," AND ima1009 = '",l_ras07,"'"
           END IF 
           IF l_ras06 = '09' THEN
              SELECT tqa05,tqa06 INTO l_tqa05,l_tqa06 FROM tqa_file
               WHERE tqa01 = l_ras07 AND tqa03 = '27'
              SELECT rtz05 INTO l_rtz05 FROM rtz_file
               WHERE rtz01= g_org
              LET l_sql = l_sql," AND ima01 IN (SELECT rtg03 FROM rtg_file ",
                                                " WHERE rtg01= '",l_rtz05,"'",
                                                " rtg05 <= '",l_tqa06,"'",
                                                " rtg04 >= '",l_tqa05,"')"
           END IF 
           
#FUN-BC0071 -----------------------STA
           IF l_ras06 = '10' THEN
              SELECT lpx32 INTO l_lpx32 FROM lpx_file 
               WHERE lpx01 = l_ras07 
               LET l_sql = l_sql," AND ima01 = '",l_lpx32,"'"
           END IF

           IF l_ras06 = '11' THEN
              LET l_sql1 = " AND ras07 = 'MISCCARD'"
           END IF
#FUN-BC0071 -----------------------END
        END FOREACH

        IF l_rah.rah21 = '1' THEN
           LET l_qty = 1
           LET l_qty1 = 1
        ELSE
           SELECT rai04 INTO l_rai04 FROM rai_file 
            WHERE rai02 = l_rxd03
              AND rai03 = l_rar04
              AND raiplant = l_rxdplant
           SELECT MAX(rai04) INTO l_rai04_1 FROM rai_file 
            WHERE rai02 = l_rxd03
              AND rai04 <= l_rxd04
              AND raiplant = l_rxdplant
           IF l_rah.rah12 = 'N' THEN
              LET l_qty  = l_rxd04/l_rai04
              LET l_qty1 = l_qty
           ELSE
              IF l_rai04 = l_rai04_1 THEN
                 LET l_qty  = l_rxd04/l_rai04
                 LET l_qty1 = l_qty
              ELSE
                 LET l_qty = 1
                 LET l_qty1 = 1
              END IF
            END IF
        END IF
        IF l_type = '01' OR l_type = '02' THEN
           IF g_member = 'Y' THEN
              LET l_addmoney  = l_rar08*l_qty
           ELSE
              LET l_addmoney  = l_rar07*l_qty
           END IF
        END IF
        IF l_type = '00' THEN
           SELECT oga87 INTO l_oga87 FROM oga_file 
            WHERE oga01 = l_rxd01
            IF NOT cl_null(l_oga87 ) THEN
               LET l_addmoney  = l_rar08*l_qty
            ELSE
               LET l_addmoney  = l_rar07*l_qty
            END IF
        END IF   
#FUN-BC0071 -----------------------STA
        IF NOT cl_null(l_sql1) THEN
          #IF l_sql.getLength() = l_length THEN  #TQC-C30064 mark
           IF l_sql.getLength() = l_length AND g_lpj16 = 'Y' THEN  #TQC-C30064 add
              LET l_sql = " SELECT ras08,ras09 FROM ras_file ",        
                          " WHERE ras02 = '",l_rxd03,"'",
                          " AND ras03 = '3'",
                          " AND ras04 = '",l_rar04,"'",
                          " AND ras05 = '",l_rar05,"'",
                          " AND rasplant = '",l_rxdplant,"'",
                          " AND ras06 = '11' ",l_sql1
              PREPARE sel_ras_pre1 FROM l_sql
              EXECUTE sel_ras_pre1 INTO l_ras08,l_ras09        
              IF cl_null(l_ras09) THEN
                 LET l_ras09 = 0
              END IF
         
              IF cl_null(g_oea87) THEN
                 CONTINUE FOREACH
              END IF
              SELECT MAX(num)+1 INTO g_num FROM s_gifts_tmp
              IF cl_null(g_num) THEN LET g_num = 1 END IF
              INSERT INTO s_gifts_tmp VALUES (g_num,'N',l_rxd01,'3',l_rxd03,l_rar04,l_rar05,l_rah.rah21,l_rah.rah23,
                                            'MISCCARD',g_oea87,l_ras08,l_rar06*l_qty,l_addmoney,l_qty,l_qty1,l_ras09,' ')
           END IF
        ELSE
#FUN-BC0071 -----------------------END   
        PREPARE pre_ima_file2 FROM l_sql
        DECLARE sel_ima_file2 CURSOR FOR pre_ima_file2
        FOREACH sel_ima_file2 INTO l_ima01,l_ima02
           LET l_ras08 = ''
           LET l_ras09 = ''
           CALL s_rtz04_except(g_org) RETURNING l_flag,l_rtz04
           CALL s_prod_strategy( l_ima01,l_rtz04,g_org )
                RETURNING  l_except,l_rte04, l_rte05, l_rte06
           IF l_flag THEN
              IF NOT l_except THEN
                CONTINUE FOREACH
              END IF
           END IF
           LET l_sql = " SELECT ras08,ras09 FROM ras_file ",            #FUN-BC0071 add ras09
                       " WHERE ras02 = '",l_rxd03,"'",
                       " AND ras03 = '3'",
                       " AND ras04 = '",l_rar04,"'",
                       " AND ras05 = '",l_rar05,"'",
                       " AND rasplant = '",l_rxdplant,"'",
                       " AND ras06 = '01' ",
                       " AND ras07 = '",l_ima01,"'"
           PREPARE pre_ima_num2 FROM l_sql
           EXECUTE  pre_ima_num2 INTO l_ras08,l_ras09                  #FUN-BC0071 add ras09 
           IF cl_null(l_ras08) THEN
             #SELECT ima25 INTO l_ras08 FROM ima_file #FUN-B60122
              SELECT ima31 INTO l_ras08 FROM ima_file #FUN-B60122
               WHERE ima01 = l_ima01
           END IF
#FUN-BC0071 --------------STA
           IF cl_null(l_ras09) THEN
              LET l_ras09 = 0
           END IF
           LET l_sql = " SELECT ras07 FROM ras_file ",
                       " WHERE ras02 = '",l_rxd03,"'",
                       " AND ras03 = '3'",
                       " AND ras05 = '",l_rar05,"'",
                       " AND ras04 = '",l_rar04,"'",
                       " AND rasplant = '",l_rxdplant,"'",
                       " AND ras06 = '10' "
          PREPARE pre_sel_lqw08_1 FROM l_sql
          EXECUTE pre_sel_lqw08_1 INTO l_lqw08 
          IF STATUS = 100 OR cl_null(l_lqw08) THEN
             LET l_lqw08 = ' '
          END IF
#FUN-BC0071 --------------END
           LET g_num = g_num +1
#FUN-BC0071 --------------STA
#           INSERT INTO s_gifts_tmp VALUES (g_num,'N',l_rxd01,'3',l_rxd03,l_rah.rah21,l_rah.rah23,
#                                         l_ima01,l_ima02,l_ras08,l_rar06*l_qty,l_addmoney,l_qty,l_qty1)
            INSERT INTO s_gifts_tmp VALUES (g_num,'N',l_rxd01,'3',l_rxd03,l_rar04,l_rar05,l_rah.rah21,l_rah.rah23,
                                          l_ima01,l_ima02,l_ras08,l_rar06*l_qty,l_addmoney,l_qty,l_qty1,l_ras09,l_lqw08)
#FUN-BC0071 --------------END
        END FOREACH
        END IF                                  #FUN-BC0071 add
    END FOREACH
   
END FUNCTION


FUNCTION s_gifts_b_fill()
DEFINE l_sql        STRING
DEFINE l_cnt        LIKE type_file.num5

#   LET g_sql = " SELECT num,sel,rxn04,rar03,rar02,rah21,rah23,ima01,ima02,rar06,rar07,qty,qty1 ",     #FUN-BC0071 mark
    LET g_sql = " SELECT num,sel,rxn04,rar03,rar02,lqw04,lqw05,rah21,rah23,ima01,ima02,rar06,rar07,qty,qty1,ras09,lqw08_1 ",     #FUN-BC0071
               "   FROM s_gifts_tmp "
   PREPARE pre_sel_tmp FROM g_sql
   DECLARE cur_tmp CURSOR FOR pre_sel_tmp
   LET l_cnt = 1
   FOREACH cur_tmp INTO g_temp[l_cnt].*
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL g_temp.deleteElement(l_cnt)
   LET g_rec_b = l_cnt -1

   DISPLAY ARRAY g_temp TO s_temp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
       EXIT DISPLAY
   END DISPLAY

END FUNCTION 


FUNCTION s_gifts_i()
DEFINE l_n       LIKE type_file.num5
DEFINE l_num     LIKE type_file.num5
DEFINE l_cnt     LIKE type_file.num5

   
   INPUT ARRAY g_temp WITHOUT DEFAULTS FROM s_temp.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=FALSE,
                   APPEND ROW=FALSE)
       BEFORE INPUT 
          CALL FGL_SET_ARR_CURR(l_ac_t)
         #TQC-C50165 Add Begin---
          IF g_type = '00' THEN  
             CALL cl_set_act_visible("mod_lqw",FALSE)
          END IF
         #TQC-C50165 Add End-----
          
       BEFORE ROW
         LET l_ac = ARR_CURR()
         LET g_temp_t.*=g_temp[l_ac].*
         IF NOT cl_null(g_temp[l_ac].lqw08_1) THEN
            SELECT COUNT(*) INTO l_cnt FROM lqw_file 
              WHERE lqw00 = g_type AND lqw01 = g_no
                AND lqw02 = g_temp[l_ac].rar03
                AND lqw03 = g_temp[l_ac].rar02
                AND lqw04 = g_temp[l_ac].lqw04
                AND lqw05 = g_temp[l_ac].lqw05
                AND lqw08 = g_temp[l_ac].lqw08_1
            IF l_cnt= 0 THEN
               LET g_temp[l_ac].sel = 'N'
               CALL cl_set_comp_visible("s_lqw",FALSE) 
            ELSE
               IF l_ac > 0 THEN                   #FUN-CA0152 add
                  CALL g_lqw.clear()              #TQC-C20501 
                  CALL s_lqw_b_fill()
                  CALL s_lqw_show()
               END IF                             #FUN-CA0152 add
            END IF
         ELSE
            CALL cl_set_comp_visible("s_lqw",FALSE)
            CALL cl_set_act_visible("mod_lqw",FALSE) 
         END IF
         IF g_temp[l_ac].sel = 'N' THEN
            CALL cl_set_comp_entry("qty1",FALSE)
            CALL cl_set_act_visible("mod_lqw",FALSE)
         ELSE
            CALL cl_set_comp_entry("qty1",TRUE)
            IF NOT cl_null(g_temp[l_ac].lqw08_1) THEN
               CALL cl_set_act_visible("mod_lqw",TRUE)
            END IF
         END IF
       ON CHANGE  sel
          IF g_temp[l_ac].sel = 'Y' THEN
             CALL cl_set_comp_entry("qty1",TRUE)

             IF g_temp[l_ac].rar03 = '2' THEN
                 SELECT COUNT(*) INTO l_n FROM  s_gifts_tmp
                  WHERE sel = 'Y' AND rar02 = g_temp[l_ac].rar02
                    AND rar03 = '2' AND rxn04 = g_temp[l_ac].rxn04
                    AND num <> g_temp[l_ac].num
                                             
                IF l_n +1> g_temp[l_ac].rah23 THEN
                   CALL cl_err('','art-820',0)
                   LET g_temp[l_ac].sel = 'N'
                END IF
             END IF
             IF g_temp[l_ac].rar03 = '3' THEN
                 SELECT COUNT(*) INTO l_n FROM  s_gifts_tmp
                  WHERE sel = 'Y' AND rar02 = g_temp[l_ac].rar02
                    AND rar03 = '3' AND rxn04 = g_temp[l_ac].rxn04
                    AND num <> g_temp[l_ac].num
                    
                IF l_n +1 > g_temp[l_ac].rah23 THEN
                   CALL cl_err('','art-820',0)
                   LET g_temp[l_ac].sel = 'N'
                END IF
             END IF

          ELSE
             CALL cl_set_comp_entry("qty1",FALSE)
          END IF
#FUN-BC0071 ------------STA
          IF g_temp[l_ac].sel = 'Y' THEN
             IF NOT cl_null(g_temp[l_ac].lqw08_1) THEN
                LET g_lqw_flag = 'Y' 
                EXIT INPUT
             ELSE
                CALL cl_set_act_visible("mod_lqw",FALSE)
             END IF
          ELSE
             SELECT COUNT(*) INTO l_cnt FROM lqw_file 
              WHERE lqw00 = g_type AND lqw01 = g_no
                AND lqw02 = g_temp[l_ac].rar03
                AND lqw03 = g_temp[l_ac].rar02
                AND lqw04 = g_temp[l_ac].lqw04
                AND lqw05 = g_temp[l_ac].lqw05
                AND lqw08 = g_temp[l_ac].lqw08_1
              
             IF NOT cl_null(g_temp[l_ac].lqw08_1) AND l_cnt> 0 THEN
                IF cl_confirm('alm1566') THEN
                    DELETE FROM lqw_file WHERE lqw00 = g_type AND lqw01 = g_no
                                           AND lqw02 = g_temp[l_ac].rar03
                                           AND lqw03 = g_temp[l_ac].rar02
                                           AND lqw04 = g_temp[l_ac].lqw04
                                           AND lqw05 = g_temp[l_ac].lqw05
                                           AND lqw08 = g_temp[l_ac].lqw08_1
                    IF SQLCA.SQLCODE THEN
                       CALL cl_err('',SQLCA.SQLCODE,1)
                    ELSE
                       CALL g_lqw.clear()
                       CALL cl_set_comp_visible("s_lqw",FALSE)
                       CALL cl_set_act_visible("mod_lqw",FALSE)
                    END IF 
                ELSE
                   LET g_temp[l_ac].sel = 'Y'
                END IF
             ELSE
                CALL cl_set_comp_visible("s_lqw",FALSE)
                CALL cl_set_act_visible("mod_lqw",FALSE)
             END IF   
         END IF
#FUN-BC0071 ------------END
        
       
       AFTER FIELD qty1
          IF g_temp[l_ac].qty1 <= 0 OR g_temp[l_ac].qty1 > g_temp[l_ac].qty THEN
             CALL cl_err('','art-809',0)
             NEXT FIELD qty1
          ELSE
             IF g_temp[l_ac].qty1 <> g_temp_t.qty1 THEN
                LET g_temp[l_ac].rar06 = (g_temp_t.rar06/g_temp_t.qty1)*g_temp[l_ac].qty1
                LET g_temp[l_ac].rar07 = (g_temp_t.rar07/g_temp_t.qty1)*g_temp[l_ac].qty1
             END IF
          END IF
          
       ON ROW CHANGE
          UPDATE s_gifts_tmp SET sel = g_temp[l_ac].sel,
                                 rar06 = g_temp[l_ac].rar06,      #TQC-C50148 add
                                 rar07 = g_temp[l_ac].rar07,      #TQC-C50148 add
                                 qty1 = g_temp[l_ac].qty1 
          WHERE  num = g_temp[l_ac].num
          
       ON ACTION CONTROLG
           CALL cl_cmdask()

       ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
       ON ACTION about       
           CALL cl_about()     
 
       ON ACTION help          
           CALL cl_show_help() 

#FUN-BC0071  ----------------STA 
       ON ACTION mod_lqw
          LET g_lqw_flag = 'Y'
          EXIT INPUT
         
       AFTER ROW
          LET l_ac = ARR_CURR()
          UPDATE s_gifts_tmp SET sel = g_temp[l_ac].sel,
                                 qty1 = g_temp[l_ac].qty1 
          WHERE  num = g_temp[l_ac].num 
#FUN-BC0071  ----------------END
       
   END INPUT
   LET l_ac_t = l_ac             #FUN-BC0071 add
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      LET g_ins_flag = 'N'
      CLOSE WINDOW s_gifts_w
      RETURN
   END IF
  

END FUNCTION

FUNCTION ins_oeb()
DEFINE l_oeb    RECORD LIKE oeb_file.*
DEFINE l_rar03   LIKE rar_file.rar03,
       l_rar02   LIKE rar_file.rar02,
       l_rah21   LIKE rah_file.rah21,
       l_rah23   LIKE rah_file.rah23,
       l_ima01   LIKE ima_file.ima01,
       l_ima02   LIKE ima_file.ima02,
       l_ras08   LIKE ras_file.ras08,
       l_rar06   LIKE rar_file.rar06,
       l_rar07   LIKE rar_file.rar07,
       l_qty     LIKE type_file.num5,
       l_qty1    LIKE type_file.num5,
       l_ras09   LIKE ras_file.ras09     #FUN-BC0071 add
DEFINE l_sql     STRING
DEFINE l_oea211  LIKE oea_file.oea211
DEFINE l_oea213  LIKE oea_file.oea213
DEFINE l_oea23   LIKE oea_file.oea23
DEFINE l_azi03   LIKE azi_file.azi03
DEFINE l_azi04   LIKE azi_file.azi04
DEFINE l_rty06   LIKE rty_file.rty06
DEFINE l_ima25   LIKE ima_file.ima25     #FUN-B60122
DEFINE l_flag    LIKE type_file.num5     #FUN-B60122
DEFINE l_fac     LIKE type_file.num26_10 #FUN-B60122
DEFINE l_oea02   LIKE oea_file.oea02     #FUN-CA0152
DEFINE l_oea31   LIKE oea_file.oea31     #FUN-CA0152
DEFINE l_oea32   LIKE oea_file.oea32     #FUN-CA0152
DEFINE l_oeb37   LIKE oeb_file.oeb37     #FUN-CA0152
    LET l_sql = " SELECT rar03,rar02,rah21,rah23,ima01,ima02,ras08,rar06,rar07,qty,qty1,ras09 ",  
                " FROM s_gifts_tmp ",
                " WHERE sel = 'Y' "
    PREPARE pre_sel_tmp1 FROM l_sql
    DECLARE cur_tmp1 CURSOR FOR pre_sel_tmp1
    FOREACH cur_tmp1  INTO l_rar03,l_rar02,l_rah21,l_rah23,l_ima01,l_ima02,l_ras08,      
                           l_rar06,l_rar07,l_qty,l_qty1,l_ras09                       #FUN-BC0071 add ras09 
       
       LET l_oeb.oeb01 = g_no
       SELECT MAX(oeb03)+1 INTO l_oeb.oeb03 FROM oeb_file
        WHERE oeb01 = g_no
       LET l_oeb.oeb04 = l_ima01
       LET l_oeb.oeb06 = l_ima02
       LET l_oeb.oeb15 = g_today
      #LET l_oeb.oeb72 = l_oeb.oeb15   #FUN-B20060 add  #CHI-C80060 mark
       LET l_oeb.oeb72 = NULL          #CHI-C80060 add
       LET l_oeb.oeb05 = l_ras08
       LET l_oeb.oeb05_fac = 1
      #FUN-B60122 Begin---
       SELECT ima25 INTO l_ima25 FROM ima_file
        WHERE ima01 = l_ima01
       CALL s_umfchk(l_ima01,l_ras08,l_ima25) RETURNING l_flag,l_fac
       IF l_flag THEN
          CALL cl_err(l_ima01,'aic-052',1)
          CONTINUE FOREACH
       END IF
       LET l_oeb.oeb05_fac = l_fac
      #FUN-B60122 End-----
       LET l_oeb.oeb12 = l_rar06
       LET l_oeb.oeb12 = s_digqty(l_oeb.oeb12,l_oeb.oeb05)    #FUN-BB0085
       LET l_oeb.oeb23 = 0
       LET l_oeb.oeb24 = 0
       LET l_oeb.oeb25 = 0
       LET l_oeb.oeb26 = 0 
       #SELECT oea211,oea213,oea23 INTO l_oea211,l_oea213,l_oea23 FROM oea_file  #FUN-CA0152 mark
       SELECT oea211,oea213,oea23,oea31,oea32,oea02                              #FUN-CA0152 add 
         INTO l_oea211,l_oea213,l_oea23,l_oea31,l_oea32,l_oea02                  #FUN-CA0152 add
         FROM oea_file                                                           #FUN-CA0152 add
        WHERE oea01 = g_no
       SELECT azi03,azi04 INTO l_azi03,l_azi04 FROM azi_file WHERE azi01 = l_oea23       
       LET l_oeb.oeb14t = l_rar07
       LET l_oeb.oeb14 = l_oeb.oeb14t/(1+l_oea211/100)
       CALL cl_digcut(l_oeb.oeb14t,l_azi04) RETURNING l_oeb.oeb14t
       CALL cl_digcut(l_oeb.oeb14,l_azi04) RETURNING l_oeb.oeb14
       IF l_oea213 = 'Y' THEN
          LET l_oeb.oeb13 = l_oeb.oeb14t/l_rar06
       ELSE
          LET l_oeb.oeb13 = l_oeb.oeb14/l_rar06
       END IF
       CALL cl_digcut(l_oeb.oeb13,l_azi03) RETURNING l_oeb.oeb13
       LET l_oeb.oeb17 = l_oeb.oeb13
       #LET l_oeb.oeb37 = l_oeb.oeb13  #FUN-CA0152 mark
       #FUN-CA0152-----add----str
       CALL s_fetch_price_new(l_oeb.oeb50,l_oeb.oeb04,l_oeb.oeb49,l_oeb.oeb05,l_oea02,'7',g_org,
                              l_oea23,l_oea31,l_oea32,g_no,l_oeb.oeb03,l_oeb.oeb12,l_oeb.oeb1004,'a')
                 RETURNING l_oeb37,l_oeb.oeb37
       #FUN-CA0152-----add----end
       LET l_oeb.oeb930 = g_plant
       LET l_oeb.oeb16 = g_today
       SELECT rty06 INTO l_rty06 FROM rty_file
        WHERE rty01 = g_org
          AND rty02 = l_ima01
       IF cl_null(l_rty06) THEN
          LET l_rty06 = '1'
       END IF
       LET l_oeb.oeb44 = l_rty06
#FUN-BC0071 ----------STA
       IF l_ima01 = 'MISCCARD' AND l_ras09 <> 0 THEN
          LET l_oeb.oeb47 = l_ras09 - l_rar07 
          CALL ins_rxc(l_oeb.oeb03,l_rar02,l_oeb.oeb47,l_rar07)
       ELSE
          #LET l_oeb.oeb47 = 0                                    #FUN-CA0152 mark
          LET l_oeb.oeb47 = l_oeb.oeb37*l_oeb.oeb12 - l_rar07     #FUN-CA0152 add
          CALL ins_rxc(l_oeb.oeb03,l_rar02,l_oeb.oeb47,l_rar07)   #FUN-CA0152 add
       END IF
#FUN-BC0071 ----------END
       LET l_oeb.oeb48 = '2'
       LET l_oeb.oebplant = g_org
       SELECT azw02 INTO l_oeb.oeblegal FROM azw_file
        WHERE azw01 = g_org
       LET l_oeb.oeb1003 = '1'
       LET l_oeb.oeb906 = 'N'
       LET l_oeb.oeb19 = 'N'
       LET l_oeb.oeb70 = 'N'
       LET l_oeb.oeb1001 = g_oaz.oaz88
       LET l_oeb.oeb1012 = 'N'
#FUN-CA0152---------add-----------str
       LET l_oeb.oeb916 = l_oeb.oeb05
       LET l_oeb.oeb917 = l_oeb.oeb12
       LET l_oeb.oeb70d = ''
       LET l_oeb.oeb902 = ''
       LET l_oeb.oeb30 = ''
       LET l_oeb.oeb936 = ''
       LET l_oeb.oeb937 = ''
       LET l_oeb.oebud10 = ''
       LET l_oeb.oebud11 = ''
       LET l_oeb.oebud12 = ''
       LET l_oeb.oebud13 = ''
       LET l_oeb.oebud14 = ''
       LET l_oeb.oebud15 = ''
       LET l_oeb.oeb32 = ''
#FUN-CA0152---------add-----------end
       INSERT INTO oeb_file VALUES (l_oeb.*)
       IF SQLCA.SQLCODE THEN
          CALL cl_err3("ins","oeb_file",'','',SQLCA.sqlcode,"","",1)
         #CALL cl_err('',SQLCA.SQLCODE,1)
       END IF 
    END FOREACH                       
END FUNCTION

FUNCTION ins_ogb()
DEFINE l_ogb RECORD LIKE ogb_file.*
DEFINE l_rar03   LIKE rar_file.rar03,
       l_rar02   LIKE rar_file.rar02,
       l_rah21   LIKE rah_file.rah21,
       l_rah23   LIKE rah_file.rah23,
       l_ima01   LIKE ima_file.ima01,
       l_ima02   LIKE ima_file.ima02,
       l_ras08   LIKE ras_file.ras08,
       l_rar06   LIKE rar_file.rar06,
       l_rar07   LIKE rar_file.rar07,
       l_qty     LIKE type_file.num5,
       l_qty1    LIKE type_file.num5,
       l_ras09   LIKE ras_file.ras09      #FUN-BC0071 add            
DEFINE l_sql     STRING
DEFINE l_oga211  LIKE oga_file.oga211
DEFINE l_oga213  LIKE oga_file.oga213
DEFINE l_oga23   LIKE oga_file.oga23
DEFINE l_azi03   LIKE azi_file.azi03
DEFINE l_azi04   LIKE azi_file.azi04
DEFINE l_rty06   LIKE rty_file.rty06
DEFINE l_ima25   LIKE ima_file.ima25     #FUN-B60122
DEFINE l_flag    LIKE type_file.num5     #FUN-B60122
DEFINE l_fac     LIKE type_file.num26_10 #FUN-B60122
DEFINE l_lqw08_1 LIKE lqw_file.lqw08    #TQC-C30072 add 
DEFINE l_lqw   RECORD LIKE lqw_file.*   #TQC-C30072 add
DEFINE l_rxe   RECORD LIKE rxe_file.*   #TQC-C30072 add
DEFINE l_sql1    STRING  #TQC-C30072 add
DEFINE l_oga02   LIKE oga_file.oga02     #FUN-CA0152
DEFINE l_oga31   LIKE oga_file.oga31     #FUN-CA0152
DEFINE l_oga32   LIKE oga_file.oga32     #FUN-CA0152
DEFINE l_ogb37   LIKE ogb_file.ogb37     #FUN-CA0152
    LET l_sql = " SELECT rar03,rar02,rah21,rah23,ima01,ima02,ras08,rar06,rar07,qty,qty1,ras09,lqw08_1 ",  #TQC-C30072 add lqw08_1
                " FROM s_gifts_tmp ",
                " WHERE sel = 'Y' "
    PREPARE pre_sel_tmp2 FROM l_sql
    DECLARE cur_tmp2 CURSOR FOR pre_sel_tmp2
    FOREACH cur_tmp2  INTO l_rar03,l_rar02,l_rah21,l_rah23,l_ima01,l_ima02,l_ras08,
                           l_rar06,l_rar07,l_qty,l_qty1,l_ras09,l_lqw08_1                   #FUN-BC0071 add ras09  #TQC-C30072 add lqw08_1
       LET l_ogb.ogb01 = g_no
       SELECT MAX(ogb03)+1 INTO l_ogb.ogb03 FROM ogb_file
        WHERE ogb01 = g_no
       LET l_ogb.ogb04 = l_ima01
       LET l_ogb.ogb06 = l_ima02
      #FUN-C90049 mark begin---
      #SELECT rtz07 INTO l_ogb.ogb09 FROM rtz_file
      # WHERE rtz01= g_org
      CALL s_get_coststore(g_org,l_ima01) RETURNING l_ogb.ogb09    #FUN-C90049 add
       LET l_ogb.ogb091 = ' '
       LET l_ogb.ogb092 = ' '
       LET l_ogb.ogb05 = l_ras08
       LET l_ogb.ogb12 = l_rar06
       LET l_ogb.ogb12 = s_digqty(l_ogb.ogb12,l_ogb.ogb05)   #No.FUN-BB0086
       SELECT rty06 INTO l_rty06 FROM rty_file
        WHERE rty01 = g_org
          AND rty02 = l_ima01
       IF cl_null(l_rty06) THEN
          LET l_rty06 = '1'
       END IF
       LET l_ogb.ogb44 = l_rty06
       LET l_ogb.ogb05_fac = 1
      #FUN-B60122 Begin---
       SELECT ima25 INTO l_ima25 FROM ima_file
        WHERE ima01 = l_ima01
       CALL s_umfchk(l_ima01,l_ras08,l_ima25) RETURNING l_flag,l_fac
       IF l_flag THEN
          CALL cl_err(l_ima01,'aic-052',1)
          CONTINUE FOREACH
       END IF
       LET l_ogb.ogb05_fac = l_fac
      #FUN-B60122 End-----
       #SELECT oga211,oga213,oga23 INTO l_oga211,l_oga213,l_oga23 FROM oga_file  #FUN-CA0152 mark
       SELECT oga211,oga213,oga23,oga31,oga32,oga02                              #FUN-CA0152 add
         INTO l_oga211,l_oga213,l_oga23,l_oga31,l_oga32,l_oga02                  #FUN-CA0152 add
         FROM oga_file                                                           #FUN-CA0152 add
        WHERE oga01 = g_no
       SELECT azi03,azi04 INTO l_azi03,l_azi04 FROM azi_file
        WHERE azi01 = l_oga23
       LET l_ogb.ogb14t = l_rar07
       LET l_ogb.ogb14 = l_ogb.ogb14t/(1+l_oga211/100)
       CALL cl_digcut(l_ogb.ogb14t,l_azi04) RETURNING l_ogb.ogb14t
       CALL cl_digcut(l_ogb.ogb14,l_azi04) RETURNING l_ogb.ogb14
       IF l_oga213 = 'Y' THEN
          LET l_ogb.ogb13 = l_ogb.ogb14t/l_rar06
       ELSE
          LET l_ogb.ogb13 = l_ogb.ogb14/l_rar06
       END IF
       CALL cl_digcut(l_ogb.ogb13,l_azi03) RETURNING l_ogb.ogb13
       #LET l_ogb.ogb37 = l_ogb.ogb13      #FUN-CA0152 mark
       #FUN-CA0152-----add----str
       CALL s_fetch_price_new(l_ogb.ogb49,l_ogb.ogb04,l_ogb.ogb48,l_ogb.ogb05,l_oga02,'7',g_org,
                              l_oga23,l_oga31,l_oga32,g_no,l_ogb.ogb03,l_ogb.ogb12,l_ogb.ogb1004,'a')
                 RETURNING l_ogb37,l_ogb.ogb37 
       #FUN-CA0152-----add----end
       LET l_ogb.ogb15_fac = 1
       LET l_ogb.ogb16 = 0
       LET l_ogb.ogb18 = 0 
#FUN-BC0071 ----------STA
       IF l_ima01 = 'MISCCARD' AND l_ras09 <> 0 THEN
          LET l_ogb.ogb47 = l_ras09 - l_rar07 
          CALL ins_rxc(l_ogb.ogb03,l_rar02,l_ogb.ogb47,l_rar07)
       ELSE
          #LET l_ogb.ogb47 = 0                                   #FUN-CA0152 mark
          LET l_ogb.ogb47 = l_ogb.ogb37*l_ogb.ogb12 - l_rar07    #FUN-CA0152 add
          CALL ins_rxc(l_ogb.ogb03,l_rar02,l_ogb.ogb47,l_rar07)  #FUN-CA0152 add
       END IF
#FUN-BC0071 ----------END
       LET l_ogb.ogb60 = 0
       LET l_ogb.ogb63 = 0
       LET l_ogb.ogb64 = 0
       LET l_ogb.ogbplant = g_org
       SELECT azw02 INTO l_ogb.ogblegal FROM azw_file
        WHERE azw01 = g_org
       LET l_ogb.ogb1005 = '1'
       LET l_ogb.ogb17 = 'N'
       LET l_ogb.ogb19 = 'N'
       LET l_ogb.ogb1001 = g_oaz.oaz88
       LET l_ogb.ogb1012 = 'N'
       #FUN-C50097 ADD BEGIN-----
       IF cl_null(l_ogb.ogb50) THEN 
         LET l_ogb.ogb50 = 0
       END IF 
       IF cl_null(l_ogb.ogb51) THEN 
         LET l_ogb.ogb51 = 0
       END IF 
       IF cl_null(l_ogb.ogb52) THEN 
         LET l_ogb.ogb52 = 0
       END IF 
       IF cl_null(l_ogb.ogb53) THEN 
         LET l_ogb.ogb53 = 0
       END IF 
       IF cl_null(l_ogb.ogb54) THEN 
         LET l_ogb.ogb54 = 0
       END IF 
       IF cl_null(l_ogb.ogb55) THEN 
         LET l_ogb.ogb55 = 0
       END IF                                            
       #FUN-C50097 ADD END-------       
#TQC-C60131 ----------- add ---------- begin
       IF l_ogb.ogb32 = 0 THEN
          LET l_ogb.ogb32 = ''
       END IF
#TQC-C60131 ----------- add ---------- end
#FUN-CA0152---------add-----------str
       LET l_ogb.ogb916 = l_ogb.ogb05
       LET l_ogb.ogb917 = l_ogb.ogb12
       LET l_ogb.ogbud10 = ''
       LET l_ogb.ogbud11 = ''
       LET l_ogb.ogbud12 = ''
       LET l_ogb.ogbud13 = ''
       LET l_ogb.ogbud14 = ''
       LET l_ogb.ogbud15 = ''
       LET l_ogb.ogb1003 = ''
       LET l_ogb.ogb15 = l_ima25
#FUN-CA0152---------add-----------end
       INSERT INTO ogb_file VALUES (l_ogb.*)
       IF SQLCA.SQLCODE THEN
           CALL cl_err3("ins","ogb_file",'','',SQLCA.sqlcode,"","",1)
          #CALL cl_err('',SQLCA.SQLCODE,1)
       END IF 
      #TQC-C30072 add START
       IF NOT cl_null(l_lqw08_1) THEN  #新增到單身時判斷若為券的就寫入rxe_file
          LET l_sql1 = "SELECT * FROM lqw_file" ,
                       "   WHERE lqw00 = '",g_type,"' AND lqw01 = '",g_no,"'" ,
                       "     AND lqw02 = '",l_rar03,"'",
                       "     AND lqw08 = '",l_lqw08_1,"'"
          PREPARE ins_rxe_pre FROM l_sql1
          DECLARE ins_rxe_cur CURSOR FOR ins_rxe_pre
          SELECT MAX(rxe03) INTO l_rxe.rxe03 FROM rxe_file
             WHERE rxe00 = '02' AND rxe01 = g_no
               AND rxeplant = g_plant
          FOREACH ins_rxe_cur  INTO l_lqw.*
             IF cl_null(l_lqw.lqw13) THEN  LET l_lqw.lqw13 = 0 END IF    #FUN-CA0152 add
             IF cl_null(l_rxe.rxe03) OR l_rxe.rxe03 = 0 THEN
                LET l_rxe.rxe03 = 1
             ELSE
                LET l_rxe.rxe03 = l_rxe.rxe03 + 1
             END IF
             LET l_rxe.rxe02 = l_ogb.ogb03
             LET l_rxe.rxe00 = '02'
             LET l_rxe.rxe01 = g_no
             LET l_rxe.rxe04 = l_lqw.lqw09
             LET l_rxe.rxe05 = l_lqw.lqw10
             LET l_rxe.rxe06 = l_lqw.lqw08
             LET l_rxe.rxe07 = l_lqw.lqw11
             LET l_rxe.rxe08 = l_lqw.lqw12
             LET l_rxe.rxe09 = l_lqw.lqw13
             LET l_rxe.rxeplant = g_plant
             LET l_rxe.rxelegal = g_legal
             INSERT INTO rxe_file VALUES(l_rxe.*)
             IF SQLCA.SQLCODE THEN
                CALL cl_err3("ins","rxe_file",'','',SQLCA.sqlcode,"","",1)
             END IF
          END FOREACH
       END IF
      #TQC-C30072 add END
    END FOREACH
END FUNCTION

FUNCTION ins_rxo()
DEFINE l_rxo RECORD LIKE rxo_file.*
DEFINE l_rar03   LIKE rar_file.rar03,
       l_rxn04   LIKE rxn_file.rxn04,
       l_rar02   LIKE rar_file.rar02,
       l_rah21   LIKE rah_file.rah21,
       l_rah23   LIKE rah_file.rah23,
       l_ima01   LIKE ima_file.ima01,
       l_ima02   LIKE ima_file.ima02,
       l_ras08   LIKE ras_file.ras08,
       l_rar06   LIKE rar_file.rar06,
       l_rar07   LIKE rar_file.rar07,
       l_qty     LIKE type_file.num5,
       l_qty1    LIKE type_file.num5
DEFINE l_sql     STRING
DEFINE l_ima25   LIKE ima_file.ima25
DEFINE l_flag    LIKE type_file.num5
DEFINE l_fac     LIKE type_file.num26_10
DEFINE l_azi03   LIKE azi_file.azi03
DEFINE l_azi04   LIKE azi_file.azi04

    LET l_sql = " SELECT rar03,rxn04,rar02,rah21,rah23,ima01,ima02,ras08,rar06,rar07,qty,qty1 ",
                " FROM s_gifts_tmp ",
                " WHERE sel = 'Y' "
    PREPARE pre_sel_tmp3 FROM l_sql
    DECLARE cur_tmp3 CURSOR FOR pre_sel_tmp3
    FOREACH cur_tmp3  INTO l_rar03,l_rxn04,l_rar02,l_rah21,l_rah23,l_ima01,l_ima02,l_ras08,
                           l_rar06,l_rar07,l_qty,l_qty1
       LET l_rxo.rxo00 = '1'
       LET l_rxo.rxo01 = g_no
       SELECT MAX(rxo02)+1 INTO l_rxo.rxo02 FROM rxo_file
        WHERE rxo01 = g_no
          AND rxo00 = '1'
          AND rxoplant = g_org
        IF cl_null(l_rxo.rxo02) THEN
           LET l_rxo.rxo02 = 1 
        END IF
       LET l_rxo.rxo03 = l_ima01
       #FUN-C90049 mark begin---
       #SELECT rtz07 INTO l_rxo.rxo04  FROM rtz_file
       #WHERE rtz01= g_org
       #FUN-C90049 mark end-----
       CALL s_get_coststore(g_org, l_ima01) RETURNING l_rxo.rxo04   #FUN-C90049 add
       LET l_rxo.rxo05 =  l_ras08
       SELECT ima25 INTO l_ima25 FROM ima_file
        WHERE ima01 = l_ima01        
      #CALL s_umfchk(l_ima01,l_ima25,l_ras08) RETURNING l_flag,l_fac #FUN-B60122
       CALL s_umfchk(l_ima01,l_ras08,l_ima25) RETURNING l_flag,l_fac #FUN-B60122
       IF l_flag THEN
          CALL cl_err(l_ima01,'aic-052',1)
          CONTINUE FOREACH 
       END IF
       LET l_rxo.rxo06 = l_fac
       LET l_rxo.rxo07 = l_rar06
       LET l_rxo.rxo07 = s_digqty(l_rxo.rxo07,l_rxo.rxo05)   #No.FUN-BB0086
       LET l_rxo.rxo08 = 0
       LET l_rxo.rxo09 = l_rar07/l_rar06   
       SELECT azi03.azi04 INTO l_azi03,l_azi04 FROM azi_file
        WHERE azi01 = g_aza.aza17
       CALL cl_digcut(l_rxo.rxo09,l_azi03) RETURNING l_rxo.rxo09 
       LET l_rxo.rxo10 = l_rar07
       CALL cl_digcut(l_rxo.rxo10,l_azi04) RETURNING l_rxo.rxo10
       LET l_rxo.rxo11 = l_rar02
       LET l_rxo.rxo12 = l_rar03
       LET l_rxo.rxo13 = ' '
       LET l_rxo.rxo14 = l_rxn04
       LET l_rxo.rxoplant = g_org
       SELECT azw02 INTO l_rxo.rxolegal FROM azw_file
        WHERE azw01 = g_org
       INSERT INTO rxo_file VALUES (l_rxo.*)
       IF SQLCA.SQLCODE THEN
          CALL cl_err3("ins","rxo_file",'','',SQLCA.sqlcode,"","",1)
          #CALL cl_err('',SQLCA.SQLCODE,1)
       END IF 
    END FOREACH
END FUNCTION 

#FUN-B30012

#FUN-BC0071 -------------------STA
FUNCTION s_lqw_b_fill()
DEFINE l_sql        STRING
DEFINE l_cnt        LIKE type_file.num5


   LET g_sql = " SELECT lqw07,lqw08,'',lqw09,lqw10,lqw11,'',lqw12,lqw13 ",
               "   FROM lqw_file ",
               "  WHERE lqw00 = '",g_type,"' AND lqw01 = '",g_no,"'",
               "    AND lqw02 = '", g_temp[l_ac].rar03,"'",
               "    AND lqw03 = '",g_temp[l_ac].rar02,"'",
               "    AND lqw04 = '",g_temp[l_ac].lqw04,"'",
               "    AND lqw05 = '",g_temp[l_ac].lqw05,"'",
               "    AND lqw08 = '",g_temp[l_ac].lqw08_1,"'"
               
   PREPARE pre_sel_lqw FROM g_sql
   DECLARE sel_lqw_cur CURSOR FOR pre_sel_lqw
   LET l_cnt = 1
   FOREACH sel_lqw_cur INTO g_lqw[l_cnt].*
      SELECT lpx02 INTO g_lqw[l_cnt].lqw08_desc FROM lpx_file 
       WHERE lpx01 = g_lqw[l_cnt].lqw08
      SELECT lrz02 INTO g_lqw[l_cnt].lqw11_desc FROM lrz_file
       WHERE lrz01 = g_lqw[l_cnt].lqw11
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL g_lqw.deleteElement(l_cnt)
   LET g_rec_b1 = l_cnt -1

END FUNCTION

FUNCTION s_lqw_show()

   CALL cl_set_comp_visible("s_lqw",TRUE)
   DISPLAY ARRAY g_lqw TO s_lqw.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
       EXIT DISPLAY
   END DISPLAY 
   
END FUNCTION

FUNCTION s_lqw_b()
DEFINE l_allow_insert  LIKE type_file.num5
DEFINE l_allow_delete  LIKE type_file.num5
DEFINE l_num           LIKE type_file.num5

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   
   INPUT ARRAY g_lqw WITHOUT DEFAULTS FROM s_lqw.*
         ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
     
      BEFORE INPUT 
         CALL cl_set_comp_required('lqw09,lqw10',TRUE)
      
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         LET g_lqw_t.*=g_lqw[l_ac1].*
         BEGIN WORK

         IF g_rec_b1>=l_ac1 THEN
            LET p_cmd = 'u'
            LET g_lqw_t.*=g_lqw[l_ac1].*
         END IF

          
      BEFORE INSERT
         LET p_cmd='a'
         INITIALIZE g_lqw[l_ac1].* TO NULL
         LET g_lqw[l_ac1].lqw08 = g_temp[l_ac].lqw08_1
#TQC-C20407 -------------STA
#         SELECT lpx02,lpx28 INTO g_lqw[l_ac1].lqw08_desc,g_lqw[l_ac1].lqw11 FROM lpx_file 
#          WHERE lpx01 = g_lqw[l_ac1].lqw08
#         SELECT lrz02 INTO g_lqw[l_ac1].lqw11_desc FROM lrz_file
#          WHERE lrz01 = g_lqw[l_ac1].lqw11
          SELECT lpx02 INTO g_lqw[l_ac1].lqw08_desc  FROM lpx_file 
           WHERE lpx01 = g_lqw[l_ac1].lqw08
#TQC-C20407 -------------END
         SELECT MAX(lqw07) INTO g_lqw[l_ac1].lqw07 FROM lqw_file WHERE lqw00 = g_type AND lqw01 = g_no
                                                    AND lqw02 = g_temp[l_ac].rar03
                                                    AND lqw03 = g_temp[l_ac].rar02
                                                    AND lqw04 = g_temp[l_ac].lqw04
                                                    AND lqw05 = g_temp[l_ac].lqw05
                                                    AND lqw08 = g_temp[l_ac].lqw08_1
         IF cl_null(g_lqw[l_ac1].lqw07) THEN
            LET g_lqw[l_ac1].lqw07 = 1
         ELSE
            LET g_lqw[l_ac1].lqw07 = g_lqw[l_ac1].lqw07+1
         END IF
         

      AFTER FIELD lqw09,lqw10
         IF NOT cl_null(g_lqw[l_ac1].lqw09) OR NOT cl_null(g_lqw[l_ac1].lqw10) THEN 
            CALL s_chk_lqw09_lqw10()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD CURRENT
            ELSE
               IF g_flag = 'Y' THEN
                  CALL s_showmsg()
                  NEXT FIELD CURRENT
               ELSE
                  CALL s_lqw09_lqw10() 
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD CURRENT
                  END IF
               END IF  
            END IF
        
         END IF

      ON ACTION controlp
         CASE
            WHEN INFIELD(lqw09)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lqe_1"
               LET g_qryparam.arg1 = g_temp[l_ac].lqw08_1
               LET g_qryparam.arg2 = g_plant
               LET g_qryparam.default1 = g_lqw[l_ac1].lqw09
               CALL cl_create_qry() RETURNING g_lqw[l_ac1].lqw09
               DISPLAY  BY NAME g_lqw[l_ac1].lqw09
               NEXT FIELD lqw09
            
            WHEN INFIELD(lqw10)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lqe_1"
               LET g_qryparam.arg1 = g_temp[l_ac].lqw08_1
               LET g_qryparam.arg2 = g_plant
               LET g_qryparam.default1 = g_lqw[l_ac1].lqw10
               CALL cl_create_qry() RETURNING g_lqw[l_ac1].lqw10
               DISPLAY  BY NAME g_lqw[l_ac1].lqw10
               NEXT FIELD lqw10
               
         OTHERWISE EXIT CASE    
         END CASE

         
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG=0
            CANCEL INSERT
         END IF
         INSERT INTO lqw_file(lqw00,lqw01,lqw02,lqw03,lqw04,lqw05,lqw06,lqw07,
                               lqw08,lqw09,lqw10,lqw11,lqw12,lqw13,lqwlegal,lqwplant)
                     VALUES(g_type,g_no,g_temp[l_ac].rar03,g_temp[l_ac].rar02,
                              g_temp[l_ac].lqw04,g_temp[l_ac].lqw05,0,g_lqw[l_ac1].lqw07,
                              g_temp[l_ac].lqw08_1,g_lqw[l_ac1].lqw09,g_lqw[l_ac1].lqw10,
                              g_lqw[l_ac1].lqw11,g_lqw[l_ac1].lqw12,g_lqw[l_ac1].lqw13,g_legal,g_plant)
         IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","lqw_file",'','',SQLCA.sqlcode,"","",1)
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K.'
             COMMIT WORK
             LET g_rec_b1=g_rec_b1+1
         END IF

         
      BEFORE DELETE
        IF NOT cl_delb(0,0) THEN
           CANCEL DELETE
        END IF
        LET p_cmd = 'd'
        DELETE FROM lqw_file
         WHERE lqw00 = g_type AND lqw01 = g_no
           AND lqw02 = g_temp[l_ac].rar03
           AND lqw03 = g_temp[l_ac].rar02
           AND lqw04 = g_temp[l_ac].lqw04
           AND lqw05 = g_temp[l_ac].lqw05
           AND lqw07 = g_lqw[l_ac1].lqw07
           AND lqw08 = g_temp[l_ac].lqw08_1
           
        IF SQLCA.sqlcode THEN
           CALL cl_err3("del","lqw_file",'','',SQLCA.sqlcode,"","",1)
           ROLLBACK WORK
           CANCEL DELETE
        END IF
        LET g_rec_b1=g_rec_b1-1
        
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_lqw[l_ac1].* = g_lqw_t.*
            EXIT INPUT
         END IF
         UPDATE lqw_file SET lqw09 = g_lqw[l_ac1].lqw09,
                             lqw10 = g_lqw[l_ac1].lqw10,
                             lqw11 = g_lqw[l_ac1].lqw11,
                             lqw12 = g_lqw[l_ac1].lqw12,
                             lqw13 = g_lqw[l_ac1].lqw13
          WHERE lqw00 = g_type AND lqw01 = g_no
            AND lqw02 = g_temp[l_ac].rar03
            AND lqw03 = g_temp[l_ac].rar02
            AND lqw04 = g_temp[l_ac].lqw04
            AND lqw05 = g_temp[l_ac].lqw05
            AND lqw07 = g_lqw[l_ac1].lqw07
            AND lqw08 = g_temp[l_ac].lqw08_1
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             CALL cl_err3("upd","lqw_file",'','',SQLCA.sqlcode,"","",1)
             LET g_lqw[l_ac1].* = g_lqw_t.*
          ELSE
             MESSAGE 'UPDATE O.K.'
             COMMIT WORK
          END IF    

       AFTER ROW
           LET l_ac1 = ARR_CURR()
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_lqw[l_ac1].* = g_lqw_t.*
              END IF
              ROLLBACK WORK
              EXIT INPUT
           END IF
        
           IF p_cmd = 'u' THEN
             UPDATE lqw_file SET lqw09 = g_lqw[l_ac1].lqw09,
                             lqw10 = g_lqw[l_ac1].lqw10
             WHERE lqw00 = g_type AND lqw01 = g_no
               AND lqw02 = g_temp[l_ac].rar03
               AND lqw03 = g_temp[l_ac].rar02
               AND lqw04 = g_temp[l_ac].lqw04
               AND lqw05 = g_temp[l_ac].lqw05
               AND lqw07 = g_lqw[l_ac1].lqw07
               AND lqw08 = g_temp[l_ac].lqw08_1
              IF SQLCA.sqlcode  THEN
                 CALL cl_err3("upd","lqw_file",'','',SQLCA.sqlcode,"","",1)
                 LET g_lqw[l_ac1].* = g_lqw_t.*
              ELSE
                MESSAGE 'UPDATE O.K.'
                COMMIT WORK
              END IF 
          ELSE
            COMMIT WORK 
          END IF
     

      AFTER INPUT  
#TQC-C20501 ------------------STA
          SELECT SUM(lqw12) INTO l_num FROM lqw_file WHERE lqw00 = g_type AND lqw01 = g_no
                                                        AND lqw02 = g_temp[l_ac].rar03
                                                        AND lqw03 = g_temp[l_ac].rar02
                                                        AND lqw04 = g_temp[l_ac].lqw04
                                                        AND lqw05 = g_temp[l_ac].lqw05
                                                        AND lqw08 = g_temp[l_ac].lqw08_1
          IF l_num <> g_temp[l_ac].rar06 THEN
             CALL cl_err('','alm1589',0)
             NEXT FIELD lqw10
          END IF 
#TQC-C20501 ------------------END           
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             EXIT INPUT
          END IF
       
          
          
      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about       
         CALL cl_about()     
 
      ON ACTION HELP          
         CALL cl_show_help()

   END INPUT
   LET g_lqw_flag = 'N'  
   
END FUNCTION

FUNCTION s_chk_lqw09_lqw10()
DEFINE l_n      LIKE   type_file.num5
DEFINE l_n1     LIKE   type_file.num5
DEFINE l_n2     LIKE   type_file.num5
DEFINE l_n3     LIKE   type_file.num5
DEFINE l_lpx22  LIKE   lpx_file.lpx22
DEFINE l_lpx23  LIKE   lpx_file.lpx23
DEFINE l_lpx24  LIKE   lpx_file.lpx24
DEFINE l_lqe01  LIKE   lqe_file.lqe01

   LET g_errno = ' '
   CALL s_showmsg_init()         #TQC-C20407 add
   LET g_flag = 'N'
   SELECT lpx22,lpx23,lpx24 INTO l_lpx22,l_lpx23,l_lpx24
     FROM lpx_file WHERE lpx01 = g_lqw[l_ac1].lqw08
   IF NOT cl_null(g_lqw[l_ac1].lqw09) THEN
      SELECT COUNT(*) INTO l_n FROM lqe_file WHERE lqe01 = g_lqw[l_ac1].lqw09
      IF l_n = 0 THEN
         LET g_errno = 'alm-477'
         RETURN
      ELSE
         IF LENGTH(g_lqw[l_ac1].lqw09) - LENGTH(l_lpx23) <> l_lpx24 OR l_lpx23 <> g_lqw[l_ac1].lqw09[1,l_lpx22] THEN
            LET g_errno = 'alm-388'
            RETURN
         END IF
      END IF
   END IF
   IF NOT cl_null(g_lqw[l_ac1].lqw10) THEN 
      SELECT COUNT(*) INTO l_n1 FROM lqe_file WHERE lqe01 = g_lqw[l_ac1].lqw10
      IF l_n1 = 0 THEN
         LET g_errno = 'alm-477'
         RETURN
      ELSE
         IF LENGTH(g_lqw[l_ac1].lqw10) - LENGTH(l_lpx23) <> l_lpx24 OR l_lpx23 <> g_lqw[l_ac1].lqw10[1,l_lpx22] THEN
            LET g_errno = 'alm-388'
            RETURN
         END IF 
      END IF
    END IF
   IF NOT cl_null(g_lqw[l_ac1].lqw09) AND NOT cl_null(g_lqw[l_ac1].lqw10) THEN
      IF g_lqw[l_ac1].lqw09 > g_lqw[l_ac1].lqw10 THEN
         LET g_errno = 'aim-919'
         RETURN
      END IF
  #   SELECT COUNT(*) INTO l_n FROM lqe_file WHERE lqe17 NOT IN('5','2') AND lqe13 = g_plant    #TQC-C20379 mark
      SELECT COUNT(*) INTO l_n FROM lqe_file WHERE lqe17 NOT IN('5','2')                        #TQC-C20379 
                                               AND lqe01 <= g_lqw[l_ac1].lqw10
                                               AND lqe01 >= g_lqw[l_ac1].lqw09
      IF l_n> 0 THEN
         LET g_flag = 'Y'
  #       DECLARE sel_lqe_cur CURSOR FOR SELECT lqe01 FROM lqe_file WHERE lqe17 NOT IN('5','2') AND lqe13 = g_plant  #TQC-C20379 mark
         DECLARE sel_lqe_cur CURSOR FOR SELECT lqe01 FROM lqe_file WHERE lqe17 NOT IN('5','2')                       #TQC-C20379 
                                                      AND lqe01 <= g_lqw[l_ac1].lqw10
                                                      AND lqe01 >= g_lqw[l_ac1].lqw09
         FOREACH sel_lqe_cur INTO l_lqe01
            CALL s_errmsg('',l_lqe01,'','alm1587',1)      #TQC-C20407 
         END FOREACH
      END IF
      SELECT COUNT(*) INTO l_n1 FROM lqe_file WHERE lqe17 IN('5','2') AND lqe13 <> g_plant
                                                AND lqe01 <= g_lqw[l_ac1].lqw10
                                                AND lqe01 >= g_lqw[l_ac1].lqw09
      IF l_n1> 0 THEN
         LET g_flag = 'Y'
         DECLARE sel_lqe_cur1 CURSOR FOR SELECT lqe01 FROM lqe_file WHERE lqe17  IN('5','2') AND lqe13 <> g_plant
                                                       AND lqe01 <= g_lqw[l_ac1].lqw10
                                                       AND lqe01 >= g_lqw[l_ac1].lqw09
         FOREACH sel_lqe_cur1 INTO l_lqe01
            CALL s_errmsg('',l_lqe01,'','alm1560',1)
         END FOREACH
         RETURN
      END IF

#TQC-C20407 ---------------STA
      SELECT COUNT(DISTINCT lqe03) INTO l_n3 FROM lqe_file WHERE lqe17  IN('5','2') AND lqe13 = g_plant
                                                   AND lqe01 <= g_lqw[l_ac1].lqw10
                                                   AND lqe01 >= g_lqw[l_ac1].lqw09
       IF l_n3 >1 THEN
          LET g_errno = 'alm1588'
          RETURN
       END IF 
#TQC-C20407 ---------------END
      SELECT COUNT(*) INTO l_n2 FROM lqw_file  WHERE lqw00 = g_type AND lqw01 = g_no
                                                 AND lqw02 = g_temp[l_ac].rar03
                                                 AND lqw03 = g_temp[l_ac].rar02
                                                 AND lqw04 = g_temp[l_ac].lqw04
                                                 AND lqw05 = g_temp[l_ac].lqw05
                                                 AND lqw07 <> g_lqw[l_ac1].lqw07
                                                 AND lqw08 = g_temp[l_ac].lqw08_1
                                                 AND ((lqw09 BETWEEN g_lqw[l_ac1].lqw09 AND g_lqw[l_ac1].lqw10
                                                     OR lqw10 BETWEEN g_lqw[l_ac1].lqw09 AND g_lqw[l_ac1].lqw10)
                                                  OR  (g_lqw[l_ac1].lqw09 BETWEEN lqw09 AND lqw10
                                                     OR g_lqw[l_ac1].lqw10 BETWEEN lqw09 AND lqw10))
     IF l_n2 > 0 THEN
        LET g_errno = 'alm1564'
        RETURN
     END IF 
      
   END IF 
END FUNCTION

FUNCTION s_lqw09_lqw10()
DEFINE l_n    LIKE type_file.num5
DEFINE l_num  LIKE type_file.num5


    LET g_errno = ''
    SELECT DISTINCT lqe03 INTO g_lqw[l_ac1].lqw11 FROM lqe_file WHERE lqe17  IN('5','2') AND lqe13 = g_plant
                                                   AND lqe01 <= g_lqw[l_ac1].lqw10
                                                   AND lqe01 >= g_lqw[l_ac1].lqw09
    SELECT lrz02 INTO g_lqw[l_ac1].lqw11_desc FROM lrz_file  WHERE lrz01 = g_lqw[l_ac1].lqw11                                        
    
    SELECT COUNT(*) INTO g_lqw[l_ac1].lqw12 FROM lqe_file WHERE lqe17 IN('5','2') AND lqe13 = g_plant
                                               AND lqe01 <= g_lqw[l_ac1].lqw10
                                               AND lqe01 >= g_lqw[l_ac1].lqw09
    LET g_lqw[l_ac1].lqw13 = g_lqw[l_ac1].lqw12* g_lqw[l_ac1].lqw11_desc

    SELECT SUM(lqw12) INTO l_num FROM lqw_file WHERE lqw00 = g_type AND lqw01 = g_no
                                                 AND lqw07 <> g_lqw[l_ac1].lqw07
                                                 AND lqw02 = g_temp[l_ac].rar03
                                                 AND lqw03 = g_temp[l_ac].rar02
                                                 AND lqw04 = g_temp[l_ac].lqw04
                                                 AND lqw05 = g_temp[l_ac].lqw05
                                                 AND lqw08 = g_temp[l_ac].lqw08_1
    IF cl_null(l_num) THEN
       LET l_num = 0
    END IF    
    IF NOT cl_null(g_lqw[l_ac1].lqw09) AND NOT cl_null(g_lqw[l_ac1].lqw10) THEN
       IF l_num+g_lqw[l_ac1].lqw12 > g_temp[l_ac].rar06 THEN
          LET g_errno = 'alm1589'
          RETURN
       END IF       
    END IF
    
END FUNCTION


FUNCTION ins_rxc(p_rxc02,p_rxc04,p_rxc06,p_rar07)
DEFINE p_rxc02     LIKE rxc_file.rxc02
DEFINE p_rxc03     LIKE rxc_file.rxc03
DEFINE p_rxc04     LIKE rxc_file.rxc04
DEFINE p_rxc06     LIKE rxc_file.rxc06
DEFINE p_rar07     LIKE rar_file.rar07
DEFINE l_type      LIKE rxc_file.rxc03

 
   IF p_rar07 = 0 THEN
      LET l_type = '19'
   ELSE
      LET l_type = '18'
   END IF
   INSERT INTO rxc_file(rxc00,rxc01,rxc02,rxc03,rxc04,rxc05,rxc06,
                      rxc09,rxclegal,rxcplant,rxc11,rxc15)
        VALUES(g_type,g_no,p_rxc02,l_type,p_rxc04,'',p_rxc06,
                        0,g_legal,g_plant,g_member,0)
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("ins","rxc_file",'','',SQLCA.sqlcode,"","",1)
   END IF

END FUNCTION
#FUN-BC0071 -------------------END
       
