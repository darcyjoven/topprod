/*
================================================================================
檔案代號:aac_file
檔案名稱:凭证单别档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table aac_file
(
aac00       varchar2(2),             /*No Use                                 */
aac01       varchar2(5) NOT NULL,    /*单别编号                               */
aac02       varchar2(80),            /*单别名称                               */
aac03       varchar2(1),             /*转帐性质                               */
aac04       varchar2(24),            /*借方凭证或贷方凭证的固定科             */
aacauno     varchar2(1),             /*自动编号否                             */
aac06       varchar2(1),             /*No Use                                 */
aacmxno     varchar2(8),             /*No Use                                 */
aac08       varchar2(1),             /*签核处理                               */
aacatsg     varchar2(1),             /*若需签核是否自动赋予签核等             */
aacsign     varchar2(4),             /*固定等级                               */
aacdays     number(5),               /*签核完成天数                           */
aacprit     number(5),               /*签核优先等级                           */
aacpass     varchar2(1),             /*是否自动审核                           */
                                     /*Auto Confirm? (Y/N)                    */
aac09       varchar2(255),           /*备注                                   */
aac10       varchar2(10),            /*唯一用户                               */
aac11       varchar2(2),             /*凭证性质                               */
                                     /*Voucher Property(1) Nomal (2)Reverse(3)Accrued (4)Accrued Adjustment(5)Last Period (6)Last Year (7)Carry forward(8)Sheet (9)Used Apportion (0) Other(A)Unite Adjustment add on 2001/09/14(B) Audit Adjustment*/
aac12       varchar2(1),             /*接受负值否                             */
aac13       varchar2(5),             /*外币单别否                             */
aac14       varchar2(1),             /*No Use                                 */
aac15       varchar2(1),             /*No Use                                 */
aacacti     varchar2(1),             /*资料有效码                             */
aacuser     varchar2(10),            /*资料所有者                             */
aacgrup     varchar2(10),            /*资料所有部门                           */
aacmodu     varchar2(10),            /*资料更改者                             */
aacdate     date,                    /*最近更改日                             */
aacoriu     varchar2(10),            /*资料建立者                             */
aacorig     varchar2(10),            /*资料建立部门                           */
aac16       varchar2(1) DEFAULT ' ' NOT NULL, /*多账本共享单别*/
aac17       varchar2(80)             /*结转常用摘要                           */
);

alter table aac_file add  constraint aac_pk primary key  (aac01) enable validate;
grant select on aac_file to tiptopgp;
grant update on aac_file to tiptopgp;
grant delete on aac_file to tiptopgp;
grant insert on aac_file to tiptopgp;
grant index on aac_file to public;
grant select on aac_file to ods;
