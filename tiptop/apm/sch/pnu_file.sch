/*
================================================================================
檔案代號:pnu_file
檔案名稱:请采购预算追加记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pnu_file
(
pnu01       date NOT NULL,           /*追加日期                               */
pnu02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
pnu031      varchar2(10),            /*预算项目                               */
                                     /*預算編號                               */
pnu032      varchar2(24),            /*科目编号                               */
                                     /*科目編號                               */
pnu033      varchar2(10),            /*部门编号                               */
                                     /*部門編號                               */
pnu034      number(5),               /*年度                                   */
pnu035      number(5),               /*月份                                   */
pnu04       number(20,6),            /*追加金额                               */
                                     /*追加金額                               */
pnuconf     varchar2(1),             /*审核否                                 */
                                     /*確認否                                 */
pnuacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
                                     /*系統維護                               */
pnuuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
                                     /*系統維護                               */
pnugrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
                                     /*系統維護                               */
pnumodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
                                     /*系統維護                               */
pnudate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
                                     /*系統維護                               */
pnu036      varchar2(30),            /*WBS编码                                */
pnu037      varchar2(5),             /*帐套                                   */
pnu038      varchar2(10),            /*项目编号                               */
pnuoriu     varchar2(10),            /*资料建立者                             */
pnuorig     varchar2(10)             /*资料建立部门                           */
);

alter table pnu_file add  constraint pnu_pk primary key  (pnu01,pnu02) enable validate;
grant select on pnu_file to tiptopgp;
grant update on pnu_file to tiptopgp;
grant delete on pnu_file to tiptopgp;
grant insert on pnu_file to tiptopgp;
grant index on pnu_file to public;
grant select on pnu_file to ods;
