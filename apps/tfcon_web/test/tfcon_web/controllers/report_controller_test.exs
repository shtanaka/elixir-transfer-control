defmodule TfconWeb.ReportControllerTest do
  use TfconWeb.ConnCase

  test "GET /day_report", %{conn: conn} do
    conn = get(conn, "/day_report")
    assert html_response(conn, 200) =~ "Transferências de hoje"
  end

  test "GET /month_report", %{conn: conn} do
    conn = get(conn, "/month_report")
    assert html_response(conn, 200) =~ "Transferências do mês"
  end

  test "GET /year_report", %{conn: conn} do
    conn = get(conn, "/year_report")
    assert html_response(conn, 200) =~ "Transferências do ano"
  end

  test "GET /all_time_report", %{conn: conn} do
    conn = get(conn, "/all_time_report")
    assert html_response(conn, 200) =~ "Transferências"
  end
end
