/*
================================================================================
檔案代號:api_file
檔案名稱:再细分明细科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table api_file
(
api01       varchar2(20),            /*帐款编号                               */
                                     /*帳款編號                               */
api02       varchar2(2),             /*明细种类                               */
                                     /*明細種類                               */
                                     /*  1.多借方  (當apa51='MISC')           */
                                     /*  2.沖暫估AP(當apa51='UNAP')           */
api03       number(5),               /*项次                                   */
                                     /*項次                                   */
api04       varchar2(24),            /*科目编号                               */
                                     /*科目編號                               */
api05f      number(20,6),            /*原币金额                               */
                                     /*原幣金額                               */
api05       number(20,6),            /*本币金额                               */
                                     /*本幣金額                               */
api06       varchar2(255),           /*摘要                                   */
api061      varchar2(1),             /*No Use                                 */
api062      varchar2(1),             /*No Use                                 */
api07       varchar2(10),            /*部门                                   */
                                     /*部門                                   */
api21       varchar2(30),            /*核算项-1                               */
                                     /*異動碼-1                               */
api22       varchar2(30),            /*核算项-2                               */
                                     /*異動碼-2                               */
api23       varchar2(30),            /*核算项-3                               */
                                     /*異動碼-3                               */
api24       varchar2(30),            /*核算项-4                               */
                                     /*異動碼-4                               */
api25       varchar2(10),            /*预算编号                               */
                                     /*預算編號                               */
api26       varchar2(20),            /*项目编号/暂估帐款编号                  */
                                     /*專案編號                               */
api31       varchar2(30),            /*核算项-5                               */
                                     /*#FUN-5C0015                            */
api32       varchar2(30),            /*核算项-6                               */
                                     /*#FUN-5C0015                            */
api33       varchar2(30),            /*核算项-7                               */
                                     /*#FUN-5C0015                            */
api34       varchar2(30),            /*核算项-8                               */
                                     /*#FUN-5C0015                            */
api35       varchar2(30),            /*核算项-9                               */
                                     /*#FUN-5C0015                            */
api36       varchar2(30),            /*核算项-10                              */
                                     /*#FUN-5C0015                            */
api37       varchar2(30),            /*关系人异动码                           */
                                     /*#FUN-5C0015                            */
api40       number(5),               /*子帐期项次                             */
api041      varchar2(24),            /*科目编号二                             */
api930      varchar2(10),            /*成本中心                               */
apilegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index api_01 on api_file (api01,api02,api03);
grant select on api_file to tiptopgp;
grant update on api_file to tiptopgp;
grant delete on api_file to tiptopgp;
grant insert on api_file to tiptopgp;
grant index on api_file to public;
grant select on api_file to ods;
