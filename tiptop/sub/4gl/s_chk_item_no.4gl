# Prog. Version..: '5.30.06-13.04.12(00010)'     #
#
# Program name...: s_chk_item_no.4gl
# Descriptions...: 檢查料號
# Date & Author..: FUN-A90048 10/09/19 By huangtao  
# Usage..........: CALL s_chk_item_no(p_ima01,p_plant)
# Input PARAMETER: p_ima01  料件編號
#                  p_plant 營運中心
# RETURN Code....: True / FALSE
# Modify.........: No:FUN-AB0025 10/11/11 By huangtao mod s_ima_except1()
# Modify.........: No:FUN-B40007 11/04/11 By huangtao 檢查料號時增加對MISC的管控
# Modify.........: No:FUN-B40044 11/04/27 By shiwuying 料号有效码检查逻辑修改
# Modify.........: No.TQC-B90236 11/10/25 By zhuhao 除訂單外，其餘皆不可選取"特性主料"="Y"的料號且歸屬層級料號的要有值
# Modify.........: No:TQC-C20357 12/02/22 By baogc artt100策略變更單排除控管企業料號/聯營
# Modify.........: No:TQC-C20348 12/02/27 By lixiang 修改服飾零售業態下對料件的商品策略的控管
# Modify.........: No:TQC-C20418 12/03/02 By lixiang 修正TQC-C30005的問題
# Modify.........: No:FUN-C30057 12/04/23 By lixiang 增加apmt580_slk料號的控管
# Modify.........: No:FUN-C30047 12/08/07 By bart 1.abmi600主件可輸入特性主件料號(ima928='Y')
#                                                 2.asfi301生產料件可輸入特性主件料號(ima928='Y')，但需檢查是否有聯產品設定
# Modify.........: No:FUN-CA0044 12/10/22 By xjll 增加GWC wpc模组程式 商品策略開窗 
# Modify.........: No:FUN-CB0097 12/11/21 By qiaozy 添加wpct011资料
# Modify.........: No:FUN-CB0141 12/11/30 By qiaozy 添加wpct009,wpct010资料
# Modify.........: No:CHI-C30036 12/12/05 By bart 判斷ima928時，需略掉axmt400
# Modify.........: No:FUN-CC0026 12/12/17 By Sakura 多角拋轉(axmt810)時，也要可拋轉特性主料
# Modify.........: No:WEB-CC0007 13/01/25 By jingll  添加wpct030商品策略檢查
# Modify.........: No:FUN-C30075 12/12/29 By Sakura apmt420,apmt540,apmi303料號可輸入特性主料
# Modify.........: No:FUN-C30033 13/04/01 By Elise (1)判斷g_prog處改為判斷程式前7碼,需考慮其他行業別
#                                                  (2)估報價單等前端單據要可輸入特性主料 

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chk_item_no(p_ima01,p_plant)
DEFINE  p_ima01   LIKE ima_file.ima01,         #料號
        p_progno  LIKE zz_file.zz01,           #程式代號
        p_sys     LIKE zz_file.zz011,          #模組別
        p_plant   LIKE azw_file.azw01          #營運中心
