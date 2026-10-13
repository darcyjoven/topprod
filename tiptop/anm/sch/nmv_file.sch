/*
================================================================================
檔案代號:nmv_file
檔案名稱:网络银行配置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nmv_file
(
nmv01       varchar2(10) NOT NULL,   /*网络银行接口编码                       */
nmv02       varchar2(23),            /*网络银行主机IP                         */
nmv03       varchar2(10),            /*网络银行登陆帐号                       */
nmv04       varchar2(10),            /*网络银行登陆口令                       */
nmv05       varchar2(80),            /*网络银行名称                           */
nmv06       varchar2(10) NOT NULL,   /*TIPTOP登录帐号                         */
nmv07       varchar2(10),            /*网银登录卡口令                         */
nmv08       varchar2(30) NOT NULL,   /*可使用银行编号                         */
nmv09       varchar2(20),            /*HSBC Connect Customer ID               */
nmv10       varchar2(18),            /*HSBCnet Customer ID                    */
nmv11       varchar2(20),            /*ACH协议号码                            */
nmv12       varchar2(3),             /*支付文件参考号(文件名)前缀             */
nmv13       varchar2(10),            /*文件参考号                             */
nmv14       date,                    /*文件参考号日期                         */
nmv15       varchar2(1),             /*支付文件名编码方式                     */
nmv16       varchar2(1),             /*授权模式                               */
nmv17       varchar2(10),            /*文件借口版本                           */
nmv18       varchar2(1),             /*文件编码方式                           */
nmv19       varchar2(1),             /*启用Email通知功能                      */
nmv20       varchar2(1),             /*Email文件格式                          */
nmv21       varchar2(1),             /*是否通知明细                           */
nmv22       varchar2(1)              /*通知明细格式                           */
);

alter table nmv_file add  constraint nmv_pk primary key  (nmv01,nmv06,nmv08) enable validate;
grant select on nmv_file to tiptopgp;
grant update on nmv_file to tiptopgp;
grant delete on nmv_file to tiptopgp;
grant insert on nmv_file to tiptopgp;
grant index on nmv_file to public;
grant select on nmv_file to ods;
