/*
================================================================================
檔案代號:cck_file
檔案名稱:每月人工/制费/投入工时档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cck_file
(
cck01       number(5) NOT NULL,      /*年度                                   */
cck02       number(5) NOT NULL,      /*月份                                   */
cck_w       varchar2(10) NOT NULL,   /*成本中心                               */
cck_l       varchar2(2),             /*No Use                                 */
                                     /*No use                                 */
cck03       number(20,6) NOT NULL,   /*人工成本                               */
                                     /*人工成本 (直接輸入)                    */
cck04       number(20,6) NOT NULL,   /*制造费用                               */
                                     /*製造費用 (直接輸入)                    */
cck05       number(15,3) NOT NULL,   /*工时合计                               */
                                     /*工時合計 (由更新作業將 sum(cci05) 轉入 */
cck06       number(20,6) NOT NULL,   /*每小时应分摊人工成本                   */
                                     /*每小時應分攤人工成本                   */
cck07       number(20,6) NOT NULL,   /*每小时应分摊制造费用                   */
                                     /*每小時應分攤製造費用                   */
cckacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
cckuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
cckgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
cckmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
cckdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
cckoriu     varchar2(10),            /*资料建立者                             */
cckorig     varchar2(10),            /*资料建立部门                           */
ccklegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table cck_file add  constraint cck_pk primary key  (cck01,cck02,cck_w) enable validate;
grant select on cck_file to tiptopgp;
grant update on cck_file to tiptopgp;
grant delete on cck_file to tiptopgp;
grant insert on cck_file to tiptopgp;
grant index on cck_file to public;
grant select on cck_file to ods;