DEFINE  l_except  LIKE type_file.num5          #該料號是否存在商品策略中
DEFINE  l_rte04   LIKE rte_file.rte04          #是否可采
DEFINE  l_rte05   LIKE rte_file.rte05          #是否可售
DEFINE  l_rte06   LIKE rte_file.rte06          #是否可退
DEFINE  l_rtz04_except LIKE type_file.num5     #該營運中心是否存在商品策略
DEFINE  l_rtz04   LIKE rtz_file.rtz04          #商品策略

  IF cl_null( p_plant) THEN
     LET p_plant = g_plant
  END IF
  LET g_errno  = ''
  LET p_progno = g_prog
  SELECT zz011 INTO p_sys FROM zz_file WHERE zz01 = p_progno 
  LET p_sys = UPSHIFT(p_sys)
  IF NOT s_chk_exist_ima01(p_ima01,p_plant) THEN
     RETURN FALSE
  END IF
  CALL s_rtz04_except(p_plant) RETURNING l_rtz04_except,l_rtz04
  CALL s_prod_strategy( p_ima01,l_rtz04,p_plant ) 
  RETURNING l_except,l_rte04, l_rte05, l_rte06 
  
  CASE 
     WHEN (p_sys = "ALM" OR p_sys = "CLM" )
         IF NOT l_rtz04_except THEN
            RETURN TRUE
         ELSE
            IF NOT l_except THEN
               LET g_errno = 'art-700'           #此料號不存在產品策略中，請檢查 arti120 設定!
               RETURN FALSE
            END IF
         END IF
     WHEN  (p_sys = "ART" OR p_sys = "CRT" OR g_prog = "wpct003" OR g_prog = "wpct004" OR g_prog = "wpct030"  #WEB-CC0007--add wpct030
            OR g_prog = "wpct005" OR g_prog = "wpct015" OR g_prog = "wpct014")    #FUN-CA0044--add wpc模組程式
        IF NOT l_rtz04_except THEN
           IF NOT s_ima_except1(p_progno,p_plant)  AND  NOT s_internal_item(p_ima01,p_plant) THEN       #FUN-AB0025  mod s_ima_except1() add p_plant
              LET g_errno = 'art-701'         # 此料號非企業料件，不允許輸入!
              RETURN FALSE
           ELSE
              IF NOT s_ima_except2(p_progno)  AND s_joint_venture( p_ima01 ,p_plant) THEN  
                 LET g_errno = 'art-702'      #此料號為經營方式為"聯營"，不允許輸入!
                 RETURN FALSE
              END IF
           END IF
        ELSE
           IF NOT l_except THEN
              LET g_errno = 'art-700'
              RETURN FALSE
           ELSE
              IF NOT s_ima_except1(p_progno,p_plant) AND NOT s_internal_item(p_ima01,p_plant) THEN      #FUN-AB0025  mod s_ima_except1() add p_plant
                 LET g_errno = 'art-701'
                 RETURN FALSE
              ELSE
                 IF NOT s_ima_except2(p_progno)  AND s_joint_venture(p_ima01,p_plant) THEN  
                    LET g_errno = 'art-702'
                    RETURN FALSE
                 END IF
              END IF    
           END IF   
        END IF   
     
     WHEN  (p_sys = "AXM" OR p_sys = "CXM" )
        IF NOT l_rtz04_except THEN
           IF NOT s_ima_except1(p_progno,p_plant) AND NOT s_internal_item(p_ima01,p_plant) THEN         #FUN-AB0025  mod s_ima_except1() add p_plant
              LET g_errno = 'art-701'
              RETURN FALSE
           ELSE
              IF NOT s_ima_except2(p_progno)  AND s_joint_venture( p_ima01 ,p_plant) THEN    
                 LET g_errno = 'art-702'
                 RETURN FALSE
              END IF
           END IF
        ELSE
           IF NOT l_except THEN
              LET g_errno = 'art-700'
              RETURN FALSE
           ElSE
              IF (p_progno = "axmt700" OR p_progno = "axmt840")THEN
                 IF l_rte06 <> 'Y' THEN 
                    LET g_errno = 'art-703'     #此料件產品策略不為可退，不允許輸入!
                    RETURN FALSE
                 END IF
              ELSE
                 IF l_rte05 <> 'Y' THEN
                    LET g_errno = 'art-704'      #此料件產品策略不為可售，不允許輸入!
                    RETURN FALSE
                 END IF
              END IF  
              IF NOT s_ima_except1(p_progno,p_plant) AND NOT s_internal_item(p_ima01,p_plant) THEN       #FUN-AB0025  mod s_ima_except1() add p_plant
                 LET g_errno = 'art-701'
                 RETURN FALSE
              ELSE
                IF NOT s_ima_except2(p_progno) AND s_joint_venture( p_ima01 ,p_plant) THEN
                   LET g_errno = 'art-702'
                   RETURN FALSE
                END IF
              END IF
            END IF
          END IF
                 
     WHEN ( p_sys = "APM" OR p_sys = "CPM" OR g_prog = "wpct001" OR g_prog = "wpct008" OR g_prog = "wpct010")  #FUN-CA0044-add wpc.... #FUN-CB0141-ADD WPCT010
       IF NOT l_rtz04_except THEN
          IF NOT s_internal_item( p_ima01,p_plant ) THEN
             LET g_errno = 'art-701'
             RETURN FALSE
          ELSE
             IF s_joint_venture( p_ima01 ,p_plant) THEN
                LET g_errno = 'art-702'
                RETURN FALSE
             END IF 
          END IF 
       ELSE
          IF NOT l_except THEN
             LET g_errno = 'art-700'
             RETURN FALSE
          ELSE
             IF l_rte04 <> 'Y' THEN
                LET g_errno = 'art-705'        #此料件產品策略不為可採，不允許輸入!
                RETURN FALSE
             END IF
             IF NOT s_internal_item( p_ima01,p_plant ) THEN
                LET g_errno = 'art-701'
                RETURN FALSE
             ELSE
                IF s_joint_venture( p_ima01 ,p_plant) THEN
                   LET g_errno = 'art-702'
                   RETURN FALSE
                END IF
             END IF
           END IF
        END IF
           
     WHEN   (p_sys = "AIM" OR p_sys = "CIM" OR g_prog = "wpct301" OR g_prog = "wpct302" OR g_prog = "wpct303") #FUN-CA0044--add wpc模組
       IF NOT l_rtz04_except THEN 
          IF NOT s_internal_item( p_ima01,p_plant ) THEN
             LET g_errno = 'art-701'
             RETURN FALSE
          ELSE
             IF NOT s_ima_except2(p_progno) AND s_joint_venture( p_ima01 ,p_plant) THEN
                LET g_errno = 'art-702'
                RETURN FALSE
             END IF
          END IF
       ELSE
          IF NOT l_except THEN
             LET g_errno = 'art-700'
             RETURN FALSE
          ELSE
             IF NOT s_internal_item( p_ima01,p_plant ) THEN
                LET g_errno = 'art-701'
                RETURN FALSE
             ELSE
                IF NOT s_ima_except2(p_progno) AND s_joint_venture( p_ima01,p_plant) THEN
                   LET g_errno = 'art-702'
                   RETURN FALSE
                END IF
             END IF
          END IF
        END IF
