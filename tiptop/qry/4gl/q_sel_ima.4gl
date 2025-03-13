# Prog. Version..: '5.30.06-13.04.08(00010)'     #
#
# Program name...: q_sel_ima.4gl
# Descriptions...: 料件開窗
# Date & Author..: FUN-A90048 10/09/25 By huangtao  
# Usage..........: CALL q_sel_ima(mi_multi_sel,mi_qry, ms_cons_where,ms_default
#                                  ,ms_arg1,ms_arg2,ms_arg3,ms_arg4,ms_arg5,p_plant)
# Input PARAMETER: mi_multi_sel : 是否需要複選資料(TRUE/FALSE)
#                  mi_qry :  原料件開窗 ( 傳入 q_imaxxx )
#                  ms_cons_where : 原 q_imaxxx 開窗需傳入的 WHERE條件. (對應原程式中的 q_qryparam.where)
#                  ms_default:  原欄位 default (對應原程式中的 q_qryparam.default1)
#                  ms_arg1:  原開窗的傳入參數1 (對應原程式中的 q_qryparam.arg1)
#                  ms_arg2:  原開窗的傳入參數2 (對應原程式中的 q_qryparam.arg2)
#                  ms_arg3:  原開窗的傳入參數3 (對應原程式中的 q_qryparam.arg3)
#                  ms_arg4:  原開窗的傳入參數4 (對應原程式中的 q_qryparam.arg4)
#                  ms_arg5:  原開窗的傳入參數5 (對應原程式中的 q_qryparam.arg5)
#                  p_plant:  營運中心
# RETURN Code....: 開窗料號回傳值
# Modify.........: No:FUN-AA0047 10/10/22 By huangtao
# Modify.........: No:FUN-A90049 10/10/26 By huangtao
# Modify.........: No:FUN-AB0025 10/11/11 By huangtao mod s_ima_except1()
# Modify.........: No:MOD-B30256 11/03/12 By lixia 無法跨庫查詢
# Modify.........: No:TQC-B60157 11/06/21 By shiwuying ima_file外聯，NOT IN實現不了，改成EXISTS
# Modify.........: No:TQC-B90236 11/10/25 By zhuhao 僅訂單才能輸入特性主料
# Modify.........: No:TQC-C20348 12/02/22 By lixiang 服飾零售業下母料件的開窗，開母料件和非多屬性料件,加上傳入的where條件
# Modify.........: No:FUN-C20072 12/03/05 By xjll    考慮GWC 那邊需要調用故修改p_sys 和g_prog
# Modify.........: No:MOD-C30434 12/03/19 By zhuhao 加入匹配條件
# Modify.........: No:FUN-C30230 12/04/05 By xjll   WPC 模组修改
# Modify.........: No:FUN-C30057 12/04/23 By lixiang 服飾零售業增加apmt580_slk的料件開窗
# Modify.........: No:FUN-C60086 12/06/25 By xjll arti120 產品策略開窗在服飾流通行業下不可開母料件編號
# Modify.........: No:TQC-C90123 12/09/29 By baogc ms_cons_where定義為String
# Modify.........: No:FUN-CA0053 12/10/12 By xjll 添加wpct007 商品策略开窗
# Modify.........: No:FUN-CB0097 12/11/21 By qiaozy 添加wpct011 商品策略开窗
# Modify.........: No:FUN-CB0141 12/11/30 By qiaozy 添加wpct009,wpct010 商品策略开窗
# Modify.........: No:FUN-C30033 13/04/01 By Elise 估報價單等前端單據要可輸入特性主料

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION  q_sel_ima(mi_multi_sel,mi_qry, ms_cons_where,ms_default,
                     ms_arg1,ms_arg2,ms_arg3,ms_arg4,ms_arg5,p_plant)
