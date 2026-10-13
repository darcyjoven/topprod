/*
================================================================================
檔案代號:bgp_file
檔案名稱:直接材料用料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bgp_file
(
bgp01       varchar2(10) NOT NULL,   /*版本                                   */
bgp02       number(5) NOT NULL,      /*年度                                   */
bgp03       number(5) NOT NULL,      /*期别                                   */
                                     /*期別                                   */
bgp04       varchar2(40) NOT NULL,   /*料号                                   */
                                     /*料號                                   */
bgp05       number(20,6),            /*单价                                   */
                                     /*單價                                   */
bgp06       number(15,3),            /*数量                                   */
                                     /*數量                                   */
bgp07       number(20,6),            /*金额                                   */
                                     /*金額                                   */
bgp08       date,                    /*应付款日                               */
                                     /*應付款日 add in 2003/10/15   no.8563   */
bgp09       date,                    /*票据到期日                             */
                                     /*票據到期日add in 2003/10/15  no.8563   */
bgp10       varchar2(1),             /*No Use                                 */
bgp11       varchar2(4),             /*采购单位                               */
                                     /*採購單位   No.8563 031104              */
bgp11_fac   number(20,8)             /*采购单位/库存单位换算率                */
                                     /*採購單位/庫存單位換算率 No.8563 031104 */
);

alter table bgp_file add  constraint bgp_pk primary key  (bgp01,bgp02,bgp03,bgp04) enable validate;
grant select on bgp_file to tiptopgp;
grant update on bgp_file to tiptopgp;
grant delete on bgp_file to tiptopgp;
grant insert on bgp_file to tiptopgp;
grant index on bgp_file to public;
grant select on bgp_file to ods;