#FUN-CB0097-----ADD---STR---
     WHEN (g_prog="wpct011" OR g_prog="wpct007" OR g_prog="wpct009" ) #FUN-CB0141--ADD WPCT009
        IF NOT l_rtz04_except THEN
          IF NOT s_internal_item( p_ima01,p_plant ) THEN
             LET g_errno = 'art-701'
             RETURN FALSE
          ELSE
             IF NOT s_ima_except2(p_progno) AND s_joint_venture( p_ima01 ,p_plant) THEN
                LET g_errno = 'art-702'
                RETURN FALSE
             END IF
          END IF
       ELSE
          IF NOT l_except THEN
             LET g_errno = 'art-700'
             RETURN FALSE
          ELSE
             IF NOT s_internal_item( p_ima01,p_plant ) THEN
                LET g_errno = 'art-701'
                RETURN FALSE
             ELSE
                IF NOT s_ima_except2(p_progno) AND s_joint_venture( p_ima01,p_plant) THEN
                   LET g_errno = 'art-702'
                   RETURN FALSE
                END IF
             END IF
          END IF
        END IF
#FUN-CB0097-----ADD---END---       
     OTHERWISE
        IF NOT s_internal_item( p_ima01,p_plant ) THEN
           LET g_errno = 'art-701'
           RETURN FALSE 
        ELSE
           IF s_joint_venture( p_ima01 ,p_plant) THEN
              LET g_errno = 'art-702'
              RETURN FALSE
           END IF
        END IF
        
  END CASE

  RETURN TRUE
END FUNCTION