DEFINE mi_multi_sel LIKE type_file.chr18
DEFINE mi_qry       LIKE type_file.chr18
#DEFINE ms_cons_where LIKE type_file.chr1000 #TQC-C90123 Mark
DEFINE ms_cons_where STRING                  #TQC-C90123 Add
DEFINE ms_default   LIKE type_file.chr1000
DEFINE ms_arg1      LIKE type_file.chr100
DEFINE ms_arg2      LIKE type_file.chr100
DEFINE ms_arg3      LIKE type_file.chr100
DEFINE ms_arg4      LIKE type_file.chr100
DEFINE ms_arg5      LIKE type_file.chr100
DEFINE p_plant      LIKE azw_file.azw01     
DEFINE p_sys        LIKE zz_file.zz011            #模組別
DEFINE p_progno     LIKE zz_file.zz01             #程式名稱
DEFINE l_rtz04_except LIKE type_file.num5         #營運中心是否尋在商品策略
DEFINE l_rtz04      LIKE rtz_file.rtz04           #商品策略
DEFINE l_ima01      LIKE ima_file.ima01

   IF cl_null( p_plant) THEN
      LET p_plant = g_plant
   ELSE                                              #FUN-A90049
      LET g_qryparam.plant = p_plant                 #FUN-A90049
   END IF
   LET p_progno = g_prog
   SELECT zz011 INTO p_sys FROM zz_file WHERE zz01 = p_progno 
   LET p_sys = UPSHIFT(p_sys)     
   CALL cl_init_qry_var() 
   IF mi_multi_sel  THEN    
      LET g_qryparam.state = "c"
   ELSE
      LET g_qryparam.state = "i"
   END IF
#FUN-AA0047 -----------start
   IF NOT cl_null( ms_default ) THEN
      LET g_qryparam.default1= ms_default CLIPPED                            
   END IF
#FUN-AA0047 -----------end
   CALL s_rtz04_except(p_plant) RETURNING l_rtz04_except,l_rtz04
   IF NOT l_rtz04_except THEN   #開窗為原本的開窗
#N0.TQC-B90236------add------start-----------
     #IF NOT(p_progno[1,7] = "axmt410" OR p_progno[1,7] = "axmt800") THEN  #FUN-C30033 mark
     #FUN-C30033---S
      IF NOT(p_progno[1,7]='axmt410' OR p_progno[1,7]='axmt800' OR p_progno[1,7]='apmt420'
          OR p_progno[1,7]='apmt540' OR p_progno[1,7]='apmi303' OR p_progno[1,7]='abmi600'
          OR p_progno[1,7]='asfi301' OR p_progno[1,7]='axmt400' OR p_progno[1,7]='axmt810'
          OR p_progno[1,7]='axmt310' OR p_progno[1,7]='axmt360' OR p_progno[1,7]='axmt400'
             ) THEN
     #FUN-C30033---E
         IF cl_null(ms_cons_where) THEN
            #FUN-C60086----add----begin-------
            IF s_industry("slk") AND g_azw.azw04 = '2' AND (p_progno[1,7] = "arti110" 
               OR p_progno[1,7] = "arti120" OR p_progno[1,7] = "arti121") THEN 
               LET ms_cons_where = " (ima928 = 'N' OR ima928 IS NULL OR ima928 = ' ' ) AND ima151 <> 'Y' " 
            ELSE 
            #FUN-C60086----add----end---------
               LET ms_cons_where = " (ima928 = 'N' OR ima928 IS NULL OR ima928 = ' ' ) "   #MOD-C30434 add ima928 is null
            END IF   #FUN-C60086--add
          
         ELSE
            #FUN-C60086----add----begin-------
            IF s_industry("slk") AND g_azw.azw04 = '2' AND (p_progno[1,7] = "arti110" 
               OR p_progno[1,7] = "arti120" OR p_progno[1,7] = "arti121") THEN
               LET ms_cons_where = ms_cons_where, " AND (ima928 = 'N' OR ima928 IS NULL OR ima928 = ' ' ) AND ima151 <> 'Y' "
            ELSE
            #FUN-C60086----add----end---------
               LET ms_cons_where = ms_cons_where, " AND (ima928 = 'N' OR ima928 IS NULL OR ima928 = ' ' ) "   #MOD-C30434 add ima928 is null
            END IF   #FUN-C60086--add
         END IF
      END IF
