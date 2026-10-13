/*
================================================================================
檔案代號:bgu_file
檔案名稱:请采购预算追加维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bgu_file
(
bgu01       date NOT NULL,           /*追加日期                               */
bgu02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
bgu03       varchar2(10) NOT NULL,   /*版本                                   */
bgu032      varchar2(24),            /*科目编号                               */
                                     /*科目編號                               */
bgu033      varchar2(10),            /*部门编号                               */
                                     /*部門編號                               */
bgu034      number(5),               /*年度                                   */
bgu035      number(5),               /*月份                                   */
bgu04       number(20,6),            /*追加金额                               */
                                     /*追加金額                               */
bguconf     varchar2(1),             /*审核否                                 */
                                     /*確認否                                 */
bguacti     varchar2(1),             /*资料有效码                             */
                                     /*Data Valid Code                        */
                                     /*System Maintain                        */
bguuser     varchar2(10),            /*资料所有者                             */
                                     /*Data Owener                            */
                                     /*System Maintain                        */
bgugrup     varchar2(10),            /*资料所有群                             */
                                     /*Data Group                             */
                                     /*System Maintain                        */
bgumodu     varchar2(10),            /*资料更改者                             */
                                     /*Data Modified By                       */
                                     /*System Maimtain                        */
bgudate     date,                    /*最近更改日                             */
                                     /*Latest Modified Date                   */
                                     /*System Maintain                        */
bguoriu     varchar2(10),            /*资料建立者                             */
bguorig     varchar2(10)             /*资料建立部门                           */
);

alter table bgu_file add  constraint bgu_pk primary key  (bgu01,bgu02,bgu03) enable validate;
grant select on bgu_file to tiptopgp;
grant update on bgu_file to tiptopgp;
grant delete on bgu_file to tiptopgp;
grant insert on bgu_file to tiptopgp;
grant index on bgu_file to public;
grant select on bgu_file to ods;