#判斷是存在料件基本資料中
#傳入值 p_item : 料號
#      p_plant: 门店
#回傳值 True / FALSE    TRUE:企業料號     FALSE: 非企業料號
FUNCTION s_chk_exist_ima01( p_item,p_plant )
DEFINE l_imaacti LIKE ima_file.imaacti
DEFINE p_item    LIKE ima_file.ima01
DEFINE p_plant   LIKE azw_file.azw01
DEFINE l_sql     LIKE type_file.chr1000
DEFINE l_ima928  LIKE ima_file.ima928                      #TQC-B90236 add
DEFINE l_count   LIKE type_file.num5                       #TQC-B90236 add
   LET g_errno  = ''  #error message defult
#FUN-B40007 ---------------STA
   IF p_item[1,4]='MISC' THEN
      LET l_sql = " SELECT imaacti FROM ",cl_get_target_table(p_plant,'ima_file'),
                  " WHERE ima01 = 'MISC'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
      PREPARE sel_ima_pre FROM l_sql
      EXECUTE sel_ima_pre INTO l_imaacti
      IF STATUS  THEN
         LET g_errno = 'aim-806'
         RETURN FALSE
      ELSE
         IF l_imaacti = 'N' THEN
            LET g_errno = 'axm-890'
            RETURN FALSE
        #FUN-B40044 Begin---
         ELSE
            IF l_imaacti = 'P' THEN
               LET g_errno = 'atm-017'
               RETURN FALSE
            END IF
        #FUN-B40044 End---
         END IF
         RETURN TRUE
      END IF
   END IF
#FUN-B40007 ---------------END
   LET l_sql = " SELECT imaacti FROM ",cl_get_target_table(p_plant,'ima_file'),
               " WHERE ima01 = '",p_item,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql   
   PREPARE sel_ima_pre1 FROM l_sql 
   EXECUTE sel_ima_pre1 INTO l_imaacti  
      IF STATUS  THEN 
         LET g_errno = 'mfg3403'
         RETURN FALSE
      ELSE
         IF l_imaacti = 'N' THEN
           LET g_errno = 'axm-890'
           RETURN FALSE 
        #FUN-B40044 Begin---
         ELSE
            IF l_imaacti = 'P' THEN
               LET g_errno = 'atm-017'
               RETURN FALSE
            END IF
        #FUN-B40044 End---
         END IF
      END IF 
#N0.TQC-B90236-----------------add--start-----
   LET l_sql = " SELECT ima928 FROM ",cl_get_target_table(p_plant,'ima_file'),
               " WHERE ima01 = '",p_item,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE sel_ima_pre3 FROM l_sql
   EXECUTE sel_ima_pre3 INTO l_ima928
   IF l_ima928='Y' THEN
      #IF NOT(g_prog = "axmt410" OR g_prog = "axmt800") THEN  #FUN-C30047
     #FUN-C30033---mark---S 
     #IF NOT(g_prog = "axmt410" OR g_prog = "axmt800" #FUN-C30047 
     #    OR g_prog = "apmt420" OR g_prog = "apmt540" OR g_prog = "apmi303" #FUN-C30075 add
     #    OR g_prog = "abmi600" OR g_prog = "asfi301" OR g_prog = "axmt400" OR g_prog = "axmt810") THEN   #FUN-C30047 #CHI-C30036 #FUN-CC0026 add axmt810
     #FUN-C30033---mark---E     
     #FUN-C30033---S
      IF NOT(g_prog[1,7]='axmt410' OR g_prog[1,7]='axmt800' OR g_prog[1,7]='apmt420'
          OR g_prog[1,7]='apmt540' OR g_prog[1,7]='apmi303' OR g_prog[1,7]='abmi600'
          OR g_prog[1,7]='asfi301' OR g_prog[1,7]='axmt400' OR g_prog[1,7]='axmt810'
          OR g_prog[1,7]='axmt310' OR g_prog[1,7]='axmt360' OR g_prog[1,7]='axmt400'
             ) THEN        
     #FUN-C30033---E
         LET g_errno = 'ima-001'
         RETURN FALSE
      END IF
   ELSE
      SELECT COUNT(*) INTO l_count  FROM imac_file
       WHERE imac01 = p_item
         AND imac03 = "1"
         AND imac05 IS NULL 
      IF l_count>0 THEN
         LET g_errno = 'ima-002'
         RETURN FALSE
      END IF
   END IF