#No.TQC-B90236------add------end-------------
      CALL  q_def_qry(mi_qry,ms_cons_where,ms_default,ms_arg1, ms_arg2, ms_arg3,
                        ms_arg4, ms_arg5)
   ELSE
      CASE 
#FUN-C30230--mark---begin--------------------
#FUN-C20072------add-----------------begin---------------------
#     WHEN p_sys = "WPC" 
#         #LET g_qryparam.form =  "q_ima01_slk"   #FUN-C30230--mark 
#          IF p_progno = "wpct004_slk" OR p_progno = "wpct005_slk" THEN
#             LET g_qryparam.form =  "q_ima01_slk"   #FUN-C30230--add
#             LET g_qryparam.where =  " (ima01 IN (SELECT DISTINCT(COALESCE(imx00,rte03)) ",
#                                                 "  FROM rte_file LEFT JOIN imx_file ON imx000=rte03",
#                                                 "  WHERE rte01='",l_rtz04,"'))"
#          END IF
#          IF p_progno = "wpct001_slk" OR p_progno = "wpct002_slk" THEN
#             LET g_qryparam.form =  "q_ima01_slk"   #FUN-C30230--add
#             LET g_qryparam.where =  " (ima01 IN (SELECT DISTINCT(COALESCE(imx00,rte03)) ",
#                                                 "  FROM rte_file LEFT JOIN imx_file ON imx000=rte03",
#                                                 "  WHERE rte01='",l_rtz04,"' AND rte04 = 'Y'))"
#          END IF
#          IF p_progno = "wpct700_slk" THEN
#             LET g_qryparam.form =  "q_ima01_slk"   #FUN-C30230--add
#             LET g_qryparam.where =  " (ima01 IN (SELECT DISTINCT(COALESCE(imx00,rte03)) ",
#                                                 "  FROM rte_file LEFT JOIN imx_file ON imx000=rte03",
#                                                 "  WHERE rte01='",l_rtz04,"' AND rte06='Y'))"
#          END IF
#          
#FUN-C20072------end-------------------------------------------
#FUN-C30230---mark---end------------------------------------
        WHEN  p_sys = "ALM" OR p_sys = "CLM"
           LET g_qryparam.form =  "q_rte00"       #開窗內容應為該門店設定的產品策略內容, 且 join ima_file
           LET g_qryparam.arg1= l_rtz04            #傳入產品策略
           LET g_qryparam.where = " 1 = 1 "
        WHEN  p_sys = "ART" OR p_sys = "CRT " OR p_progno = "wpct003" OR p_progno = "wpct004"   #FUN-CA0053--add--wpct003 ,wpct004
              OR p_progno = "wpct005" OR p_progno = "wpct015"    #FUN-CB0097---add
           LET g_qryparam.form =  "q_rte00"         #開窗內容應為該門店設定的產品策略內容,且 join ima_file   
           LET g_qryparam.arg1= l_rtz04             #傳入產品策略
         #TQC-C20348--add--begin--
           IF s_industry("slk") THEN
              IF p_progno = "artt256" OR p_progno = "artt212" THEN
                 LET g_qryparam.form =  "q_ima01_slk"         #開窗內容應為該門店設定的產品策略內容,且 join ima_file
                 LET g_qryparam.where =  " (ima01 IN (SELECT DISTINCT(COALESCE(imx00,rte03)) ",
                                                  "  FROM rte_file LEFT JOIN imx_file ON imx000=rte03",
                                                  "  WHERE rte01='",l_rtz04,"'))"
              END IF                                                        #FUN-C60086--add 
              IF g_azw.azw04 = '2' AND (p_progno = 'arti110' OR p_progno = 'arti120' OR p_progno = 'arti121') THEN      #FUN-C60086--add
                 LET g_qryparam.where = " ima151 <> 'Y' "                   #FUN-C60086--add
              ELSE
                 LET g_qryparam.where = " 1 = 1 "
              END IF  
           ELSE 
         #TQC-C20348--add--end--     
              LET g_qryparam.where = " 1 = 1 "
           END IF   #TQC-C20348 add
        WHEN  p_sys = "AXM" OR p_sys = "CXM"  
           LET g_qryparam.form =  "q_rte00"        #開窗內容應為該門店設定的產品策略內容,且 join ima_file  
           LET g_qryparam.arg1= l_rtz04             #傳入產品策略
         #TQC-C20348--add--begin--
           IF g_azw.azw04 = '2' THEN
              IF p_progno = "axmt410_slk" OR p_progno = "axmt610_slk" 
              OR p_progno = "axmt620_slk" OR p_progno = "axmt400_slk" 
              OR p_progno = "axmt420_slk" OR p_progno = "axmt810_slk" 
              OR p_progno = "axmt628_slk" OR p_progno = "axmt629_slk"
              OR p_progno = "axmt640_slk" THEN
                 LET g_qryparam.form =  "q_ima01_slk"         #開窗內容應為該門店設定的產品策略內容,且 join ima_file
                 LET g_qryparam.where =  " (ima01 IN (SELECT DISTINCT(COALESCE(imx00,rte03)) ",
                                                  "  FROM rte_file LEFT JOIN imx_file ON imx000=rte03",
                                                  "  WHERE rte01='",l_rtz04,"' AND rte05='Y'))"
              ELSE
                 IF p_progno = "axmt700_slk" THEN
                     LET g_qryparam.form =  "q_ima01_slk"         #開窗內容應為該門店設定的產品策略內容,且 join ima_file
                     LET g_qryparam.where =  " (ima01 IN (SELECT DISTINCT(COALESCE(imx00,rte03)) ",
                                                  "  FROM rte_file LEFT JOIN imx_file ON imx000=rte03",
                                                  "  WHERE rte01='",l_rtz04,"' AND rte06='Y'))"
                 ELSE
                    IF p_progno = "axmt700" OR p_progno = "axmt840" THEN   #銷退相關，產品策略應為可退
                       LET g_qryparam.where = " rte06 = 'Y' "   #加上"可退"條件
                    ELSE
                       LET g_qryparam.where = " rte05 = 'Y' "   #加上"可售"條件
                    END IF  
                 END IF  
              END IF
           ELSE 
         #TQC-C20348--add--end--
              IF p_progno = "axmt700" OR p_progno = "axmt840" THEN   #銷退相關，產品策略應為可退
                 LET g_qryparam.where = " rte06 = 'Y' "   #加上"可退"條件
              ELSE
                 LET g_qryparam.where = " rte05 = 'Y' "   #加上"可售"條件   
              END IF
           END IF    #TQC-C20348 add

        WHEN  p_sys = "APM" OR p_sys = "CPM" OR p_progno = "wpct008" OR p_progno = "wpct010"   #FUN-CA0053--add wpct008 #FUN-CB0141-ADD WPCT010
           LET g_qryparam.form =  "q_rte00"      #開窗內容應為該門店設定的產品策略內容,且 join ima_file  
           LET g_qryparam.arg1= l_rtz04            #傳入產品策略 
         #TQC-C20348--add--begin--
           IF g_azw.azw04 = '2' THEN
              IF p_progno = "apmt420_slk" OR p_progno = "apmt540_slk" OR p_progno = "apmt110_slk" 
                 OR p_progno = "apmt720_slk" OR p_progno = "apmt722_slk" OR p_progno = "apmt590_slk" 
                 OR p_progno = "apmt580_slk" THEN    #FUN-C30057--add
                 LET g_qryparam.form =  "q_ima01_slk"         #開窗內容應為該門店設定的產品策略內容,且 join ima_file
                 LET g_qryparam.where =  " (ima01 IN (SELECT DISTINCT(COALESCE(imx00,rte03)) ",
                                                  "  FROM rte_file LEFT JOIN imx_file ON imx000=rte03",
                                                  "  WHERE rte01='",l_rtz04,"' AND rte04 = 'Y'))"   
              ELSE
                 LET g_qryparam.where = " rte04 = 'Y'  "   #加上"可採"條件
              END IF
           ELSE
         #TQC-C20348--add--end--
              LET g_qryparam.where = " rte04 = 'Y'  "   #加上"可採"條件
           END IF    #TQC-C20348 add
        WHEN  p_sys = "AIM" OR p_sys = "CIM" OR p_progno = "wpct301" OR p_progno = "wpct302" OR p_progno = "wpct303"  #FUN-CA0053--add wpct301,wpct302,wpct303 
           LET g_qryparam.form =  "q_rte00"       #開窗內容應為該門店設定的產品策略內容,且 join ima_file 
           LET g_qryparam.arg1= l_rtz04            #傳入產品策略
