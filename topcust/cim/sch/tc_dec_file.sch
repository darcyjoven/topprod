/*
================================================================================
檔案代號:tc_dec_file
檔案名稱:demo作业单身资料2
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_dec_file
(
tc_dec01    varchar2(20) NOT NULL,   /*demo单号                               */
tc_dec02    number(5) NOT NULL,      /*demo项次                               */
tc_dec03    number(5) NOT NULL,      /*demo修改班次                           */
tc_dec04    number(5) NOT NULL,      /*demo项序                               */
tc_dec05    varchar2(1),             /*demo                                   */
tc_dec06    varchar2(20),            /*demobtnedit                            */
tc_dec07    varchar2(20),            /*demoComboBox                           */
tc_dec08    varchar2(5),             /*RadioGroup                             */
tc_dec09    number(5),               /*Slider                                 */
tc_dec10    number(5),               /*SpinEdit                               */
tc_dec11    varchar2(20),            /*TimeEdit                               */
tc_dec12    varchar2(500),           /*Image                                  */
tc_dec13    varchar2(500),           /*WebComponent                           */
tc_dec14    varchar2(1000),          /*demo备注                               */
tc_dec15    date NOT NULL,           /*demo创建时间                           */
tc_dec16    varchar2(20) NOT NULL,   /*demo创建人员                           */
tc_dec17    date NOT NULL,           /*demo修改时间                           */
tc_dec18    varchar2(20) NOT NULL,   /*demo修改人员                           */
tc_dec19    date NOT NULL,           /*demo审核时间                           */
tc_dec20    varchar2(20) NOT NULL,   /*demo审核人员                           */
tc_decud01  varchar2(20),
tc_decud02  varchar2(20),
tc_decud03  varchar2(20),
tc_decud04  number(5),
tc_decud05  number(5),
tc_decud06  number(5),
tc_decud07  date,
tc_decud08  date,
tc_decud09  date,
tc_decud10  varchar2(1000)
);

create unique index tic_dec_01 on tc_dec_file (tc_dec01,tc_dec02,tc_dec03,tc_dec04);
grant select on tc_dec_file to tiptopgp;
grant update on tc_dec_file to tiptopgp;
grant delete on tc_dec_file to tiptopgp;
grant insert on tc_dec_file to tiptopgp;
grant index on tc_dec_file to public;
grant select on tc_dec_file to ods;
