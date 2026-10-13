/*
================================================================================
檔案代號:wsa_file
檔案名稱:EasyFlow 集成资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wsa_file
(
wsa01       varchar2(20) NOT NULL,   /*程序编号                               */
                                     /*程式代號                               */
wsa02       varchar2(15),            /*程序使用单头档                         */
                                     /*程式使用單頭檔                         */
wsa03       varchar2(20),            /*单头档单号字段                         */
                                     /*單頭檔單號欄位                         */
wsa04       varchar2(20),            /*单头档状态值字段                       */
                                     /*單頭檔狀態值欄位                       */
wsa05       varchar2(15),            /*程序使用单身档                         */
                                     /*程式使用單身檔                         */
wsa06       varchar2(20),            /*单身档单号字段                         */
                                     /*單身檔單號欄位                         */
wsa07       varchar2(20),            /*单身档状态值字段                       */
                                     /*單身檔狀態值欄位                       */
wsa08       varchar2(15),            /*使用单据性质档                         */
                                     /*使用單據性質檔                         */
wsa09       varchar2(20),            /*单据档单别字段                         */
                                     /*單據檔單別欄位                         */
wsa10       varchar2(30),            /*单据档单据名称字段                     */
                                     /*單據檔單據名稱欄位                     */
wsa11       varchar2(20),            /*单据档系统字段                         */
                                     /*單據檔系統別欄位                       */
wsa12       varchar2(20),            /*单据档单据性质字段                     */
                                     /*單據檔單據性質欄位                     */
wsa13       varchar2(2),             /*程序所属单据性质编号                   */
                                     /*程式所屬單據性質代號                   */
wsa14       varchar2(20),            /*单据档签核处理字段                     */
                                     /*單據檔簽核處理欄位                     */
wsaacti     varchar2(1),             /*资料有效码                             */
wsauser     varchar2(10),            /*资料所有者                             */
wsagrup     varchar2(10),            /*资料所有部门                           */
wsamodu     varchar2(10),            /*资料更改者                             */
wsadate     date,                    /*最近更改日                             */
wsa15       varchar2(5),             /*单据系统                               */
wsaorig     varchar2(10),            /*资料建立部门                           */
wsaoriu     varchar2(10)             /*资料建立者                             */
);

alter table wsa_file add  constraint wsa_pk primary key  (wsa01) enable validate;
grant select on wsa_file to tiptopgp;
grant update on wsa_file to tiptopgp;
grant delete on wsa_file to tiptopgp;
grant insert on wsa_file to tiptopgp;
grant index on wsa_file to public;
grant select on wsa_file to ods;