#N0.TQC-B90236-----------------add--end-------
   RETURN TRUE
END FUNCTION


#判斷是否企業料號
#傳入值 p_item : 料號
#      p_plant: 门店
#回傳值 True / FALSE    TRUE:企業料號     FALSE: 非企業料號
FUNCTION s_internal_item( p_item,p_plant )
DEFINE p_item    LIKE ima_file.ima01
DEFINE p_plant   LIKE azw_file.azw01
DEFINE l_ima120  LIKE ima_file.ima120
DEFINE l_sql     LIKE type_file.chr1000
   LET l_sql = " SELECT ima120 FROM ",cl_get_target_table(p_plant,'ima_file'),
              " WHERE ima01 = '",p_item,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql   
   PREPARE sel_ima_pre2 FROM l_sql 
   EXECUTE sel_ima_pre2 INTO l_ima120   
   
   IF cl_null(l_ima120)  OR  l_ima120 = '1' THEN 
      RETURN TRUE
   ELSE 
      RETURN FALSE  
   END IF   
    
END FUNCTION   

#判斷是否存在商品策略
#傳入值 p_item : 料號
#      p_rtz04: 產品策略
#      p_plant: 门店
#回傳值 (1) 1 /0    1:存在     0: 不存在
#      (2) l_rte04: 是否可採
#      (3) l_rte05: 是否可售
#      (4) l_rte06: 是否可退

FUNCTION s_prod_strategy( p_item,p_rtz04,p_plant )
DEFINE p_item   LIKE ima_file.ima01
DEFINE p_rtz04  LIKE rtz_file.rtz04
DEFINE l_rte04  LIKE rte_file.rte04
DEFINE l_rte05  LIKE rte_file.rte05
DEFINE l_rte06  LIKE rte_file.rte06
DEFINE l_sql    LIKE type_file.chr1000
DEFINE p_plant  LIKE azw_file.azw01
DEFINE l_ima151 LIKE ima_file.ima151
     
   LET l_rte04 = ''
   LET l_rte05 = ''
   LET l_rte06 = ''
#TQC-C20348--add--begin-- 
  #TQC-C20418 mark--begin--
  #IF s_industry("slk") AND g_azw.azw04 = '2' THEN
  #   IF g_prog="axmt410_slk" OR g_prog="axmt610_slk" OR g_prog="axmt620_slk" OR
  #      g_prog="axmt700_slk" OR g_prog="apmt420_slk" OR g_prog="apmt540_slk" OR
  #      g_prog="apmt720_slk" OR g_prog="apmg722_slk" OR g_prog="apmt110_slk" OR
  #      g_prog="aimt301_slk" OR g_prog="aimt302_slk" OR g_prog="aimt303_slk" OR
  #      g_prog="axmt420_slk" OR g_prog="axmt810_slk" OR g_prog="apmt590_slk" OR
  #      g_prog="axmt628_slk" OR g_prog="axmt629_slk" OR g_prog="axmt640_slk" OR
  #      g_prog="artt256" OR g_prog="artt212"  THEN   
  #TQC-C20418 mark--end--
  #TQC-C20418--add--begin--
   IF s_industry("slk") AND g_azw.azw04 = '2' AND 
       ( g_prog="axmt410_slk" OR g_prog="axmt610_slk" OR g_prog="axmt620_slk" OR
         g_prog="axmt700_slk" OR g_prog="apmt420_slk" OR g_prog="apmt540_slk" OR
         g_prog="apmt720_slk" OR g_prog="apmg722_slk" OR g_prog="apmt110_slk" OR
         g_prog="aimt301_slk" OR g_prog="aimt302_slk" OR g_prog="aimt303_slk" OR
         g_prog="axmt420_slk" OR g_prog="axmt810_slk" OR g_prog="apmt590_slk" OR
         g_prog="axmt628_slk" OR g_prog="axmt629_slk" OR g_prog="axmt640_slk" OR
         g_prog="artt256"     OR g_prog="artt212"     OR g_prog="apmt580_slk" ) THEN   #FUN-C30057 add apmt580_slk
  #TQC-C20418--add--end--
         SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = p_item
         IF l_ima151 = 'Y' THEN
            LET l_sql = " SELECT DISTINCT rte04,rte05,rte06  ",
                        " FROM ",cl_get_target_table(p_plant,'rte_file'),
                        " , ",cl_get_target_table(p_plant,'imx_file'),  
                        " WHERE rte01 = '",p_rtz04,"'",
                        "   AND rte03 = imx000 ",
                        "   AND imx00 = '",p_item,"'",
                        "   AND rte07 = 'Y'"
         ELSE
            LET l_sql = " SELECT rte04,rte05,rte06 ",
                        " FROM ",cl_get_target_table(p_plant,'rte_file'),
                        " WHERE rte01 = '",p_rtz04,"'",
                        " AND rte03 = '",p_item,"'",
                        " AND rte07 = 'Y'"
         END IF
    # END IF    #TQC-C20418 mark   
   ELSE