#TQC-C20348--add--begin-------------------------
          IF s_industry("slk") THEN
             IF p_progno = "aimt301_slk" OR p_progno = "aimt302_slk" OR p_progno = "aimt303_slk" THEN
                LET g_qryparam.form =  "q_ima01_slk"         #開窗內容應為該門店設定的產品策略內容,且 join ima_file
                LET g_qryparam.where =  " (ima01 IN (SELECT DISTINCT(COALESCE(imx00,rte03)) ",
                                                  "  FROM rte_file LEFT JOIN imx_file ON imx000=rte03",
                                                  "  WHERE rte01='",l_rtz04,"'))"
             ELSE
                LET g_qryparam.where = " 1 = 1 "
             END IF
          ELSE 
#TQC-C2034--add-----end------------------------
             LET g_qryparam.where = " 1 = 1 "
          END IF    ##TQC-C20348--add
#FUN-CB0097----ADD----STR----
          WHEN  p_progno[1,7] = "wpct011" OR p_progno[1,7] = "wpct007" OR p_progno[1,7] = "wpct009" #FUN-CB0141-ADD WPCT009
             LET g_qryparam.form =  "q_rte00"       #開窗內容應為該門店設定的產品策略內容
             LET g_qryparam.arg1= l_rtz04            #傳入產品策略
             LET g_qryparam.where = " 1=1 " 
