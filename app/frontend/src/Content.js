import {Component} from 'react';
import Grid from '@material-ui/core/Grid';

let tableStyle={ "borderWidth":"1px",
             'borderColor':"#aaaaaa",
             'borderStyle':'solid'}
let contentStyle={  display: 'flex',
                    justifyContent:'center',
                    alignItems:'center'
                }
class Content extends Component {
    constructor(props) {
        super(props)
        this.state = {
            grid : [
                ['','',''],
                ['','',''],
                ['','',''],
            ],
            next : "X", 
            gameOver: false,
            winner : '',
            step: 0
        }
        window.UserLeap('setUserId', props.userEmail);
        window.UserLeap('setEmail', props.userEmail);
    }
    clickHandler(row, column) {
        let currentGrid = this.state.grid
        if (!this.state.gameOver) {
            let next = this.state.next;
            let newGrid = currentGrid;
            newGrid[row][column] = next;
            this.setState({
                grid: newGrid,
                next: next === 'X'? 'O': 'X',
                step: this.state.step + 1
            })

            let diag1Done = true;
            let diag2Done = true;
            for (let i=0; i<3; i++) {
                let rowDone = true;
                let colDone = true;
                for (let j=1; j<3; j++){
                    if (this.state.grid[i][j] !== this.state.grid[i][j-1] ||  this.state.grid[i][j] === '') {
                        rowDone = false;
                    }
                    if (this.state.grid[j][i] !== this.state.grid[j-1][i] ||  this.state.grid[j][i] === '') {
                        colDone = false;
                    }
                }
                if (rowDone || colDone) {
                    this.setState({
                        gameOver: true,
                        winner: this.state.next
                    });
                    window.UserLeap('track', 'test');
                }
                if (i !== 0) {
                    if (this.state.grid[i][i] !== this.state.grid[i-1][i-1] || this.state.grid[i][i] === '') {
                        diag1Done = false
                    }
                    if (this.state.grid[i][3-i] !== this.state.grid[i-1][2-i] || this.state.grid[i][3-i] === '') {
                        diag2Done = false
                    }
                }
            }
            if (diag1Done || diag2Done) {
                this.setState( {
                    gameOver: true,
                    winner: this.state.next
                });
                window.UserLeap('track', 'test');
            }
        }
    }
    getRow(row) {
        let cells=[]
        for(let col=0;col<3; col++) {
            if ( this.state.grid[row][col] === '') {
                cells.push(<td style={tableStyle} onClick={()=> this.clickHandler(row, col)}>
                                &nbsp;&nbsp;&nbsp;&nbsp;
                            </td>)
            } else {
                cells.push(<td style={tableStyle}>
                                &nbsp;{this.state.grid[row][col]}&nbsp;
                            </td>)
            }
        }
        return <tr>{cells}</tr>
    }
    getGrid() {
        let rows=[]
        for (let row=0; row<3; row++){
            rows.push(this.getRow(row))
        }
        return <table><tbody>{rows}</tbody></table>
    }
    render() {
      return (
        <div style={contentStyle}>
            <Grid container spacing={3} direction="row" justify="center" alignItems="stretch" >
            <Grid item>
                {this.getGrid()}
            </Grid>
            <Grid item xs={12}>
            { this.state.gameOver ? <p>Winner {this.state.winner}</p> : <p></p>}
            </Grid>
            <Grid item xs={12}>
            { this.state.step === 9 ? <p>Its a draw</p>: <p></p>}
            </Grid>
            </Grid>
        </div>
        );
    }
  }

export default Content;