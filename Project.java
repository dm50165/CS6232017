import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Transactions {

	public static void main(String[] args) throws SQLException, IOException, ClassNotFoundException {
		
		// Load the MySQL driver
				Class.forName("com.mysql.jdbc.Driver");
				
				// Connect to the database
				Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/assignments","root","920729");
				
				// For atomicity
				conn.setAutoCommit(false);
				
				// For isolation 
				conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE); 
				
				Statement stmt = null;
				try {
					// create statement object
					stmt = conn.createStatement();
					
					ResultSet rs = stmt.executeQuery("SELECT * FROM Product WHERE prod_id='p1';");
					while(rs.next()){
						System.out.println("prod_id:"+rs.getString("prod_id")+"  pname:"+rs.getString("pname")+"  price:"+rs.getInt("price"));
					}
					// Either the 4 following statements are executed, or none of them are. This is atomicity.
					stmt.executeUpdate("SET FOREIGN_KEY_CHECKS = 0;");
					stmt.executeUpdate("UPDATE Product SET prod_id = 'pp1' WHERE prod_id = 'p1';");
					stmt.executeUpdate("UPDATE Stock SET prod_id = 'pp1' WHERE prod_id = 'p1';");
					stmt.executeUpdate("SET FOREIGN_KEY_CHECKS = 1;");
					
                    rs = stmt.executeQuery("SELECT * FROM Product;");
					while(rs.next()){
						System.out.println("prod_id:"+rs.getString("prod_id")+"  pname:"+rs.getString("pname")+"  price:"+rs.getInt("price"));
					}
					
					rs = stmt.executeQuery("SELECT * FROM Stock");
					while(rs.next()){
						System.out.println("prod_id:"+rs.getString("prod_id")+" dep_id:"+rs.getString("dep_id")+" quantity:"+rs.getInt("quantity"));
					}
					
				} catch (SQLException e) {
					System.out.println("catch Exception");
					// For atomicity
					conn.rollback();
					stmt.close();
					conn.close();
					return;
				} // main
				conn.commit();
				stmt.close();
				conn.close();
	}

}