#TQC-C20348--add--end--
      LET l_sql = " SELECT rte04,rte05,rte06 ",
                  " FROM ",cl_get_target_table(p_plant,'rte_file'),
                  " WHERE rte01 = '",p_rtz04,"'",            
                  " AND rte03 = '",p_item,"'",
                  " AND rte07 = 'Y'" 
   END IF     #TQC-C20348 add
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql   
   PREPARE sel_rte_pre1 FROM l_sql 
   EXECUTE sel_rte_pre1 INTO l_rte04,l_rte05,l_rte06               

   IF STATUS  THEN 
      RETURN  0, l_rte04, l_rte05, l_rte06
   ELSE
      RETURN  1, l_rte04, l_rte05, l_rte06 
   END IF
END FUNCTION    

#判斷是否為聯營
#傳入值 p_item : 料號
#      p_plant: 门店
#回傳值 True / FALSE    TRUE:聯營     FALSE: 非聯營

FUNCTION  s_joint_venture( p_item ,p_plant)
DEFINE p_item  LIKE ima_file.ima01
DEFINE l_n     LIKE type_file.num5
DEFINE p_plant LIKE azw_file.azw01 
DEFINE l_sql   LIKE type_file.chr1000

   LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(p_plant,'rty_file'),
               " WHERE rty01 = '",p_plant,"'",
               " AND rty02 ='",p_item,"'",
               " AND rty06 = '4'",
               " AND rtyacti = 'Y'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql   
   PREPARE sel_num_pre1 FROM l_sql 
   EXECUTE sel_num_pre1 INTO l_n               
   IF l_n = 0 THEN
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION

#排除控管企業料號
FUNCTION  s_ima_except1(p_progno,p_plant)                     #FUN-AB0025 add p_plant
DEFINE p_progno  LIKE zz_file.zz01
DEFINE p_plant   LIKE azw_file.azw01                          #FUN-AB0025 add
DEFINE l_azw04   LIKE azw_file.azw04                          #FUN-AB0025 add
#FUN-AB0025 -------------STA
   SELECT azw04 INTO l_azw04 FROM azw_file WHERE azw01 = p_plant
   IF l_azw04 = '1' THEN RETURN FALSE END IF
