/*
================================================================================
檔案代號:nqe_file
檔案名稱:预计资金
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nqe_file
(
nqe01       varchar2(10) NOT NULL,   /*来源营运中心                           */
nqe02       varchar2(4) NOT NULL,    /*营运币种                               */
nqe03       date NOT NULL,           /*日期                                   */
nqe04       varchar2(1),             /*变动分类                               */
nqe05       varchar2(3) NOT NULL,    /*类型                                   */
nqe06       varchar2(255),           /*备注                                   */
nqe07       varchar2(4),             /*交易币种                               */
nqe08       number(20,10),           /*汇率                                   */
nqe09       varchar2(1),             /*异动存提 (1.存 2.提)                   */
nqe10       number(20,6),            /*原币金额                               */
nqe11       number(20,6),            /*营运金额                               */
nqe12       varchar2(1),             /*实现否(y/n)                            */
nqe13       varchar2(20),            /*银行编号                               */
nqe14       varchar2(1),             /*No Use                                 */
nqe15       varchar2(1),             /*No Use                                 */
nqeacti     varchar2(1),             /*资料有效码                             */
nqeuser     varchar2(10),            /*资料所有者                             */
nqegrup     varchar2(10),            /*资料所有群                             */
nqemodu     varchar2(10),            /*资料更改者                             */
nqedate     date,                    /*最近更改日                             */
nqeorig     varchar2(10),            /*资料建立部门                           */
nqeoriu     varchar2(10)             /*资料建立者                             */
);

alter table nqe_file add  constraint nqe_pk primary key  (nqe01,nqe02,nqe03,nqe05) enable validate;
grant select on nqe_file to tiptopgp;
grant update on nqe_file to tiptopgp;
grant delete on nqe_file to tiptopgp;
grant insert on nqe_file to tiptopgp;
grant index on nqe_file to public;
grant select on nqe_file to ods;