#FUN-CB0097----ADD----END----
        OTHERWISE                  #其他模組開原本的開窗     
#N0.TQC-B90236------add------start-----------
           IF NOT(p_progno[1,7] = "axmt410" OR p_progno[1,7] = "axmt800") THEN
              IF cl_null(ms_cons_where) THEN
                 LET ms_cons_where = " (ima928 = 'N' OR ima928 IS NULL OR ima928 = ' ' ) "    #MOD-C30434 add ima928 is null
              ELSE
                 LET ms_cons_where = ms_cons_where, " AND (ima928 = 'N' OR ima928 IS NULL OR ima928 = ' ') "    #MOD-C30434 add ima928 is null
              END IF
           END IF
#No.TQC-B90236------add------end-------------
#FUN-C30230--add-------begin--------------   
           IF p_progno = "wpct004_slk" OR p_progno = "wpct005_slk" THEN
              LET g_qryparam.form =  "q_ima01_slk"   #FUN-C30230--add
              LET g_qryparam.where =  " (ima01 IN (SELECT DISTINCT(COALESCE(imx00,rte03)) ",
                                                  "  FROM rte_file LEFT JOIN imx_file ON imx000=rte03",
                                                  "  WHERE rte01='",l_rtz04,"'))"
           END IF
           IF p_progno = "wpct001_slk" OR p_progno = "wpct002_slk" THEN
              LET g_qryparam.form =  "q_ima01_slk"   #FUN-C30230--add
              LET g_qryparam.where =  " (ima01 IN (SELECT DISTINCT(COALESCE(imx00,rte03)) ",
                                                  "  FROM rte_file LEFT JOIN imx_file ON imx000=rte03",
                                                  "  WHERE rte01='",l_rtz04,"' AND rte04 = 'Y'))"
           END IF
           IF p_progno = "wpct700_slk" THEN
              LET g_qryparam.form =  "q_ima01_slk"   #FUN-C30230--add
              LET g_qryparam.where =  " (ima01 IN (SELECT DISTINCT(COALESCE(imx00,rte03)) ",
                                                  "  FROM rte_file LEFT JOIN imx_file ON imx000=rte03",
                                                  "  WHERE rte01='",l_rtz04,"' AND rte06='Y'))"
           END IF