#FUN-AB0025 -------------END
   IF p_progno = "arti111" OR p_progno = "arti112" OR p_progno = "arti120"
      OR p_progno = "arti121" OR p_progno = "arti122" OR p_progno = "artr001" 
     #OR p_progno = "artr002" OR p_progno = "artt121" OR p_progno = "artt122" #TQC-C20357 Mark
      OR p_progno = "artr002" OR p_progno = "arti100" OR p_progno = "artt121" #TQC-C20357 Add
      OR p_progno = "artt122" OR p_progno = "artt100"                         #TQC-C20357 Add
      OR p_progno = "artt302" OR p_progno = "artr303" OR p_progno = "artr304"
      OR p_progno = "artr603" OR p_progno = "artr604" OR p_progno = "artt605"
      OR p_progno = "artr606" OR p_progno = "artt724" OR p_progno = "artt725"
      OR p_progno = "artt726" OR p_progno = "artt727" OR p_progno = "axmt410"
      OR p_progno = "axmt410_icd" OR p_progno = "axmt410_slk"
      OR p_progno = "axmt620" OR p_progno = "axmt700"  THEN
      RETURN TRUE
   ELSE
      RETURN FALSE
   END IF
END FUNCTION

#排除控管聯營料號
FUNCTION  s_ima_except2(p_progno)
DEFINE p_progno  LIKE zz_file.zz01
   IF p_progno = "arti110" OR p_progno = "arti111" OR p_progno = "arti112"
      OR p_progno = "arti120" OR p_progno = "arti121" OR p_progno = "arti122"
     #OR p_progno = "arti131" OR p_progno = "arti132" OR p_progno = "artt111" #TQC-C20357 Mark
      OR p_progno = "arti131" OR p_progno = "arti132" OR p_progno = "arti100" #TQC-C20357 Add
      OR p_progno = "artt100" OR p_progno = "artt111"                         #TQC-C20357 Add
      OR p_progno = "artt121" OR p_progno = "artt122" OR p_progno = "artt131"
      OR p_progno = "artt302" OR p_progno = "artt303" OR p_progno = "artt304"
      OR p_progno = "artt550" OR p_progno = "artt551" OR p_progno = "artt552"
      OR p_progno = "artt603" OR p_progno = "artt604" OR p_progno = "artt605"
      OR p_progno = "artt606" OR p_progno = "artt724" OR p_progno = "artt725"
      OR p_progno = "artt726" OR p_progno = "artt727" 
      OR p_progno = "axmt410" OR p_progno = "axmt620" OR p_progno = "axmt700" 
      OR p_progno = "axmi121" OR p_progno = "aimi100" OR p_progno = "aimi100_icd"
      OR p_progno = "aimi100_slk" OR p_progno = "aimi101" OR p_progno = "aimi103"
      OR p_progno = "aimi104" OR p_progno = "aimi105" OR p_progno = "aimi106"
      OR p_progno = "aimi107" OR p_progno = "aimi108" OR p_progno = "aimi109"
      OR p_progno = "aimi110" OR p_progno = "aimi111" OR p_progno = "aimi112"
      OR p_progno = "aimi113" OR p_progno = "aimi114" OR p_progno = "aimi115" 
      OR p_progno = "aimi120" OR p_progno = "aimi150" OR p_progno = "aimi151"
      OR p_progno = "aimi152" OR p_progno = "aimi153" OR p_progno = "aimi154"
      OR p_progno = "aimi155" OR p_progno = "aimi202" OR p_progno = "aimp001"
      OR p_progno = "aimp100" THEN
                 
      RETURN TRUE
   ELSE
      RETURN FALSE
   END IF
END FUNCTION      
 
#檢查是否設定商品策略
#傳入值 p_plant: 门店
#回傳值 1 / 0    1:聯營     0: 非聯營
#      l_rtz04:商品策略
FUNCTION  s_rtz04_except(p_plant)
DEFINE  p_plant LIKE azw_file.azw01
DEFINE  l_rtz04 LIKE rtz_file.rtz04
DEFINE  l_sql   LIKE type_file.chr1000

   LET l_sql = " SELECT rtz04 FROM ",cl_get_target_table(p_plant,'rtz_file'),
               " WHERE rtz01 = '",p_plant,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql 
   PREPARE sel_rtz_pre1 FROM l_sql 
   EXECUTE sel_rtz_pre1 INTO l_rtz04    
    IF NOT cl_null(l_rtz04) THEN
       RETURN 1,l_rtz04
    ELSE 
       RETURN 0,l_rtz04
    END IF 
END FUNCTION 
#No.FUN-A90048