#FUN-C30230---add---end--------------------
           CALL  q_def_qry(mi_qry,ms_cons_where,ms_default,ms_arg1, ms_arg2,
                              ms_arg3,ms_arg4, ms_arg5)
      END CASE       
   END IF
  #IF p_sys  <> "ALM" OR p_sys <> "CLM" THEN  #No.FUN-A90049
   IF p_sys  <> "ALM" AND p_sys <> "CLM" THEN #No.FUN-A90049 By shi
  #    IF NOT s_ima_except1(p_progno) THEN     #不用控卡企業料號的程式                #FUN-AB0025  mark
       IF NOT s_ima_except1(p_progno,p_plant) THEN                                    #FUN-AB0025
          LET g_qryparam.where = g_qryparam.where CLIPPED,
                      "  AND (ima120 IS NULL OR ima120 = ' ' OR ima120 = '1') "
      END IF                
      IF NOT s_ima_except2(p_progno) THEN    #不用控卡聯營料號的程式
        #TQC-B60157 Begin---
        #LET g_qryparam.where = g_qryparam.where CLIPPED, "  AND ima01 NOT IN ",
        #       "( SELECT rty02 FROM rty_file WHERE rty01 = '", p_plant CLIPPED, 
        #       "' AND rty06 = '4'  AND rtyacti = 'Y'  ) "
         LET g_qryparam.where = g_qryparam.where CLIPPED,
                "   AND NOT EXISTS (SELECT 1 FROM rty_file ",
                "                    WHERE rty01 = '", p_plant CLIPPED,"'",
                "                      AND rty02 = ima01 ",
                "                      AND rty06 = '4'  AND rtyacti = 'Y'  ) "
        #TQC-B60157 End-----
      END IF
   END IF   
   LET g_qryparam.plant = p_plant    #MOD-B30256
   IF mi_multi_sel  THEN 
      CALL cl_create_qry() RETURNING g_qryparam.multiret 
      RETURN  g_qryparam.multiret 
   ELSE
      CALL cl_create_qry() RETURNING  l_ima01  
      RETURN  l_ima01 
   END IF
END FUNCTION  


FUNCTION  q_def_qry(mi_qry,ms_cons_where,ms_default,ms_arg1, ms_arg2, ms_arg3,
                        ms_arg4, ms_arg5)    #開傳入的原始開窗
DEFINE mi_qry       LIKE type_file.chr18
#DEFINE ms_cons_where LIKE type_file.chr1000  #TQC-C90123 Mark
DEFINE ms_cons_where STRING                   #TQC-C90123 Add
DEFINE ms_default   LIKE type_file.chr1000
DEFINE ms_arg1      LIKE type_file.chr100
DEFINE ms_arg2      LIKE type_file.chr100
DEFINE ms_arg3      LIKE type_file.chr100
DEFINE ms_arg4      LIKE type_file.chr100
DEFINE ms_arg5      LIKE type_file.chr100
   LET g_qryparam.form =  mi_qry       #程式中傳入的 原開窗
   IF NOT cl_null(ms_cons_where)  THEN
      LET g_qryparam.where = ms_cons_where  CLIPPED
   ELSE
      LET g_qryparam.where = " 1= 1 "
   END IF
   IF NOT cl_null( ms_default ) THEN
      LET g_qryparam.default1= ms_default CLIPPED
   END IF
   IF NOT cl_null( ms_arg1 ) THEN
      LET g_qryparam.arg1= ms_arg1 CLIPPED
   END IF
   IF NOT cl_null( ms_arg2 ) THEN
      LET g_qryparam.arg2= ms_arg2 CLIPPED
   END IF
   IF NOT cl_null( ms_arg3 ) THEN
      LET g_qryparam.arg3= ms_arg3 CLIPPED
   END IF
   IF NOT cl_null( ms_arg4 ) THEN
      LET g_qryparam.arg4= ms_arg4 CLIPPED
   END IF
   IF NOT cl_null( ms_arg5 ) THEN
      LET g_qryparam.arg5= ms_arg5 CLIPPED
   END IF
   
END FUNCTION
#No.FUN-A90048
